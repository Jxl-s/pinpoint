import 'package:flutter/material.dart';
import './nearby_item.dart';

class NearbyScreen extends StatelessWidget {
  const NearbyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PinPoint',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text("NEARBY")),
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
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(10),
            children: [
              NearbyItem(
                distance: '15m',
                name: 'Vanier College',
                address: '821 Av. Sainte-Croix, Saint-Laurent, QC H4L 3X9',
                type: 'College',
              ),
              NearbyItem(
                distance: '200.3m',
                name: 'Maison O The',
                address: '3131 Bd Cote Vertu Ouest, St-Laurent, QC H4R 1Y8',
                type: 'Bubble Tea Shop',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
