import 'dart:convert';
import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:pinpoint/blue/classes/user.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;

String formatPlaceType(String placeType) {
  String formatted = placeType.replaceAll("_", " ");
  return formatted;
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

  return d;
}

class Location {
  String id;
  String type;
  List<double> location = [0.0, 0.0];
  int distance; // in meters
  String name;
  String address;

  static final GOOGLE_MAPS_API_KEY =
      "AIzaSyCZ4POmTNuwNXDnnAypsMmg_WGpSNMNxos"; // not mine

  Location({
    // optional props
    String? id,
    List<double>? location,

    // required props
    required this.type,
    required this.distance,
    required this.name,
    required this.address,
  })  : id = id ?? '',
        location = location ?? [0.0, 0.0];

  static Future<Position> getLocation() async {
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

    return position;
  }

  static Future<List<Location>> getNearby() async {
    // TODO: actually implmenent it
    // get the current geolocation first
    Position position = await getLocation();

    double fakeLat = 45.5019268;
    double fakeLng = -73.6731421;

    http.Response res = await http.get(
      Uri.parse(
          "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${45.5019268},${-73.6731421}&key=${GOOGLE_MAPS_API_KEY}&radius=5000"),
    );

    var jsonLocations = jsonDecode(res.body);
    List<dynamic> jsonResults = jsonLocations['results'];
    List<Location> locations = [];

    // go throuogh the json reuslts, create locations
    for (int i = 0; i < jsonResults.length; i++) {
      var res = jsonResults[i];

      double lat = res['geometry']['location']['lat'];
      double lng = res['geometry']['location']['lng'];

      double dist =
          distanceCalc(lat, lng, fakeLat, fakeLng);

      locations.add(
        Location(
          id: res['place_id'],
          type: formatPlaceType(res['types'][0]),
          distance: dist.floor(),
          name: res['name'],
          address: res['vicinity'],
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

  static Future<List<Location>> getPins(User user) async {
    // TODO: using the user.id make it work for real
    return Location.example(5);
  }

  Future<bool> createPin(User user) async {
    // TODO: create an entry, update the id too
    return true;
  }

  Future<bool> removePin(User user) async {
    // TODO: create an entry, update the id too
    return true;
  }

  String getDistanceString() {
    if (this.distance >= 1000) {
      double lengthInKilometers = this.distance / 1000;
      return '${lengthInKilometers.toStringAsFixed(1)} km';
    } else {
      return '${this.distance.toStringAsFixed(0)} m';
    }
  }

  static List<Location> example(int amount) {
    List<Location> locations = [
      Location(
        id: '1',
        type: 'Restaurant',
        distance: 500,
        name: 'Le Bernardin',
        address: '155 W 51st St, New York, NY 10019, United States',
      ),
      Location(
        id: '2',
        type: 'Museum',
        distance: 2000,
        name: 'The Metropolitan Museum of Art',
        address: '1000 5th Ave, New York, NY 10028, United States',
      ),
      Location(
        id: '3',
        type: 'Park',
        distance: 1500,
        name: 'Central Park',
        address: 'New York, NY 10024, United States',
      ),
      Location(
        id: '4',
        type: 'Store',
        distance: 300,
        name: 'Apple Fifth Avenue',
        address: '767 5th Ave, New York, NY 10153, United States',
      ),
      Location(
        id: '5',
        type: 'Hotel',
        distance: 1000,
        name: 'The Ritz-Carlton New York, Central Park',
        address: '50 Central Park S, New York, NY 10019, United States',
      ),
      Location(
        id: '5',
        type: 'Monument',
        distance: 2500,
        name: 'Statue of Liberty',
        address: 'New York, NY 10004, United States',
      ),
      Location(
        id: '6',
        type: 'Theater',
        distance: 800,
        name: 'Broadway Theatre',
        address: '1681 Broadway, New York, NY 10019, United States',
      ),
      Location(
        id: '7',
        type: 'Museum',
        distance: 3000,
        name: 'American Museum of Natural History',
        address: 'Central Park W & 79th St, New York, NY 10024, United States',
      ),
      Location(
        id: '8',
        type: 'Store',
        distance: 500,
        name: 'Saks Fifth Avenue',
        address: '611 5th Ave, New York, NY 10022, United States',
      ),
      Location(
        id: '9',
        type: 'Restaurant',
        distance: 700,
        name: 'Gramercy Tavern',
        address: '42 E 20th St, New York, NY 10003, United States',
      ),
      Location(
        id: '10',
        type: 'Monument',
        distance: 2000,
        name: 'Empire State Building',
        address: '20 W 34th St, New York, NY 10001, United States',
      ),
      Location(
        id: '11',
        type: 'Hotel',
        distance: 600,
        name: 'The Langham, New York, Fifth Avenue',
        address: '400 5th Ave, New York, NY 10018, United States',
      ),
      Location(
        id: '12',
        type: 'Park',
        distance: 1000,
        name: 'Battery Park',
        address: 'New York, NY 10004, United States',
      ),
      Location(
        id: '13',
        type: 'Theater',
        distance: 1200,
        name: 'Lincoln Center Theater',
        address: '150 W 65th St, New York, NY 10023, United States',
      )
    ];

    Random random = Random();
    List<Location> result = [];

    while (result.length < amount) {
      final element = locations[random.nextInt(locations.length)];
      if (!result.contains(element)) {
        result.add(element);
      }
    }

    return result;
  }
}
