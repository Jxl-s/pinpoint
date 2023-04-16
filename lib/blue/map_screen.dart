import 'package:flutter/material.dart';
import 'package:pinpoint/blue/PinPointPage.dart';

class Location {
  String type;
  String distance;
  String name;
  String address;

  Location({
    required this.type,
    required this.distance,
    required this.name,
    required this.address,
  });
}

class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: 0,
      length: 3,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void setLocationAndTab(Location location) {
    setState(() {
      selectedLocation = location;
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _tabController.animateTo(1);
    });
  }

  Location? selectedLocation;

  List<Location> pinnedLocations = [
    Location(
      type: "College",
      distance: "200 m",
      name: "Vanier College",
      address: "821 Sainte Croix Ave, Saint-Laurent, Quebec H4L 3X9",
    ),
  ];

  List<Location> nearbyLocations = [
    Location(
      type: "College",
      distance: "200 m",
      name: "Vanier College",
      address: "821 Sainte Croix Ave, Saint-Laurent, Quebec H4L 3X9",
    ),
    Location(
      type: "Pizza Restaurant",
      distance: "3.2 km",
      name: "Papa John's Pizza",
      address: "1320 De l'Église St, Saint-Laurent, Quebec H4L 2G7",
    ),
    Location(
      type: "Subway Station",
      distance: "33.3 km",
      name: "Metro Cote Vertu",
      address: "1010 Boulevard Cote Vertu Ouest, Saint-Laurent, Quebec H4L",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
                  location.distance,
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
                  setLocationAndTab(location);
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
    String address =
        selectedLocation?.address ?? 'Select a location to view its address';

    bool isSelected = selectedLocation != null;
    Widget buttonRow = isSelected
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {},
                child: Text('ADD PIN',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    )),
              ),
              TextButton(
                onPressed: () {},
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
                  location.distance,
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
                    setLocationAndTab(location);
                  },
                  child: Text(
                    'VIEW ON MAP',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                TextButton(
                  onPressed: () {},
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
