import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GameDetail extends StatefulWidget {
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
  Widget build(BuildContext context) {
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
    "https://m.media-amazon.com/images/W/IMAGERENDERING_521856-T1/images/I/81zk93c4ZoL._AC_SL1500_.jpg",
    height: 100,
    ),
    SizedBox(width: 10),
    Expanded(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    "Jeu XYZ",
    style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
      fontFamily: 'proxima',
      color: Colors.white,
    ),
    ),
    Text("Editeur ABC",style: TextStyle(fontFamily: 'proxima',
      color: Colors.white,),),
    Text("No 123",style: TextStyle(fontFamily: 'proxima',
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
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla eu risus gravida, vestibulum nulla vel, blandit nibh. Donec id nisi ut est bibendum malesuada. Nullam lobortis augue quis justo tincidunt, ac imperdiet arcu tristique. Integer eget mauris a sapien posuere sollicitudin. Proin ultrices ex eu felis tempor, vel malesuada nibh pellentesque. Sed eget nulla vitae eros hendrerit pellentesque. Ut varius blandit mauris at bibendum. Cras tristique tortor ac malesuada imperdiet. In facilisis, sapien vel molestie lacinia, libero ex faucibus elit, eu fringilla metus felis eu odio. Vestibulum faucibus, leo ut porttitor bibendum, enim ipsum auctor ante, eu bibendum nunc tellus eget nisi. Fusce et sapien eu augue dictum volutpat non non turpis. Vivamus at elementum nibh, a aliquam nibh. Fusce eget bibendum erat. Donec pretium, arcu a dignissim laoreet, sapien purus dapibus nisi, et finibus justo est in odio.",
      style: TextStyle(color: Colors.white,),
    ),
    ),
    SingleChildScrollView(
    padding: EdgeInsets.all(16),
    child: Text(
    "Sed suscipit bibendum turpis, non eleifend enim malesuada vel. Vivamus nec mauris nec sem sollicitudin pharetra a a eros. Nam bibendum, lectus vel bibendum faucibus, ex purus commodo massa, ac maximus quam mi eu",
      style: TextStyle(color: Colors.white,),),
    ),
    ]
    )
    )
    )
    );
  }
}