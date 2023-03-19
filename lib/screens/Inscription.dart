import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:projetmobile/screens/Accueil.dart';
import 'package:projetmobile/screens/Inscription.dart';

class Inscription extends StatefulWidget {
  @override
  _InscriptionState createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _username, _email, _password, _confirmPassword ;

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

                decoration: InputDecoration(
                  filled: true, //<-- SEE HERE
                  fillColor: Color(0xFF1E262C),
                  label: const Center(
                    child: Text("Nom d'utilisateur",style: TextStyle(color: Colors.white),),
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
                decoration: InputDecoration(
                  filled: true, //<-- SEE HERE
                  fillColor: Color(0xFF1E262C),
                  label: const Center(
                    child: Text("E-mail",style: TextStyle(color: Colors.white),),
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
                decoration: InputDecoration(
                  filled: true, //<-- SEE HERE
                  fillColor: Color(0xFF1E262C),
                  label: const Center(
                    child: Text("Mot de passe",style: TextStyle(color: Colors.white),),
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
                decoration: InputDecoration(
                  filled: true, //<-- SEE HERE
                  fillColor: Color(0xFF1E262C),
                  label: const Center(
                    child: Text("Vérification du mot de passe",style: TextStyle(color: Colors.white),),
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
                    "S'inscrire",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }}