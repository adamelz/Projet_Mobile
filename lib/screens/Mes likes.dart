import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
class MyLikesPage extends StatefulWidget {
  @override
  _MyLikesPageState createState() => _MyLikesPageState();
}

class _MyLikesPageState extends State<MyLikesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF1E262C),
        appBar: AppBar(
        backgroundColor: Color(0xFF1E262C),
    title: Text("Mes Likes"),
    ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           SvgPicture.asset('assets/icons/empty_likes.svg'),


          SizedBox(height: 50.0),
          Text(
            "Vous n'avez encore pas liké de contenu.\n Cliquez sur le cœur pour en rajouter",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.0, color: Colors.white,fontFamily:'Proxima'),
          ),
        ],
      ),
      ),
    );

    }
}