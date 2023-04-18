import 'package:flutter/material.dart';
import 'package:pinpoint/blue/classes/location.dart';
import 'package:pinpoint/blue/classes/user.dart';
import 'package:pinpoint/blue/components/confirm_dialog.dart';
import 'package:pinpoint/blue/components/drawer.dart';
import 'package:pinpoint/blue/services/auth.dart';

class MapScreen extends StatefulWidget {
  Location? location;

  MapScreen([Location? location]) {
    this.location = location;
  }

  @override
  State<MapScreen> createState() => _MapScreenState(this.location);
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  Location? selectedLocation;

  List<Location> nearbyLocations = [];
  List<Location> pinnedLocations = [];

  Future<void> fetchData() async {
    User? user = await AuthService.getLoggedUser();

    if (user != null) {
      List<Location> nearby = await Location.getNearby();
      List<Location> pins = await Location.getPins(user);

      setState(() {
        nearbyLocations = nearby;
        pinnedLocations = pins;
      });
    }
  }

  _MapScreenState([Location? location]) {
    this.selectedLocation = location;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: 0,
      length: 3,
      vsync: this,
    );

    if (this.selectedLocation != null) {
      this._tabController.animateTo(1);
    }

    fetchData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Helper for transitioning
  void viewOnMap(Location location) {
    setState(() {
      selectedLocation = location;
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _tabController.animateTo(1);
    });
  }

  // Data functions
  bool shareLocation(Location? location) {
    if (location == null) return false;
    return true;
  }

  Future<bool> addPin(Location? location) async {
    User? user = await AuthService.getLoggedUser();
    if (location == null) return false;
    if (user == null) return false;

    return location.createPin(user!);
  }

  Future<bool> removePin(Location? location) async {
    User? user = await AuthService.getLoggedUser();
    if (location == null) return false;
    if (user == null) return false;

    return location.removePin(user!);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: PinPointDrawer(
          title: 'Map View',
        ),
        appBar: AppBar(
          title: Text(
            "PinPoint - Map",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                text: "NEARBY",
              ),
              Tab(
                text: "MAP",
              ),
              Tab(
                text: "PINS",
              )
            ],
          ),
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
          child: TabBarView(
            controller: _tabController,
            children: [
              NearbyPage(),
              MapPage(),
              PinsPage(),
            ],
          ),
        ),
      ),
    );
  }

  Widget NearbyPage() {
    return ListView(
      children: nearbyLocations.map((e) => NearbyCard(e)).toList(),
    );
  }

  Widget NearbyCard(Location location) {
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
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      location.type,
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
                  viewOnMap(location);
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

  Widget MapPage() {
    String name = selectedLocation?.name ?? 'No selected location';
    String address = selectedLocation?.address ??
        'Select a location to view its information';

    bool isSelected = selectedLocation != null;
    Widget buttonRow = isSelected
        ? Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {
            addPin(selectedLocation);
          },
          child: Text(
            'ADD PIN',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            shareLocation(selectedLocation);
          },
          child: Text(
            'SHARE',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    )
        : Row();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Placeholder(),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
                textAlign: TextAlign.start,
              ),
              Text(
                address,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
              buttonRow
            ],
          ),
        )
      ],
    );
  }

  Widget PinsPage() {
    return ListView(
      children: pinnedLocations.map((e) => PinnedCard(e)).toList(),
    );
  }

  Widget PinnedCard(Location location) {
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
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      location.type,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    viewOnMap(location);
                  },
                  child: Text(
                    'VIEW ON MAP',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    showConfirmationDialog(
                        context: context,
                        title: 'Remove Pin?',
                        cancel: 'Cancel',
                        submit: Text(
                          'Yes, remove',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () async {
                          bool success = await removePin(location);
                          if (success) {
                            // remove the entry from the list
                            setState(() {
                              pinnedLocations.remove(location);
                            });
                          }
                        });
                  },
                  child: Text(
                    'REMOVE PIN',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
