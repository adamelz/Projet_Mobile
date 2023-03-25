import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GameDetail extends StatefulWidget {

  late final String? appId;

  GameDetail({required this.appId});

  @override
  _GameDetailState createState() => _GameDetailState();
}

class _GameDetailState extends State<GameDetail> {
  bool isLike = false;
  bool isWish = false;

  void toggleLike() {
    setState(() {
      isLike = !isLike;
    });
  }

  void toggleWish() {
    setState(() {
      isWish = !isWish;
    });
  }
  @override
  /*Widget build(BuildContext context) {
    CollectionReference gamesRef = FirebaseFirestore.instance.collection('games');

    DocumentReference gameDocRef = gamesRef.doc('730');
    String gameName = "C'est vide" ;
    String gameImage = "Chargement en cours...";

    gameDocRef.get().then((doc) {
      if (doc != null && doc.exists) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          setState(() {
            gameName = data['name'] ?? "";
            gameImage = data['image'] ?? "";
          });
        }
      }

    }
    );
    print(gameName);*/

    Widget build(BuildContext context) {
      CollectionReference gamesRef = FirebaseFirestore.instance.collection('games');

      //DocumentReference gameDocRef = gamesRef.doc('730');
      DocumentReference gameDocRef = gamesRef.doc(widget.appId);
      String gameName = "Chargement en cours..." ;
      String gameImage = "Chargement en cours...";
      String gameDescription = "Chargement en cours...";
      String gameDev = "Chargement en cours...";

      return FutureBuilder<DocumentSnapshot>(
        future: gameDocRef.get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Une erreur est survenue: ${snapshot.error}");
          }

         /* if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Chargement en cours...");
          }*/

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("Le document n'existe pas");
          }

          if (snapshot.hasData && snapshot.data!.exists) {
            Map<String, dynamic>? data = snapshot.data!.data() as Map<String, dynamic>?;
            if (data != null) {
              gameName = data['name'] ?? "";
              gameImage = data['image'] ?? "";
              gameDescription = data['description'] ?? "";
              gameDev = data['developer'] ?? "";
            }
          }


    return Scaffold(
        backgroundColor: Color(0xFF1E262C),
        appBar: AppBar(
          backgroundColor: Color(0xFF1E262C),
          title: Text("Détail du jeu"),
          actions: [
            IconButton(
              icon: isLike ? SvgPicture.asset('assets/icons/like_full.svg'):SvgPicture.asset('assets/icons/like.svg') ,
              onPressed: toggleLike ,
            ),
            IconButton(
              icon: isWish ? SvgPicture.asset('assets/icons/whishlist_full.svg'):SvgPicture.asset('assets/icons/whishlist.svg') ,
              onPressed: toggleWish,
            ),
          ],
        ),
        body: DefaultTabController(
            length: 2,
            child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Image.network(
                          "https://mobimg.b-cdn.net/v3/fetch/c5/c5e459323542642105ab322fa6d6060c.jpeg",
                          fit: BoxFit.cover,
                          height: 200,
                        ),
                        Container(

                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/img_1.png"),
                              fit: BoxFit.cover,
                              colorFilter: const ColorFilter.mode(
                                Colors.grey,
                                BlendMode.darken,
                              ),
                            ),
                          ),
                          margin: EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(
                                gameImage ?? "https://m.media-amazon.com/images/W/IMAGERENDERING_521856-T1/images/I/81zk93c4ZoL._AC_SL1500_.jpg",
                                height: 100,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(

                                      gameName ?? "Jeu XYZ",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'proxima',
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(gameDev ?? "dev",
                                      style: TextStyle(fontFamily: 'proxima',
                                      color: Colors.white,),),
                                    Text("Price",style: TextStyle(fontFamily: 'proxima',
                                      color: Colors.white,),),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        TabBar(
                          tabs: [
                            Tab(
                              text: "Description",
                            ),
                            Tab(
                              text: "Avis",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
                body: TabBarView(
                    children: [
                      SingleChildScrollView(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          gameDescription ?? "Description",
                          style: TextStyle(color: Colors.white,fontFamily:'Proxima'),
                        ),
                      ),
                      SingleChildScrollView(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          "Sed suscipit bibendum turpis, non eleifend enim malesuada vel. Vivamus nec mauris nec sem sollicitudin pharetra a a eros. Nam bibendum, lectus vel bibendum faucibus, ex purus commodo massa, ac maximus quam mi eu",
                          style: TextStyle(color: Colors.white,fontFamily:'Proxima'),),
                      ),
                    ]
                )
            )
        )
    );
        },
    );
  }
}


