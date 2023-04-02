import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:projetmobile/screens/Gamedetail.dart';
import 'package:projetmobile/screens/Mes likes.dart';
import 'package:projetmobile/screens/Wishlist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../main.dart';
import 'package:projetmobile/screens/recherche.dart';


class HomePage extends StatefulWidget {
  final String userid;
  HomePage({required this.userid});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {


    return WillPopScope( //Gérer la décconnexion du user
      onWillPop: () async {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginDemo()));
        return true;
      },


      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color(0xFF1E262C),
        appBar: AppBar(
          backgroundColor: Color(0xFF1E262C),
          title: Text("Accueil"),
          actions: [
            IconButton(
              icon: SvgPicture.asset('assets/icons/like.svg'),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(
                    builder: (_) => UserLikedGames(userId: widget.userid,)));
              },

            ),
            IconButton(
              icon: SvgPicture.asset('assets/icons/whishlist.svg'),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(
                    builder: (_) => MyWishlist(userId: widget.userid)));
              },
            ),
          ],
        ),

    body: Column(
          children: [
            SingleChildScrollView(
              child: Form(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Rechercher un jeu...",
                      hintStyle: TextStyle(
                          color: Colors.white, fontFamily: 'Proxima'),
                      suffixIcon: Icon(Icons.search, color: Colors.deepPurple,),
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (valeur) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SteamSearch(value: valeur, userId: widget.userid), //Naviguer en reccherche de jeu
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Container(
              height: 270.0,
              width: 420.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://cdn.cloudflare.steamstatic.com/steamcommunity/public/images/clans/3381077/88695ecb1922d1881ba9ba14d193a0939a7946e6.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CS: GO',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "CS:GO fête son 10ème \n anniversaire !",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (_) =>
                            GameDetail(appId: '730', userid: widget.userid))); //Redirige vers la page de CS:GO
                      },
                      child: Text(
                        'En savoir plus',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Color(0xFF636af6),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          'https://cdn.cdkeys.com/700x700/media/catalog/product/c/s/cs-go.jpg',
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Meilleures ventes",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Proxima'),
                ),
              ),
            ),

            Expanded( //Affichage des jeux "meilleures ventes"
              child: FutureBuilder(
                future: _fetchData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    var games = snapshot.data as List<Map<String, dynamic>>;

                    return ListView.builder(
                      itemCount: games.length,
                      itemBuilder: (context, index) {
                        final game = games[index];

                        return Container( //Définir le component de chaque jeu de la liste
                          margin: EdgeInsets.only(bottom: 10.0,left: 10.0,  right: 10.0),
                            decoration: BoxDecoration(
                            image: DecorationImage(
                            image: NetworkImage(game['background']),
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
                                game['image'], fit: BoxFit.cover),
                          ),
                          title: Text(
                            game['name'] + '\n' + game['developer' ] + '\n',
                            style: TextStyle(color: Colors.white,
                              fontSize: 13,),
                          ),
                          subtitle: Text(
                            game['price'],
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
                                String? id = game['appid'].toString();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        GameDetail(
                                            appId: id, userid: widget.userid),
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
                      },
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            )
          ],
        ),


      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchData() async {

    var firestoreGames = await FirebaseFirestore.instance.collection('games').get();
    List<Map<String, dynamic>> games = firestoreGames.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    games = games.where((game) => game['rank'] > 0).toList();
    games.sort((a, b) => a['rank'].compareTo(b['rank']));

    return games;
  }
}