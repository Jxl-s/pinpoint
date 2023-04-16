import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NearbyItem extends StatelessWidget {
  NearbyItem({
    Key? key,
    required this.distance,
    required this.type,
    required this.name,
    required this.address,
  }) : super(key: key);

  String distance;
  String type;
  String name;
  String address;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Container(
        padding: EdgeInsets.only(top: 15, left: 15, right: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black, blurRadius: 4),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  distance,
                  style: TextStyle(
                      fontSize: 18,
                      color: Color.fromRGBO(0, 0, 0, 0.5),
                      fontFamily: "Poppins"),
                ),
                Text(
                  type,
                  style: TextStyle(
                      fontSize: 18,
                      color: Color.fromRGBO(0, 0, 0, 0.5),
                      fontFamily: "Poppins"),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text(name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ))
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Flexible(
                  child: Text(
                    address,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromRGBO(0, 0, 0, 0.5),
                    ),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text('View on Map'),
                TextButton(
                  style: TextButton.styleFrom(
                    fixedSize: Size.fromHeight(5),
                  ),
                  onPressed: () {},
                  child: Text(
                    'VIEW ON MAP',
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    fixedSize: Size.fromHeight(5),
                  ),
                  onPressed: () {},
                  child: Text(
                    'SHARE',
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}