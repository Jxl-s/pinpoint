import 'dart:convert';
import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:pinpoint/blue/classes/user.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pinpoint/blue/services/auth.dart';
import 'package:pinpoint/blue/services/data.dart';

String formatPlaceType(String placeType) {
  String formatted = placeType.replaceAll("_", " ");
  String capitalizedStr =
      formatted.substring(0, 1).toUpperCase() + formatted.substring(1);
  return capitalizedStr;
}

double distanceCalc(double lat1, double lon1, double lat2, double lon2) {
  const R = 6371; // radius of the earth in km

  var dLat = math.pi / 180 * (lat2 - lat1);
  var dLon = math.pi / 180 * (lon2 - lon1);

  var a = math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(math.pi / 180 * (lat1)) *
          math.cos(math.pi / 180 * (lat2)) *
          math.sin(dLon / 2) *
          math.sin(dLon / 2);
  var c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  var d = R * c;

  return d * 1000;
}

class Location {
  String id;
  String type;
  List<double> location = [0.0, 0.0];
  int distance; // in meters
  String name;
  String address;
  bool isAdded = false;

  static final GOOGLE_MAPS_API_KEY =
      "AIzaSyCZ4POmTNuwNXDnnAypsMmg_WGpSNMNxos"; // not mine

  static CollectionReference pinsReference = DataService.collection('pins');
  static Map<String, Location> locationMemo = {};
  static Position? positionMemo = null;

  Location({
    // optional props
    String? id,
    List<double>? location,
    bool? isAdded,

    // required props
    required this.type,
    required this.distance,
    required this.name,
    required this.address,
  })  : id = id ?? '',
        location = location ?? [0.0, 0.0],
        isAdded = isAdded ?? false;

  static Future<Position> getLocation() async {
    if (positionMemo != null) {
      return positionMemo!;
    }

    // check for permissions
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    positionMemo = position;
    return position;
  }

  static Future<bool> hasPinned(Location location) async {
    User? user = await AuthService.getLoggedUser();
    if (user == null) {
      return false;
    }

    // check if the logged user has pinned the location or not;
    QuerySnapshot existingPin =
    await pinsReference.where('author_id', isEqualTo: user.id).where('location_id', isEqualTo: location.id).get();

    if (existingPin.docs.length > 0) {
      location.isAdded = true;
      return true;
    } else {
      location.isAdded = false;
      return false;
    }
  }
  static Future<List<Location>> getNearby() async {
    User? user = await AuthService.getLoggedUser();
    if (user == null) {
      return [];
    }

    // get the current geolocation first
    Position position = await getLocation();
    http.Response res = await http.get(
      Uri.parse(
          "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${position.latitude},${position.longitude}&key=${GOOGLE_MAPS_API_KEY}&rankby=prominence&radius=5000"),
    );

    double positionLat = position.latitude;
    double positionLng = position.longitude;

    var jsonLocations = jsonDecode(res.body);
    List<dynamic> jsonResults = jsonLocations['results'];
    List<Location> locations = [];

    List<Future<QuerySnapshot>> addedQueries = [];
    QuerySnapshot existingPins =
        await pinsReference.where('author_id', isEqualTo: user.id).get();

    // go throuogh the json reuslts, create locations
    Set<String> pinnedIds = {};
    for (int i = 0; i < jsonResults.length; i++) {
      var res = jsonResults[i];

      // check if the docs include res['place_id']
      for (int j = 0; j < existingPins.docs.length; j++) {
        QueryDocumentSnapshot existPin = existingPins.docs[j];
        if (existPin.get('location_id') == res['place_id']) {
          pinnedIds.add(res['place_id']);
        }
      }
    }

    for (int i = 0; i < jsonResults.length; i++) {
      var res = jsonResults[i];
      var existQuery = pinnedIds.contains(res['place_id']);

      double lat = res['geometry']['location']['lat'];
      double lng = res['geometry']['location']['lng'];

      double dist = distanceCalc(lat, lng, positionLat, positionLng);

      locations.add(
        Location(
          id: res['place_id'],
          type: formatPlaceType(res['types'][0]),
          distance: dist.floor(),
          name: res['name'],
          address: res['vicinity'],
          isAdded: existQuery,
          location: [
            lat,
            lng,
          ],
        ),
      );
    }

    // sort locations
    locations.sort((a, b) => a.distance - b.distance);
    return locations;
  }

