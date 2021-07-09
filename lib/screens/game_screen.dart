import 'package:flutter/material.dart';
import 'package:free2play/models/game_detail_model.dart';
import 'package:free2play/models/game_model.dart';

import 'dart:convert';
// import 'dart:typed_data';
import 'package:flutter/widgets.dart';
// import 'package:free2playnew/widgets/circular_clipper.dart';
// import 'package:free2playnew/widgets/content_scroll.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({Key? key}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Future<GameDetail>? _futureGameDetail;

  // @override
  // void initState() {
  //   super.initState();
  //   new Future.delayed(Duration.zero,() {
  //     _futureGameDetail = fetchGameDetailData(context);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final game = ModalRoute.of(context)!.settings.arguments as Game;
    _futureGameDetail = fetchGameDetailData(game.id);

    return FutureBuilder<GameDetail>(
          future: _futureGameDetail,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              GameDetail? gameDetail = snapshot.data;
              return Scaffold(
                backgroundColor: const Color(0xFF121212),
                appBar: GameDetailAppBar(
                  gameDetail: gameDetail,
                  context: context,
                  favoriteGame: () => print("favoritar"),
                ),
                body: GameDetailBodyWidget(game: game, gameDetail: gameDetail
              ));
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18.0));
            }
            return Scaffold(
                backgroundColor: const Color(0xFF121212),
                appBar: GameDetailAppBar(context: context, favoriteGame: () => print("carregando"),),
                body: const Center(child: CircularProgressIndicator())
            );
          },
        );
  }
}

// ignore: must_be_immutable
class GameDetailBodyWidget extends StatelessWidget {
  Game game;
  GameDetail? gameDetail;

  GameDetailBodyWidget({
    Key? key,
    required this.gameDetail,
    required this.game,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Container(
                  margin: const EdgeInsets.only(top: 18, left: 2),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7.0),
                    child: Image.memory(
                        base64Decode(gameDetail!.thumbnailBase64),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 18, bottom: 2),
                    child: Text(
                      game.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 22.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18, bottom: 2),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: Container(
                                  color: const Color(0xFF4834D4),
                                  child: Padding(
                                    padding: EdgeInsets.all(3.5),
                                    child: Text(
                                      game.genre,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.0),
                                    ),
                                  )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: Container(
                                  width: 100,
                                  color: const Color(0xFF4834D4),
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.5),
                                    child: Center(
                                      child: Text(
                                        game.platform,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.0),
                                      ),
                                    ),
                                  )),
                            ),
                          ),
                        ]),
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 20.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Description",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20.0),
              ),
              Container(
                margin: const EdgeInsets.only(top: 6),
                height: 120.0,
                child: SingleChildScrollView(
                  child: Text(
                    gameDetail!.description,
                    style:
                        const TextStyle(color: Colors.white54, fontSize: 18.0),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}



// ignore: must_be_immutable
class GameDetailAppBar extends AppBar {

  BuildContext context;
  GameDetail? gameDetail;
  void Function()? favoriteGame;

  GameDetailAppBar({
    Key? key, 
    required this.context,
    required this.favoriteGame,
    this.gameDetail
  }):super(key: key, 
    // iconTheme: IconThemeData(
    //   color: Colors.black, //change your color here
    // ),
          backgroundColor: const Color(0xFF121212),
          elevation: 0.0,
          title: const Center(
            child: Image(
              image: AssetImage('assets/images/main_logo.png'),
              height: 50.0,
              // width: 150.0,
            ),
          ),
          leading: IconButton(
            padding: const EdgeInsets.only(left: 30.0),
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            iconSize: 30.0,
            color: Colors.white,
          ),
          actions: <Widget>[
            IconButton(
              padding: const EdgeInsets.only(right: 30.0),
              onPressed: favoriteGame,
              icon: gameDetail != null && gameDetail.favorite ? const Icon(Icons.favorite) : const Icon(Icons.favorite_border_outlined),
              iconSize: 30.0,
              color: Colors.white,
            ),
          ],
  );
}

