import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Gamedetail.dart';


class UserLikedGames extends StatelessWidget {
  late final String userId;

  UserLikedGames({required this.userId});

  @override
  Widget build(BuildContext context) {
    CollectionReference usersRef = FirebaseFirestore.instance.collection('users');

    return Scaffold(
      backgroundColor: Color(0xFF1E262C),
      appBar: AppBar(
        backgroundColor: Color(0xFF1E262C),
        title: Text("Mes Likes"),
      ),
      body: FutureBuilder<DocumentSnapshot>(
      future: usersRef.doc(userId).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Une erreur est survenue: ${snapshot.error}");
        }

        if (snapshot.hasData && snapshot.data!.exists) {
          List<dynamic> likedGames = snapshot.data!.get('likedGames');

          if (likedGames.isEmpty) {
            return Center(
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
            );
          }


          return ListView.builder(
            padding: EdgeInsets.only(top: 10.0), // Ajouter un Padding en haut
            itemCount: likedGames.length,
            itemBuilder: (BuildContext context, int index) {
              String gameId = likedGames[index];

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
                              fontSize: 10,
                              decoration: TextDecoration.underline,),
                          ),
                       // leading: Image.network(gameImage),
                        /*onTap: () {
                          Navigator.push(
                              context, MaterialPageRoute(builder: (_) => GameDetail(appId: gameId, userid: userId)));
                        },*/

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
