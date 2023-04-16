import 'package:flutter/material.dart';
import 'package:pinpoint/blue/PinPointPage.dart';

class MapScreen extends PinPointScreen {
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
      children: [
        NearbyCard(
          type: "College",
          distance: "200 m",
          name: "Vanier College",
          address: "821 Sainte Croix Ave, Saint-Laurent, Quebec H4L 3X9",
        ),
        NearbyCard(
          type: "Pizza Restaurant",
          distance: "3.2 km",
          name: "Papa John's Pizza",
          address: "1320 De l'Église St, Saint-Laurent, Quebec H4L 2G7",
        ),
        NearbyCard(
          type: "Subway Station",
          distance: "33.3 km",
          name: "Metro Cote Vertu",
          address: "1010 Boulevard Cote Vertu Ouest, Saint-Laurent, Quebec H4L",
        ),
      ],
    );
  }

  Widget NearbyCard({
    required String type,
    required String distance,
    required String name,
    required String address,
  }) {
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
                      type,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Text(
                  distance,
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
                name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Text(
              address,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {},
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
    return Placeholder();
  }

  Widget PinsPage() {
    return Placeholder();
  }
}
