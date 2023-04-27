import 'package:flutter/material.dart';
import 'package:pinpoint/blue/classes/location.dart';
import 'package:pinpoint/blue/classes/user.dart';
import 'package:pinpoint/blue/map_screen.dart';
import 'package:pinpoint/blue/my_pins_screen.dart';
import 'package:pinpoint/blue/services/auth.dart';
import './components/drawer.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Location> searchResults = [];
  bool isSearching = false;

  Future<void> searchLocations(String query) async {
    setState(() {
      isSearching = true;
    });

    User? loggedUser = await AuthService.getLoggedUser();
    if (loggedUser == null) return;

    List<Location> found = await Location.searchLocations(query);
    setState(() {
      searchResults = found;
      isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: PinPointDrawer(
          title: 'Location Search',
        ),
        appBar: AppBar(
          title: Text(
            "PinPoint - Search",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          // add the temporary drawer thing here
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              children: [
                Text(
                  isSearching ? 'Searching ...' : 'Search Locations',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  child: TextField(
                    // controller: _searchFieldController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search Locations',
                    ),
                    onSubmitted: ((value) {
                      searchLocations(value);
                    }),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                child: ListView(
                  children: searchResults.map((e) => SearchResultCard(e))
                      .toList(),
                ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget SearchResultCard(Location location) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.black.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: location.isAdded
                            ? Theme
                            .of(context)
                            .primaryColor
                            : Colors.black.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      formatPlaceType(location.type),
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Text(
                  location.getDistanceString(),
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2, bottom: 4),
              child: Text(
                location.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Text(
              location.address,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapScreen(location),
                    ),
                  );
                },
                child: Text(
                  'VIEW ON MAP',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
