import 'package:flutter/material.dart';

class FriendsScreenRequest extends StatelessWidget {
  const FriendsScreenRequest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text('Requests'),
            Container(
              height: 629,
              width: double.maxFinite,
              child: ListView(
                shrinkWrap: true,
                children: [
                  FriendCard("Jax Suan Luh", "jsl@gmail.com", 'https://googleflutter.com/sample_image.jpg'),
                  FriendCard("Tuh Chahsze", "ts@gmail.com", 'https://ichef.bbci.co.uk/news/976/cpsprodpb/F382/production/_123883326_852a3a31-69d7-4849-81c7-8087bf630251.jpg'),
                  FriendCard("Billy Duck", "bd@gmail.com", 'https://img.freepik.com/premium-vector/young-girl-anime-style-character-vector-illustration-design-manga-anime-girl_147933-100.jpg?w=2000'),
                  FriendCard("Modsi Mododoo", "mm@gmail.com", 'https://hips.hearstapps.com/hmg-prod/images/dwayne-the-rock-johnson-gettyimages-1061959920.jpg?crop=0.5625xw:1xh;center,top&resize=1200:*'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget FriendCard(String name, String email, String image) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      width: 450,
      height: 98,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(
                          image),
                      fit: BoxFit.fill),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(email),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(onPressed: () {}, child: Text('Accept Friend Request', style: TextStyle(fontWeight: FontWeight.bold),)),
            ],
          )
        ],
      ),
    );
  }
}
