import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:projetmobile/screens/Gamedetail.dart';
import 'package:projetmobile/screens/Mes likes.dart';
import 'package:projetmobile/screens/Wishlist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../services/api_service.dart';



class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {

    //A tester

   /* final userProvider = Provider.of<Users>(context);
    final uid = userProvider.uid;*/

    return Scaffold(
      backgroundColor: Color(0xFF1E262C),
      appBar: AppBar(
        backgroundColor:Color(0xFF1E262C) ,

        //A tester
        //title: Text('User ID: $uid'),


        title: Text("Accueil"),
        actions: [
          IconButton(
            icon: SvgPicture.asset('assets/icons/like.svg'),
            onPressed: ()  {

              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => UserLikedGames(userId: 'oQSrgQpSPjYi1tQ51rL0jLezztC2',)));
              // a modifier avec le bon userID
              },

          ),
          IconButton(
            icon: SvgPicture.asset('assets/icons/whishlist.svg'),
            onPressed: () { Navigator.push(
                context, MaterialPageRoute(builder: (_) => MyWishlist(userId: 'oQSrgQpSPjYi1tQ51rL0jLezztC2')));},
            // a modifier avec le bon userID
          ),
        ],
      ),



      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Rechercher un jeu...",
                hintStyle: TextStyle(color: Colors.white,fontFamily:'Proxima'),
                suffixIcon: Icon(Icons.search, color: Colors.deepPurple,),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Container(
            height: 270.0,
            width: 420.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://cdn.cloudflare.steamstatic.com/steamcommunity/public/images/clans/3381077/88695ecb1922d1881ba9ba14d193a0939a7946e6.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    'CS: GO',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "CS:GO fête son 10ème \n anniversaire !",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  TextButton(
                    onPressed: () { Navigator.push(
                        context, MaterialPageRoute(builder: (_) => GameDetail(appId: '730')));
                      },
                    child: Text(
                      'En savoir plus',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0xFF636af6),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        'https://cdn.cdkeys.com/700x700/media/catalog/product/c/s/cs-go.jpg',
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(alignment: Alignment.centerLeft,
            child: Text(
              "Meilleures ventes", textAlign: TextAlign.left,
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily:'Proxima'
              ),
            ),
          ),
          ),

          Expanded(
            child: FutureBuilder(
              future: fetchData2(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('games').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final games = snapshot.data!.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
                        games.sort((a, b) => a['rank'].compareTo(b['rank']));
                        return ListView.builder(
                          itemCount: games.length,
                          itemBuilder: (context, index) {
                            final game = games[index] != null? games[index] : null;

                            return ListTile(
                                leading: ConstrainedBox(

                                  constraints: BoxConstraints(
                                    minWidth: 44,
                                    minHeight: 44,
                                    maxWidth: 64,
                                    maxHeight: 64,
                                  ),

                                  child: Image.network( game?['image'], fit: BoxFit.cover),
                                  ),
                                 title: Text(game?['name'] + '\n' + game?['developer']),textColor: Colors.white,
                                subtitle: Text(game?['price']),
                                trailing: Container(
                                  height: 70,
                                  width: 75,
                                  decoration: BoxDecoration(
                                      color: Color(0xFF636af6), borderRadius: BorderRadius.circular(2)
                                  ),
                                  child: TextButton(
                                    onPressed: () {

                                          String? id = game?['appid'].toString();

                                      Navigator.push(
                                       context, MaterialPageRoute(builder: (_) => GameDetail(appId: id)));},

                                    child: Text(
                                      'En savoir plus',textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white, fontSize: 12,fontFamily:'Proxima'),
                                    ),
                                  ),
                                )
                            );

                          },
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          )


        ],
      ),

    );
  }}