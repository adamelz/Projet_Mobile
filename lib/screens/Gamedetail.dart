import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GameDetail extends StatefulWidget {

  late final String? appId;
  final String userid;

  GameDetail({required this.appId, required this.userid});

  @override
  _GameDetailState createState() => _GameDetailState();
}

class _GameDetailState extends State<GameDetail> {
  bool isLike = false;
  bool isWish = false;

  void initState() { //Change l'état des valeurs si coché ou non
    super.initState();
    checkLikedGames().then((value) {
      setState(() {
        isLike = value;
      });
    });
    checkWishedGames().then((value) {
      setState(() {
        isWish = value;
      });
    });

  }


  Future<bool> checkLikedGames() async { //Regarde si le jeu est déjà liké alors ccoeur plein
    CollectionReference usersRef = FirebaseFirestore.instance.collection('users');
    String userId = widget.userid;

    DocumentSnapshot doc = await usersRef.doc(userId).get();

    if (doc.exists) {
      List<dynamic> likedGames = doc.get('likedGames');

      return likedGames.contains(widget.appId);
    }

    return false;
  }

  Future<bool> checkWishedGames() async { //Regarde si le jeu est déjà liké alors étoile pleine
    CollectionReference usersRef = FirebaseFirestore.instance.collection('users');
    String userId = widget.userid; // Remplacez par l'ID de l'utilisateur connecté

    DocumentSnapshot doc = await usersRef.doc(userId).get();

    if (doc.exists) {
      List<dynamic> wishedGames = doc.get('wishedGames');

      return wishedGames.contains(widget.appId);
    }

    return false;
  }


  void toggleLike() async { //Ajout du jeu dans les Likes
    setState(() {
      isLike = !isLike;
    });

    CollectionReference usersRef = FirebaseFirestore.instance.collection('users');
    String userId = widget.userid;

    if (isLike) {
      await usersRef.doc(userId).update({
        'likedGames': FieldValue.arrayUnion([widget.appId]),
      });
    } else {
      await usersRef.doc(userId).update({
        'likedGames': FieldValue.arrayRemove([widget.appId]),
      });
    }
  }


  void toggleWish() async { //Ajout du jeu dans les wish
    setState(() {
      isWish = !isWish;
    });

    CollectionReference usersRef = FirebaseFirestore.instance.collection('users');
    String userId = widget.userid;

    if (isWish) {
      await usersRef.doc(userId).update({
        'wishedGames': FieldValue.arrayUnion([widget.appId]),
      });
    } else {
      await usersRef.doc(userId).update({
        'wishedGames': FieldValue.arrayRemove([widget.appId]),
      });
    }
  }
  @override

    Widget build(BuildContext context) {
      CollectionReference gamesRef = FirebaseFirestore.instance.collection('games');

      DocumentReference gameDocRef = gamesRef.doc(widget.appId);
      String gameName = "Chargement en cours..." ;
      String gameImage = "Chargement en cours...";
      String gameBackgroung = "Chargement en cours...";
      String gameBackgroungRAW = "Chargement en cours...";
      String gameDescription = "Chargement en cours...";
      String gameDev = "Chargement en cours...";
      String gamePrice = "Chargement en cours...";


      return FutureBuilder<DocumentSnapshot>(
        future: gameDocRef.get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Text("Une erreur est survenue: ${snapshot.error}");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("Le document n'existe pas");
          }

          if (snapshot.hasData && snapshot.data!.exists) {
            Map<String, dynamic>? data = snapshot.data!.data() as Map<String, dynamic>?;
            if (data != null) { //On charge les informations avec la leccture de BDD
              gameName = data['name'] ?? "";
              gameImage = data['image'] ?? "";
              gameDescription = data['description'] ?? "";
              gameBackgroung = data['background'] ?? "";
              gameBackgroungRAW = data['background_raw'] ?? "";
              gameDev = data['developer'] ?? "";
              gamePrice = data['price'] ?? "";

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

                      Container(
                      height: 300,
                      child: Stack(
                          children: [
                        Image.network(
                            gameBackgroungRAW ,
                          fit: BoxFit.cover,
                          height: 250,
                        ),
                        Positioned(
                        bottom: -20,
                          left: 10,
                          child:
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(gameBackgroung),
                              fit: BoxFit.cover,
                              colorFilter: const ColorFilter.mode(
                                Colors.grey,
                                BlendMode.darken,
                              ),
                            ),
                          ),
                          margin: EdgeInsets.all(16),
                          height: 100,
                          width: 360,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                             Image.network(

                                gameImage ,
                                height: 100,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        gameName ,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'proxima',
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Text(gameDev ,
                                      style: TextStyle(fontFamily: 'proxima',
                                        color: Colors.white,),),
                                    Text('\n' + gamePrice ,style: TextStyle(fontFamily: 'proxima',
                                      color: Colors.white,decoration: TextDecoration.underline,),),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
                          gameDescription ,
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


