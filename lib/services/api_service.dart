import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';


class Game {
  final int appid;
  final int rank;

  Game(this.appid, this.rank);
}


Future<void> fetchData2() async {
  final response = await http.get(Uri.parse(
      'https://api.steampowered.com/ISteamChartsService/GetMostPlayedGames/v1/'));

  final data = json.decode(response.body);
  final List<Game> loadedGames = [];

  data['response']['ranks'].forEach((gameData) {
    final game = Game(gameData['appid'], gameData['rank']);
    loadedGames.add(game);
    print(game);
  });

  // Enregistrer les données dans Firestore
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
    final response = await http.get(Uri.parse(
        'https://store.steampowered.com/api/appdetails?appids=${game.appid}'));
    final data = json.decode(response.body);

    final name = data['${game.appid}']['data']['name'];
    final image = data['${game.appid}']['data']['header_image'];
    final background = data['${game.appid}']['data']['background'];
    final developer = data['${game.appid}']['data']['developers'][0];
    final description = data['${game.appid}']['data']['short_description'];
    final free = data['${game.appid}']['data']['is_free'];
    final price = data['${game.appid}']['data']['price_overview'] != null ? data['${game.appid}']['data']['price_overview']['final_formatted'] : 'N/A';



    // Ajouter les nouveaux champs à chaque document de la collection "games"
    collectionReference.doc(game.appid.toString()).update({
      'name': name,
      'image': image,
      'background': background,
      'developer': developer,
      'description': description,
      'price': free == true ? 'Gratuit' : price,
    });
  });
}



