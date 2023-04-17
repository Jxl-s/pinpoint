import 'dart:math';

import 'package:pinpoint/blue/classes/user.dart';

class Location {
  int id;
  String type;
  int distance; // in meters
  String name;
  String address;

  Location({
    // optional props
    int? id,

    // required props
    required this.type,
    required this.distance,
    required this.name,
    required this.address,
  }): id = id ?? 0;

  static Future<List<Location>> getNearby() async {
    // TODO: actually implmenent it
    return Location.example(5);
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
        id: 1,
        type: 'Restaurant',
        distance: 500,
        name: 'Le Bernardin',
        address: '155 W 51st St, New York, NY 10019, United States',
      ),
      Location(
        id: 2,
        type: 'Museum',
        distance: 2000,
        name: 'The Metropolitan Museum of Art',
        address: '1000 5th Ave, New York, NY 10028, United States',
      ),
      Location(
        id: 3,
        type: 'Park',
        distance: 1500,
        name: 'Central Park',
        address: 'New York, NY 10024, United States',
      ),
      Location(
        id: 4,
        type: 'Store',
        distance: 300,
        name: 'Apple Fifth Avenue',
        address: '767 5th Ave, New York, NY 10153, United States',
      ),
      Location(
        id: 5,
        type: 'Hotel',
        distance: 1000,
        name: 'The Ritz-Carlton New York, Central Park',
        address: '50 Central Park S, New York, NY 10019, United States',
      ),
      Location(
        id: 5,
        type: 'Monument',
        distance: 2500,
        name: 'Statue of Liberty',
        address: 'New York, NY 10004, United States',
      ),
      Location(
        id: 6,
        type: 'Theater',
        distance: 800,
        name: 'Broadway Theatre',
        address: '1681 Broadway, New York, NY 10019, United States',
      ),
      Location(
        id: 7,
        type: 'Museum',
        distance: 3000,
        name: 'American Museum of Natural History',
        address: 'Central Park W & 79th St, New York, NY 10024, United States',
      ),
      Location(
        id: 8,
        type: 'Store',
        distance: 500,
        name: 'Saks Fifth Avenue',
        address: '611 5th Ave, New York, NY 10022, United States',
      ),
      Location(
        id: 9,
        type: 'Restaurant',
        distance: 700,
        name: 'Gramercy Tavern',
        address: '42 E 20th St, New York, NY 10003, United States',
      ),
      Location(
        id: 10,
        type: 'Monument',
        distance: 2000,
        name: 'Empire State Building',
        address: '20 W 34th St, New York, NY 10001, United States',
      ),
      Location(
        id: 11,
        type: 'Hotel',
        distance: 600,
        name: 'The Langham, New York, Fifth Avenue',
        address: '400 5th Ave, New York, NY 10018, United States',
      ),
      Location(
        id: 12,
        type: 'Park',
        distance: 1000,
        name: 'Battery Park',
        address: 'New York, NY 10004, United States',
      ),
      Location(
        id: 13,
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
