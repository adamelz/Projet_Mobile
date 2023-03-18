import 'package:flutter/material.dart';

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
          Icon(
            Icons.favorite_border,
            size: 48.0,
            color: Colors.red,
          ),
          SizedBox(height: 16.0),
          Text(
            "Vous n'avez encore pas liké de contenu. Cliquez sur le cœur pour en rajouter",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
      ),
    );

    }
}