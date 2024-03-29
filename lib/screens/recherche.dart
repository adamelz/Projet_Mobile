import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Gamedetail.dart';


class SteamSearch extends StatefulWidget {
  final String? value;
  late final String userId;

  SteamSearch({required this.value, required this.userId});

  @override
  SteamSearchState createState() => SteamSearchState();
}

class SteamSearchState extends State<SteamSearch> {


  //On lit l'API et récupère les ID des jeux pour ensuite les ccharger en informations
  Future<List<dynamic>> search() async {
    final url = 'https://steamcommunity.com/actions/SearchApps/${widget.value}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final results = jsonDecode(response.body);
      final games = FirebaseFirestore.instance.collection('games');
      final existingAppIds = await games.get().then((snapshot) { //Si ils ne sont pas deja dans la BDD
        return snapshot.docs.map((doc) => doc['appid']).toList();
      });
      final newAppIds = results.map((result) => result['appid']).toList();
      final appIdsToAdd = newAppIds.where((newAppId) => !existingAppIds.contains(newAppId)).toList();
      for (var appId in appIdsToAdd) {
        final appDetailsUrl = 'https://store.steampowered.com/api/appdetails?appids=$appId&l=english';
        final appDetailsResponse = await http.get(Uri.parse(appDetailsUrl));
        final appDetails = jsonDecode(appDetailsResponse.body);
        final appName = appDetails[appId.toString()]['data']['name'];
        final appImage = appDetails[appId.toString()]['data']['header_image'];
        final appBackground = appDetails[appId.toString()]['data']['background'];
        final appBackgroundRAW = appDetails[appId.toString()]['data']['background_raw'];
        final appDeveloper = appDetails[appId.toString()]['data']['developers'][0];
        final appDescription = appDetails[appId.toString()]['data']['detailed_description'];
        final appFree = appDetails[appId.toString()]['data']['is_free'];
        final appPrice = appDetails[appId.toString()]['data']['price_overview'] != null ? appDetails[appId.toString()]['data']['price_overview']['final_formatted'] : 'N/A';

        await games.doc(appId.toString()).set({
          'appid': appId,
          'rank': 0, //On met 0 pour pas ne les voir dans la liste des meilleures ventes
          'name': appName,
          'image' : appImage,
          'background': appBackground,
          'background_raw': appBackgroundRAW,
          'developer': appDeveloper,
          'description': appDescription,
          'price': appFree == true ? 'Gratuit' : appPrice,

        });
      }

      return results;
    } else {
      throw Exception('Failed to search for apps');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E262C),
      appBar: AppBar(
        backgroundColor: Color(0xFF1E262C),
        title: Text('Recherche pour: ${widget.value}'),
      ),
      body: Center(
        child: FutureBuilder<List<dynamic>>(
          future: search(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {

                if (snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/icons/warning.svg',width: 100,height: 100,
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          "Aucuns jeu n'est disponible à ce nom.\n Veuillez renter une nouvelle recherche",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16.0, color: Colors.white,fontFamily:'Proxima'),
                        ),
                      ],
                    ),
                  );
                }


              // Récupérer les données de chaque jeu souhaité à partir de  Firestore
              return ListView.builder(
                padding: EdgeInsets.only(top: 10.0),
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  String gameId = snapshot.data![index]['appid'].toString();
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
                          String gameDev = data['developer'] ?? "";
                          String gameBack = data['background'] ?? "";
                          String gamePrice = data['price'] ?? "";

                          return Container (
                            margin: EdgeInsets.only(bottom: 10.0,left: 10.0,  right: 10.0),

                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(gameBack),
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
                                                appId: id, userid: widget.userId),
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
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}


