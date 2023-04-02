import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';


class Game {
  final int appid;
  final int rank;

  Game(this.appid, this.rank);
}

//Fonction pour charger des jeux dans une BDD avec la lecture de l'API pour leurs détails
Future<void> fetchData2() async {
  final response = await http.get(Uri.parse(
      'https://api.steampowered.com/ISteamChartsService/GetMostPlayedGames/v1/'));//Lecture de l'API comme base de travail

  final data = json.decode(response.body);
  final List<Game> loadedGames = [];

  data['response']['ranks'].forEach((gameData) {
    final game = Game(gameData['appid'], gameData['rank']);
    loadedGames.add(game);
  });

  // Enregistrer les données dans Firestore avec ID en nom de document
  final collectionReference = FirebaseFirestore.instance.collection('games');

  for (var i = 0; i < loadedGames.length; i++) {
    final game = loadedGames[i];

    final docRef = collectionReference.doc('${game.appid}');

    await docRef.set({
      'appid': game.appid,
      'rank': game.rank,
    });
  }

  loadedGames.forEach((game) async {
    //On charge les informations en lisant l'API
    final response = await http.get(Uri.parse(
        'https://store.steampowered.com/api/appdetails?appids=${game.appid}&l=english'));
    final data = json.decode(response.body);

    final name = data['${game.appid}']['data']['name'];
    final image = data['${game.appid}']['data']['header_image'];
    final background = data['${game.appid}']['data']['background'];
    final backgroundRAW = data['${game.appid}']['data']['background_raw'];
    final developer = data['${game.appid}']['data']['developers'][0];
    final description = data['${game.appid}']['data']['detailed_description'];
    final free = data['${game.appid}']['data']['is_free'];
    final price = data['${game.appid}']['data']['price_overview'] != null ? data['${game.appid}']['data']['price_overview']['final_formatted'] : 'N/A';



    // Ajouter les nouveaux champs à chaques document de la collection "games"
    collectionReference.doc(game.appid.toString()).update({
      'name': name,
      'image': image,
      'background': background,
      'background_raw': backgroundRAW,
      'developer': developer,
      'description': description,
      'price': free == true ? 'Gratuit' : price,
    });
  });
}