  static Future<Location> getLocationFromId(String id) async {
    if (locationMemo.containsKey(id)) {
      return locationMemo[id]!;
    }

    var queryRuns = await Future.wait([
      http.get(
        Uri.parse(
            "https://maps.googleapis.com/maps/api/place/details/json?place_id=${id}&key=${GOOGLE_MAPS_API_KEY}"),
      ),
      getLocation()
    ]);

    http.Response res = queryRuns[0] as http.Response;
    Position position = queryRuns[1] as Position;

    double positionLat = position.latitude;
    double positionLng = position.longitude;

    var jsonRes = jsonDecode(res.body);

    double lat = jsonRes['result']['geometry']['location']['lat'];
    double lng = jsonRes['result']['geometry']['location']['lng'];

    locationMemo[id] = Location(
      name: jsonRes['result']['name'],
      address: jsonRes['result']['formatted_address'],
      type: jsonRes['result']['types'][0],
      location: [lat, lng],
      distance: distanceCalc(lat, lng, positionLat, positionLng).floor(),
      id: id,
      isAdded: true,
    );

    return locationMemo[id]!;
  }

  static Future<List<Location>> getPins(User user) async {
    QuerySnapshot locationsQuery =
        await pinsReference.where('author_id', isEqualTo: user.id).get();

    // for each of them, give the appropraite data
    var locationsResults = locationsQuery.docs;
    List<Location> results = [];
    List<Future<Location>> locationQueries = [];

    for (int i = 0; i < locationsResults.length; i++) {
      var loc = locationsResults[i];
      locationQueries.add(getLocationFromId(loc.get('location_id')));
    }

    var locationQueriesRun = await Future.wait(locationQueries);

    for (int i = 0; i < locationQueriesRun.length; i++) {
      var queryResult = locationQueriesRun[i];
      results.add(queryResult);
    }

    return results;
  }

