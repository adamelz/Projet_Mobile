import 'package:flutter/material.dart';
import 'package:projetmobile/screens/Accueil.dart';
import 'package:projetmobile/screens/Inscription.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projetmobile/services/api_service.dart';



Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  await fetchData2(); //On charge les jeux dans la BDD
  runApp(MyApp());


}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginDemo(),
      title: 'Custom Fonts',
      theme: ThemeData(fontFamily: 'Proxima'),
      debugShowCheckedModeBanner: false,

    );

  }
}


class LoginDemo extends StatefulWidget {
  @override
  _LoginDemoState createState() => _LoginDemoState();
}

class _LoginDemoState extends State<LoginDemo> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool showSignIn = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  //On compare avec les user de la base d'authentification
  Future<void> _handleSignIn(BuildContext context) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('User ${userCredential.user?.uid} signed in');
      //On lance l'app en mémorisant l'ID de l'user
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => HomePage(userid: userCredential.user?.uid ?? '')),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Utilisateur introuvable'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }  else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

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
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: TextField(
                controller: _emailController,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFF1E262C),
                  label: const Center(
                    child: Text(
                      "E-mail",
                      style: TextStyle(fontFamily:'Proxima',color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.only(left: 25.0, right: 25.0, top: 15),
              child: TextField(
                controller: _passwordController,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFF1E262C),
                  label: const Center(
                    child: Text(
                      "Mot de passe",
                      style: TextStyle(fontFamily:'Proxima',color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 50),
            Container(
              height: 50,
              width: 350,
              decoration: BoxDecoration(
                  color: Color(0xFF636af6),
                  borderRadius: BorderRadius.circular(5)),
              child: TextButton(
                onPressed: () async {
                  _handleSignIn(context);

                },
                child: Text(
                  'Se connecter',
                  style: TextStyle(fontFamily:'Proxima',color: Colors.white, fontSize: 15),
                ),
              ),
            ),
            SizedBox(height: 15),
            Container(
              height: 50,
              width: 350,
              decoration: BoxDecoration(
                  border: Border.all(width: 3, color: Color(0xFF636af6)),
                  color: Color(0xFF1a2025),
                  borderRadius: BorderRadius.circular(5)),
              child: TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => Inscription())); //Pas de compte alors aller vers l'inscription
                },
                child: Text(
                  'Créer un nouveau compte',
                  style: TextStyle(fontFamily:'Proxima',color: Colors.white, fontSize: 15),
                ),
              ),
            ),
            SizedBox(
              height: 130,
            )
            // ...
          ],
        ),
      ),
    );
  }
}
