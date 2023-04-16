import 'package:flutter/material.dart';
import './search_item.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PinPoint',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text("SEARCH")),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromRGBO(252, 107, 98, 1),
                Color.fromRGBO(248, 209, 151, 1)
              ],
            ),
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 175,
                    child: Text("map will go here"),
                  ),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(10),
                      children: [
                        SearchItem(
                          distance: '15m',
                          name: 'Vanier Colge',
                          address:
                              '821 Av. Sainte-Croix, Saint-Laurent, QC H4L 3X9',
                          type: 'College',
                        ),
                        SearchItem(
                          distance: '200.3m',
                          name: 'Maison O The',
                          address:
                              '3131 Bd Cote Vertu Ouest, St-Laurent, QC H4R 1Y8',
                          type: 'Bubble Tea Shop',
                        ),
                        SearchItem(
                          distance: '200.3m',
                          name: 'Maison O The',
                          address:
                              '3131 Bd Cote Vertu Ouest, St-Laurent, QC H4R 1Y8',
                          type: 'Bubble Tea Shop',
                        ),
                        SearchItem(
                          distance: '200.3m',
                          name: 'Maison O The',
                          address:
                              '3131 Bd Cote Vertu Ouest, St-Laurent, QC H4R 1Y8',
                          type: 'Bubble Tea Shop',
                        ),
                        SearchItem(
                          distance: '200.3m',
                          name: 'Maison O The',
                          address:
                              '3131 Bd Cote Vertu Ouest, St-Laurent, QC H4R 1Y8',
                          type: 'Bubble Tea Shop',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 10,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Search',
                        contentPadding: EdgeInsets.all(10.0),
                      ),
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w100,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
