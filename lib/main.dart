import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:projetmobile/screens/Accueil.dart';
import 'package:projetmobile/screens/Inscription.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Fonts',
      theme: ThemeData(fontFamily: 'Proxima'),
      debugShowCheckedModeBanner: false,
      home: LoginDemo(),
    );
  }
}

class LoginDemo extends StatefulWidget {
  @override
  _LoginDemoState createState() => _LoginDemoState();
}

class _LoginDemoState extends State<LoginDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/Background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top:80.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 50,
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: Text('Bienvenue !',textAlign: TextAlign.center,style: TextStyle(fontFamily:'Proxima',fontWeight: FontWeight.bold,fontSize: 30,color: Colors.white),)),

              ),
            ),
            Padding(
              padding: const EdgeInsets.only(),
              child: Center(
                    child: Text("Veuillez vous connecter ou\n créer un nouveau compte\n pour utiliser l'application. ",textAlign: TextAlign.center,style: TextStyle(fontFamily:'Proxima',color: Colors.white),)),
              ),
            SizedBox(height: 50),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: TextField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  filled: true, //<-- SEE HERE
                  fillColor: Color(0xFF1E262C),

                  label: const Center(
                    child: Text("E-mail",style: TextStyle(color: Colors.white),),
                  ),
                   ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 25.0, right: 25.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true, //<-- SEE HERE
                  fillColor: Color(0xFF1E262C),

                  label: const Center(
                    child: Text("Mot de passe",style: TextStyle(color: Colors.white),),
                  ),
                   ),
              ),
            ),
            SizedBox(height: 50),
            Container(
              height: 50,
              width: 350,
              decoration: BoxDecoration(
                  color: Color(0xFF636af6), borderRadius: BorderRadius.circular(5)),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => HomePage()));
                },
                child: Text(
                  'Se connecter',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
            SizedBox(height: 15),
            Container(

              height: 50,
              width: 350,
              decoration: BoxDecoration(
                  border: Border.all(width: 3, color:Color(0xFF636af6)),
                  color: Color(0xFF1a2025), borderRadius: BorderRadius.circular(5)),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => Inscription()));
                },
                child: Text(

                  'Créer un nouveau compte',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
            SizedBox(
              height: 130,
            ),
          ],
        ),
      ),
    );
  }
}


