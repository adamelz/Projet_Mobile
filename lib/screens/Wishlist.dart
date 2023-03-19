import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
class MyWishlist extends StatefulWidget {
  @override
  _MyWishlistState createState() => _MyWishlistState();
}

class _MyWishlistState extends State<MyWishlist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E262C),
      appBar: AppBar(
        backgroundColor: Color(0xFF1E262C),
        title: Text("Ma liste de souhaits"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/icons/empty_whishlist.svg'),


            SizedBox(height: 50.0),
            Text(
              "Vous n'avez encore pas liké de contenu.\n Cliquez sur l'étoile pour en rajouter",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0, color: Colors.white,fontFamily:'Proxima'),
            ),
          ],
        ),
      ),
    );

  }
}