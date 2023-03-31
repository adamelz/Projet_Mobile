import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Gamedetail.dart';

class MyWishlist extends StatelessWidget {
  late final String userId;

  MyWishlist({required this.userId});

  @override
  Widget build(BuildContext context) {
    CollectionReference usersRef = FirebaseFirestore.instance.collection('users');

    return Scaffold(
      backgroundColor: Color(0xFF1E262C),
      appBar: AppBar(
        backgroundColor: Color(0xFF1E262C),
        title: Text("Ma liste de souhaits"),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: usersRef.doc(userId).get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Une erreur est survenue: ${snapshot.error}");
          }

          if (snapshot.hasData && snapshot.data!.exists) {
            List<dynamic> wishedGames = snapshot.data!.get('wishedGames');

            if (wishedGames.isEmpty) {
              return Center(
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
              );
            }

            return ListView.builder(
              padding: EdgeInsets.only(top: 10.0), // Ajouter un Padding en haut
              itemCount: wishedGames.length,
              itemBuilder: (BuildContext context, int index) {
                String gameId = wishedGames[index];

                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection('games').doc(gameId).get(),
                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text("Une erreur est survenue: ${snapshot.error}");
                    }

                    if (snapshot.hasData && snapshot.data!.exists) {
                      Map<String, dynamic>? data = snapshot.data!.data() as Map<String, dynamic>?;
                      if (data != null) {
                        String gameName = data['name'] ?? "";
                        String gameImage = data['image'] ?? "";
                        String gameDescription = data['description'] ?? "";
                        String gameDev = data['developer'] ?? "";
                        String gameback = data['background'] ?? "";
                        String gamePrice = data['price'] ?? "";

                        return Container (
                          margin: EdgeInsets.only(bottom: 10.0,left: 10.0,  right: 10.0),

                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(gameback),
                              fit: BoxFit.cover,
                            ),
                          ),

                          child: ListTile(
                            leading: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: 44,
                                minHeight: 44,
                                maxWidth: 128,
                                maxHeight: 128,
                              ),
                              child: Image.network(
                                  gameImage, fit: BoxFit.cover),
                            ),
                            title: Text(
                              gameName + '\n' + gameDev + '\n',
                              style: TextStyle(color: Colors.white,
                                fontSize: 13,),
                            ),
                            subtitle: Text(
                              gamePrice,
                              style: TextStyle(color: Colors.white,
                                fontSize: 11,
                                decoration: TextDecoration.underline,),
                            ),

                            trailing: Container(
                              height: 70,
                              width: 75,
                              decoration: BoxDecoration(
                                color: Color(0xFF636af6),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  String? id = gameId.toString();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          GameDetail(
                                              appId: id, userid: userId),
                                    ),
                                  );
                                },
                                child: Text(
                                  'En savoir plus',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontFamily: 'Proxima',
                                  ),
                                ),
                              ),
                            ),

                          ),
                        );
                      }
                    }

                    return SizedBox();
                  },
                );
              },
            );
          }

          return SizedBox();
        },
      ),
    );
  }
}