  Future<bool> createPin(User user) async {
    // TODO: create an entry, update the id too
    // check if already exists
    QuerySnapshot existQuery = await pinsReference
        .where('author_id', isEqualTo: user.id)
        .where('location_id', isEqualTo: id)
        .get();

    if (existQuery.docs.isNotEmpty) return false;

    try {
      await pinsReference.add({'author_id': user.id, 'location_id': this.id});

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removePin(User user) async {
    QuerySnapshot existQuery = await pinsReference
        .where('author_id', isEqualTo: user.id)
        .where('location_id', isEqualTo: id)
        .get();

    if (existQuery.docs.isNotEmpty) {
      try {
        await pinsReference.doc(existQuery.docs[0].id).delete();

        return true;
      } catch (e) {
        return false;
      }
    }

    return false;
  }

  static Future<List<Location>> searchLocations(String query) async {
    // Get the user
    User? user = await AuthService.getLoggedUser();
    if (user == null) return [];

    // get the locations that the user has pinned

    var allRuns = await Future.wait([
      http.get(
        Uri.parse(
            "https://maps.googleapis.com/maps/api/place/textsearch/json?key=${GOOGLE_MAPS_API_KEY}&query=${query}"),
      ),
      pinsReference.where('author_id', isEqualTo: user!.id).get(),
      getLocation(),
    ]);

    http.Response searchRequest = allRuns[0] as http.Response;
    QuerySnapshot myPins = allRuns[1] as QuerySnapshot;
    Position position = allRuns[2] as Position;

    var pinsHaveId = (String id) {
      for (int i = 0; i < myPins.docs.length; i++) {
        if (myPins.docs[i].get('location_id') == id) {
          return true;
        }
      }

      return false;
    };

    var jsonResults = jsonDecode(searchRequest.body)['results'];
    List<Location> locations = [];

    double positionLat = position.latitude;
    double positionLng = position.longitude;

    for (int i = 0; i < jsonResults.length; i++) {
      var res = jsonResults[i];
      var isAdded = pinsHaveId(res['place_id']);

      double lat = res['geometry']['location']['lat'];
      double lng = res['geometry']['location']['lng'];

      double dist = distanceCalc(lat, lng, positionLat, positionLng);

      locations.add(
        Location(
          id: res['place_id'],
          type: formatPlaceType(res['types'][0]),
          distance: dist.floor(),
          name: res['name'],
          address: res['formatted_address'],
          isAdded: isAdded,
          location: [
            lat,
            lng,
          ],
        ),
      );
    }

    return locations;
  }

  String getDistanceString() {
    if (this.distance >= 1000) {
      double lengthInKilometers = this.distance / 1000;
      return '${lengthInKilometers.toStringAsFixed(1)} km';
    } else {
      return '${this.distance.toStringAsFixed(0)} m';
    }
  }

  // static List<Location> example(int amount) {
  //   List<Location> locations = [
  //     Location(
  //       id: '1',
  //       type: 'Restaurant',
  //       distance: 500,
  //       name: 'Le Bernardin',
  //       address: '155 W 51st St, New York, NY 10019, United States',
  //     ),
  //     Location(
  //       id: '2',
  //       type: 'Museum',
  //       distance: 2000,
  //       name: 'The Metropolitan Museum of Art',
  //       address: '1000 5th Ave, New York, NY 10028, United States',
  //     ),
  //     Location(
  //       id: '3',
  //       type: 'Park',
  //       distance: 1500,
  //       name: 'Central Park',
  //       address: 'New York, NY 10024, United States',
  //     ),
  //     Location(
  //       id: '4',
  //       type: 'Store',
  //       distance: 300,
  //       name: 'Apple Fifth Avenue',
  //       address: '767 5th Ave, New York, NY 10153, United States',
  //     ),
  //     Location(
  //       id: '5',
  //       type: 'Hotel',
  //       distance: 1000,
  //       name: 'The Ritz-Carlton New York, Central Park',
  //       address: '50 Central Park S, New York, NY 10019, United States',
  //     ),
  //     Location(
  //       id: '5',
  //       type: 'Monument',
  //       distance: 2500,
  //       name: 'Statue of Liberty',
  //       address: 'New York, NY 10004, United States',
  //     ),
  //     Location(
  //       id: '6',
  //       type: 'Theater',
  //       distance: 800,
  //       name: 'Broadway Theatre',
  //       address: '1681 Broadway, New York, NY 10019, United States',
  //     ),
  //     Location(
  //       id: '7',
  //       type: 'Museum',
  //       distance: 3000,
  //       name: 'American Museum of Natural History',
  //       address: 'Central Park W & 79th St, New York, NY 10024, United States',
  //     ),
  //     Location(
  //       id: '8',
  //       type: 'Store',
  //       distance: 500,
  //       name: 'Saks Fifth Avenue',
  //       address: '611 5th Ave, New York, NY 10022, United States',
  //     ),
  //     Location(
  //       id: '9',
  //       type: 'Restaurant',
  //       distance: 700,
  //       name: 'Gramercy Tavern',
  //       address: '42 E 20th St, New York, NY 10003, United States',
  //     ),
  //     Location(
  //       id: '10',
  //       type: 'Monument',
  //       distance: 2000,
  //       name: 'Empire State Building',
  //       address: '20 W 34th St, New York, NY 10001, United States',
  //     ),
  //     Location(
  //       id: '11',
  //       type: 'Hotel',
  //       distance: 600,
  //       name: 'The Langham, New York, Fifth Avenue',
  //       address: '400 5th Ave, New York, NY 10018, United States',
  //     ),
  //     Location(
  //       id: '12',
  //       type: 'Park',
  //       distance: 1000,
  //       name: 'Battery Park',
  //       address: 'New York, NY 10004, United States',
  //     ),
  //     Location(
  //       id: '13',
  //       type: 'Theater',
  //       distance: 1200,
  //       name: 'Lincoln Center Theater',
  //       address: '150 W 65th St, New York, NY 10023, United States',
  //     )
  //   ];
  //
  //   Random random = Random();
  //   List<Location> result = [];
  //
  //   while (result.length < amount) {
  //     final element = locations[random.nextInt(locations.length)];
  //     if (!result.contains(element)) {
  //       result.add(element);
  //     }
  //   }
  //
  //   return result;
  // }
}
