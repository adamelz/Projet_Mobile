import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../services/api_service.dart';


class SearchResult {
  final int appid;
  final String name;
  final String image;
  final String background;
  final String developer;
  final String description;
  final bool isFree;
  final String price;

  SearchResult({
    required this.appid,
    required this.name,
    required this.image,
    required this.background,
    required this.developer,
    required this.description,
    required this.isFree,
    required this.price,
  });
}



/*class SteamSearch extends StatefulWidget {
  final String? value;

  SteamSearch({required this.value});

  @override
  SteamSearchState createState() => SteamSearchState();
}

class SteamSearchState extends State<SteamSearch> {


  Future<List<dynamic>> search() async {
    final url = 'https://steamcommunity.com/actions/SearchApps/${widget.value}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      print ("je passe la ");
      final results = jsonDecode(response.body);
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
        backgroundColor:Color(0xFF1E262C) ,
        title: Text('Recherche pour: ${widget.value}'),
      ),

      body: Center(
        child: Text('A venir'),
      ),
    );
  }

  }*/

class SteamSearch extends StatefulWidget {
  final String? value;

  SteamSearch({required this.value});

  @override
  SteamSearchState createState() => SteamSearchState();
}

class SteamSearchState extends State<SteamSearch> {

  /*Future<List<dynamic>> search() async {
    final url = 'https://steamcommunity.com/actions/SearchApps/${widget.value}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final results = jsonDecode(response.body);
      final games = FirebaseFirestore.instance.collection('games');
      final existingAppIds = await games.get().then((snapshot) {
        return snapshot.docs.map((doc) => doc['appid']).toList();
      });
      final newAppIds = results.map((result) => result['appid']).toList();
      final appIdsToAdd = newAppIds.where((newAppId) => !existingAppIds.contains(newAppId)).toList();
      for (var appId in appIdsToAdd) {
        await games.doc(appId).set({
          'appid': appId,
          'rank': 0,
        });
      }
      return results;
    } else {
      throw Exception('Failed to search for apps');
    }
  }*/

  /*Future<List<dynamic>> search() async {
    final url = 'https://steamcommunity.com/actions/SearchApps/${widget.value}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final results = jsonDecode(response.body);
      final games = FirebaseFirestore.instance.collection('games');
      final existingAppIds = await games.get().then((snapshot) {
        return snapshot.docs.map((doc) => doc['appid']).toList();
      });
      final newAppIds = results.map((result) => result['appid']).toList();
      final appIdsToAdd = newAppIds.where((newAppId) => !existingAppIds.contains(newAppId)).toList();
      for (var appId in appIdsToAdd) {
        await games.doc(appId.toString()).set({
          'appid': appId,
          'rank': 0,
        });
      }

      return results;
    } else {
      throw Exception('Failed to search for apps');
    }
  }*/

  Future<List<dynamic>> search() async {
    final url = 'https://steamcommunity.com/actions/SearchApps/${widget.value}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final results = jsonDecode(response.body);
      final games = FirebaseFirestore.instance.collection('games');
      final existingAppIds = await games.get().then((snapshot) {
        return snapshot.docs.map((doc) => doc['appid']).toList();
      });
      final newAppIds = results.map((result) => result['appid']).toList();
      final appIdsToAdd = newAppIds.where((newAppId) => !existingAppIds.contains(newAppId)).toList();
      for (var appId in appIdsToAdd) {
        final appDetailsUrl = 'https://store.steampowered.com/api/appdetails?appids=$appId';
        final appDetailsResponse = await http.get(Uri.parse(appDetailsUrl));
        final appDetails = jsonDecode(appDetailsResponse.body);
        final appName = appDetails[appId.toString()]['data']['name'];
        final appImage = appDetails[appId.toString()]['data']['header_image'];
        final appBackground = appDetails[appId.toString()]['data']['background'];
        final appDeveloper = appDetails[appId.toString()]['data']['developers'][0];
        final appDescription = appDetails[appId.toString()]['data']['short_description'];
        final appFree = appDetails[appId.toString()]['data']['is_free'];
        final appPrice = appDetails[appId.toString()]['data']['price_overview'] != null ? appDetails[appId.toString()]['data']['price_overview']['final_formatted'] : 'N/A';

        await games.doc(appId.toString()).set({
          'appid': appId,
          'rank': 0,
          'name': appName,
          'image' : appImage,
          'background': appBackground,
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
              final appIds = snapshot.data!.map((result) => result['appid']).join(', ');
              return Text('AppIds from API: $appIds');
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

