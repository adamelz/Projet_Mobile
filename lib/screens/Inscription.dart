import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:projetmobile/models/user.dart';
import 'package:projetmobile/screens/Accueil.dart';
import 'package:projetmobile/screens/Inscription.dart';
import 'package:projetmobile/models/user.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Inscription extends StatefulWidget {
  @override
  _InscriptionState createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _username, _email, _password, _confirmPassword ;

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();



  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;


  Future<void> _register() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (userCredential.user != null) {

        String userId = userCredential.user!.uid;
        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'username': _usernameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
        });
        Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage()));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    child: Text('Inscription',textAlign: TextAlign.center,style: TextStyle(fontFamily:'Proxima',fontWeight: FontWeight.bold,fontSize: 30,color: Colors.white),)),

              ),
            ),
            Padding(
              padding: const EdgeInsets.only(),
              child: Center(
                  child: Text("Veuillez saisir ces différentes informations, \n afin que vos listes soient sauvegardées. ",textAlign: TextAlign.center,style: TextStyle(fontFamily:'Proxima',color: Colors.white),)),
            ),
            SizedBox(height: 50),

            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 25),
              child:TextFormField(
                controller: _usernameController,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true, //<-- SEE HERE
                  fillColor: Color(0xFF1E262C),
                  label: const Center(
                    child: Text("Nom d'utilisateur",style: TextStyle(fontFamily:'Proxima',color: Colors.white),),
                  ),
                ),
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'Entrez un nom d\'utilisateur';
                  }
                  return null;
                },
                onSaved: (value) => _username = value,
              ),
            ),

            SizedBox(height: 20.0),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 25),
              child:TextFormField(
                controller: _emailController,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true, //<-- SEE HERE
                  fillColor: Color(0xFF1E262C),
                  label: const Center(
                    child: Text("E-mail",style: TextStyle(fontFamily:'Proxima',color: Colors.white),),
                  ),
                ),
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'Entrez une adresse e-mail';
                  }
                  return null;
                },
                onSaved: (value) => _email = value,
              ),
            ),
            SizedBox(height: 20.0),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 25),
              child:TextFormField(
                controller: _passwordController,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true, //<-- SEE HERE
                  fillColor: Color(0xFF1E262C),
                  label: const Center(
                    child: Text("Mot de passe",style: TextStyle(fontFamily:'Proxima',color: Colors.white),),
                  ),
                ),
                obscureText: true,
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'Entrez un mot de passe';
                  }
                  return null;
                },
                onSaved: (value) => _password = value,
              ),
            ),
            SizedBox(height: 20.0),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: TextFormField(
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true, //<-- SEE HERE
                  fillColor: Color(0xFF1E262C),
                  label: const Center(
                    child: Text("Vérification du mot de passe",style: TextStyle(fontFamily:'Proxima',color: Colors.white),),
                  ),
                ),
                obscureText: true,
                validator: (String?value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer à nouveau votre mot de passe';
                  }
                  if (value != _password) {
                    return 'Les mots de passe ne correspondent pas';
                  }
                  return null;
                },
                onSaved: (value) => _confirmPassword = value,
              ),
            ),
            SizedBox(height: 20.0),
      Padding(
        //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
        padding: EdgeInsets.symmetric(horizontal: 25),
            child:Container(
              height: 50,
              width: 350,
              decoration: BoxDecoration(
                  color: Color(0xFF636af6), borderRadius: BorderRadius.circular(5)),
              child: TextButton(
                onPressed: ()  {

                 // if (_formKey.currentState!.validate()) {


                    _register();
                 // }
                },
                child: Text(
                  "S'inscrire",
                  style: TextStyle(fontFamily:'Proxima',color: Colors.white, fontSize: 15),
                ),
              ),
            ),
      ),
          ],
        ),
      ),
    );
  }}


