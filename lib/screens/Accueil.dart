import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:projetmobile/screens/Gamedetail.dart';
import 'package:projetmobile/screens/Mes likes.dart';
import 'package:projetmobile/screens/Wishlist.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E262C),
      appBar: AppBar(
        backgroundColor:Color(0xFF1E262C) ,
        title: Text("Accueil"),
        actions: [
          IconButton(
            icon: SvgPicture.asset('assets/icons/like.svg'),
            onPressed: ()  { Navigator.push(
                context, MaterialPageRoute(builder: (_) => MyLikesPage()));},
          ),
          IconButton(
            icon: SvgPicture.asset('assets/icons/whishlist.svg'),
            onPressed: () { Navigator.push(
                context, MaterialPageRoute(builder: (_) => MyWishlist()));},
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
      height: 200.0,
      width: 420.0,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/img.png"),
          fit: BoxFit.cover,
        ),
      ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Jeu XYZ",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'proxima',
                color: Colors.white,
              ),
            ),
            Text("Description du jeu en dur",style: TextStyle(fontFamily: 'proxima',
              color: Colors.white,),),
            Expanded(child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.network("https://m.media-amazon.com/images/W/IMAGERENDERING_521856-T1/images/I/81rQIeGFJHL._AC_SX425_.jpg",
                height: 120,)
              ],
            ))
          ],
        ),
      ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Meilleures ventes",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                  fontFamily:'Proxima'
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: 44,
                      minHeight: 44,
                      maxWidth: 64,
                      maxHeight: 64,
                    ),
                    child: Image.network("https://m.media-amazon.com/images/W/IMAGERENDERING_521856-T1/images/I/81rQIeGFJHL._AC_SX425_.jpg", fit: BoxFit.cover),
                  ),
                  title: Text("Nom du jeu \nNom de l'éditeur"),textColor: Colors.white,
                  subtitle: Text("Prix:\$10"),
                  trailing: Container(
                height: 70,
                width: 75,
                decoration: BoxDecoration(
                color: Color(0xFF636af6), borderRadius: BorderRadius.circular(2)),
                child:TextButton(
                    onPressed: () { Navigator.push(
                        context, MaterialPageRoute(builder: (_) => GameDetail()));},
                    child: Text(
                      'En savoir plus',textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 12,fontFamily:'Proxima'),
                    ),
                  ),
                )
                );
              },
            ),
          ),
        ],
      ),
    );
  }}