import 'package:flutter/material.dart';
import 'package:free2play/models/game_detail.dart';
import 'package:free2play/models/game.dart';
import 'package:free2play/models/nested_models.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:free2play/models/nested_models.dart';
import 'package:free2play/utils.dart';
import 'package:free2play/db_test.dart';
import 'package:free2play/widgets/content_scroll.dart';
// import 'dart:convert';
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
    _futureGameDetail = GameDetail.fetchData(game.id);

    return FutureBuilder<GameDetail>(
      future: _futureGameDetail,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          GameDetail? gameDetail = snapshot.data;
          return Scaffold(
              backgroundColor: ProjectColors.background,
              appBar: GameDetailAppBar(
                gameId: game.id,
                gameDetail: gameDetail,
                favoriteGame: favoriteGame,
              ),
              body: GameDetailBodyWidget(game: game, gameDetail: gameDetail,));
        } else if (snapshot.hasError) {
          return Scaffold(
              backgroundColor: ProjectColors.background,
              // appBar: GameDetailAppBar(gameId: game.id, favoriteGame: favoriteGame,),
              body: Column(
                children: [
                  const SizedBox(height: 180),
                  Container(
                    margin: const EdgeInsets.all(30.0),
                    child: const Icon(
                      Icons.signal_wifi_off,
                      size: 100.0,
                      color: ProjectColors.gray,
                    ),
                  ),
                  Container(
                     padding: const EdgeInsets.all(30.0),
                      child: Text("${snapshot.error}",
                        textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 18.0))),
                ],
              ));
        }
        return const Scaffold(
            backgroundColor: Color(0xFF121212),
            // appBar: GameDetailAppBar(gameId: game.id, favoriteGame: favoriteGame,),
            body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}

// ignore: must_be_immutable
class GameDetailBodyWidget extends StatelessWidget {
  Game game;
  GameDetail? gameDetail;
  final String title = "Screenshots";
  final double imageHeight = 150.0;
  final double imageWidth = 200.0;

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
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 30.0,
            vertical: 10.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7.0),
                    child: CachedNetworkImage(
                                imageUrl: gameDetail!.thumbnailUrl,
                                fit: BoxFit.cover,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                  Icons.signal_wifi_off,
                                  size: 30.0,
                                  color: ProjectColors.gray,
                                ),
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
                    Text(
                      game.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 22.0),
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
                                      padding: const EdgeInsets.all(3.5),
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
        ),
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 30.0,
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
                        TextStyle(color: ProjectColors.getWhiteRGBO(opacity: 0.7), fontSize: 18.0),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 20.0,
          ),
          child: ScreenshotScroll(
            screenshots: gameDetail!.screenshots,
            title: title,
            imageHeight: imageHeight,
            imageWidth: imageWidth),
        )
      ],
    );
  }
}

// ignore: must_be_immutable
class GameDetailAppBar extends StatefulWidget implements PreferredSizeWidget {
  GameDetail? gameDetail;
  int gameId;
  Future<bool> Function(int, bool) favoriteGame;

  GameDetailAppBar({
    Key? key,
    required this.favoriteGame,
    this.gameDetail,
    required this.gameId,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  _GameDetailAppBarState createState() => _GameDetailAppBarState();
}

class _GameDetailAppBarState extends State<GameDetailAppBar> {
  bool _favorite = false;

  @override
  void initState() {
    if (widget.gameDetail != null && widget.gameDetail!.favorite) {
      _favorite = true;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ProjectColors.background,
      elevation: 0.0,
      title: const Center(
        child: Image(
          image: AssetImage('assets/images/main_logo.png'),
          height: 50.0,
        ),
      ),
      leading: IconButton(
        padding: const EdgeInsets.only(left: 30.0),
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_outlined),
        iconSize: 26.0,
        color: ProjectColors.gray,
      ),
      actions: <Widget>[
        IconButton(
          padding: const EdgeInsets.only(right: 30.0),
          onPressed: updateFavoriteState,
          icon: _favorite
              ? const Icon(Icons.favorite)
              : const Icon(Icons.favorite_border),
          iconSize: 26.0,
          color: _favorite ? ProjectColors.primary : ProjectColors.gray,
        ),
      ],
    );
  }

  void updateFavoriteState() async {
    final bool response = await widget.favoriteGame(widget.gameId, _favorite);
    if (response) {
      setState(() {
        _favorite = true;
      });
      return;
    }
    setState(() {
      _favorite = false;
    });
    return;
  }
}

Future<bool> favoriteGame(int gameId, bool currentButtonStatus) async {
  String url =
      "https://free2play-api.herokuapp.com/api/games/$gameId/favorite/";
  Map<String, String> headers = {
    "Authorization": "Token 5848cbc484d7138d4f726e34c685f160e3fc868a"
  };
  final bool connectionStatus = await Utils.getConnectionStatus();
  final db = await getDatabase();
  // const tableName = "favorites";
  http.Response response;
  if (connectionStatus) {
    if (currentButtonStatus == true) {
      response = await http.delete(Uri.parse(url), headers: headers);
    } else {
      response = await http.put(Uri.parse(url), headers: headers);
    }
    if (response.statusCode == 204) {
      return !currentButtonStatus;
    }
    throw Exception("Erro ao executar. Tente novamente mais tarde.");
  }

  if (currentButtonStatus == true) {
    await updateOrCreate(
        "syncQueue", SyncQueue(id: 1, url: url, method: "DELETE"), db);
    await deleteRow("favorites", gameId, db);
  } else {
    await updateOrCreate(
        "syncQueue", SyncQueue(id: 1, url: url, method: "PUT"), db);
    await updateOrCreate("favorites", RowQuery(id: gameId), db);
  }
  return !currentButtonStatus;

  // return !currentButtonStatus;
}
