import 'package:flutter/material.dart';

class FriendList extends StatelessWidget {
  const FriendList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text('Friends'),
            SizedBox(
              width: 375,
              height: 50,
              child: TextField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search Friends',
                ),
              ),
            ),
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
                  FriendCard("Fruite Baskette", "baf@gmail.com", 'https://www.koimoi.com/wp-content/new-galleries/2022/09/chris-hemsworth-talks-about-his-return-as-thor-unfortunately-he-isnt-sure-if-he-will-001.jpg'),
                  FriendCard("Clash Clans", "cock@gmail.com", 'https://avatarfiles.alphacoders.com/291/291338.jpg'),
                  FriendCard("Martial Banana", "fruits@gmail.com", 'https://online.hitpaw.com/images/topics/background-remover/meme-pfp.jpg'),
                  FriendCard("Feel Me BAbyyyy", "sexy@gmail.com", 'https://i.ytimg.com/vi/FppQQfu1-hc/mqdefault.jpg'),
                  FriendCard("LOSing BrainCelsz", "wutInTheWorld@gmail.com", 'https://e7.pngegg.com/pngimages/85/338/png-clipart-donald-duck-youtube-character-know-your-meme-donald-duck-hat-heroes.png'),
                  FriendCard("g eqqhbq gq 1t134g13h3", "jafio@gmail.com", 'https://online.hitpaw.com/images/topics/background-remover/cartoon-pfp.jpg'),
                  FriendCard("....", "wtf@gmail.com", 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRupbJacsoD_dCYa8g469E8TU06BzfJLUzdt6wb_9wlqV62JWhGbwXYFxY5TctMjYzqCBk&usqp=CAU')
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(onPressed: () {}, child: Text('Message')),
              TextButton(onPressed: () {}, child: Text('View Notes')),
              TextButton(onPressed: () {}, child: Text('Remove Friend', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold ),)),
            ],
          )
        ],
      ),
    );
  }
}
