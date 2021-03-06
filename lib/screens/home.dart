import 'package:flutter/material.dart';
import 'package:free2play/models/game.dart';
import 'package:free2play/widgets/content_scroll.dart';
import 'package:free2play/utils.dart';
// import 'package:free2play/screens/login.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Game>>? _futureFavoriteGames;
  Future<List<Game>>? _futureShooterGames;
  Future<List<Game>>? _futureRacingGames;
  Future<List<Game>>? _futureZombieGames;
  Future<Map<String, dynamic>>? _connectionText;

  @override
  void initState() {
    // () async => {
    //   if (await API.getToken() == "") {
    //     Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => const LoginScreen(),
    //     ),)
    //   }
    // };
    _connectionText = getConnectionText();
    super.initState();
    updateFutureRows();
  }

  void updateFutureRows() {
    _futureShooterGames = Game.fetchData(
        "https://www.freetogame.com/api/filter?tag=shooter&platform=browser", "ShooterRow");
    _futureRacingGames = Game.fetchData(
        "https://www.freetogame.com/api/filter?tag=racing", "RacingRow");
    _futureZombieGames = Game.fetchData(
        "https://www.freetogame.com/api/filter?tag=zombie", "ZombieRow");
    _futureFavoriteGames = Game.fetchData(
        "https://free2play-api.herokuapp.com/api/games/favorites/", "favorites");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0.0,
        leading: IconButton(
            padding: const EdgeInsets.only(left: 30.0),
            onPressed: () => print('Vazio'),
            icon: const Icon(Icons.arrow_back),
            iconSize: 26.0,
            color: const Color(0xFF121212),
          ),
        title: const Center(
          child: Image(
            image: AssetImage('assets/images/main_logo.png'),
            height: 50.0,
            // width: 150.0,
          ),
        ),
        actions: <Widget>[
            IconButton(
              padding: const EdgeInsets.only(right: 30.0),
              onPressed: () => setState(() {
                updateFutureRows();
                _connectionText = getConnectionText();
              }),
              icon: const Icon(Icons.sync),
              iconSize: 26.0,
              color: ProjectColors.getWhiteRGBO(opacity: 0.8),
            ),
          ],
      ),
      body: ListView(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4.0),
                  child: FutureBuilder<Map<String, dynamic>>(
                        future: _connectionText,
                        builder: (context, snapshot) {
                  String connectionStatus = "Verificando";
                  Color spanColor = const Color(0xFF4834D4);
                  if (snapshot.hasData) {
                     connectionStatus = snapshot.data!["text"];
                     spanColor = snapshot.data!["color"];
                  } else if (snapshot.hasError) {
                    connectionStatus = "Offline";
                    spanColor = Colors.red.shade700;
                  } else {
                    connectionStatus = "Verificando";
                  }
                  return Container(
                    // margin: EdgeInsets.all(10),
                    color: spanColor,
                    child: Padding(
                      padding: const EdgeInsets.all(3.5),
                      child: Text(
                              connectionStatus,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0),
                            ),
                    ));
                  
                        }),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          GameScroll(
            futureGames: _futureFavoriteGames,
            title: 'Favorites',
            imageHeight: 150.0,
            imageWidth: 200.0,
          ),
          const SizedBox(height: 10.0),
          GameScroll(
            futureGames: _futureShooterGames,
            title: 'Shooter for Web',
            imageHeight: 150.0,
            imageWidth: 200.0,
          ),
          const SizedBox(height: 10.0),
          GameScroll(
            futureGames: _futureRacingGames,
            title: 'Racing',
            imageHeight: 150.0,
            imageWidth: 200.0,
          ),
          const SizedBox(height: 10.0),
          GameScroll(
            futureGames: _futureZombieGames,
            title: 'Zombies',
            imageHeight: 150.0,
            imageWidth: 200.0,
          ),
        ],
      ),
    );
  }
}






// FutureBuilder<int>(
//         future: _isConnected,
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             int connectionStatus = snapshot.data;
//             return Scaffold(
//               backgroundColor: Color(0XFF121212),
//               appBar: AppBar(
//                 backgroundColor: Color(0XFF121212),
//                 elevation: 0.0,
//                 leading: Padding(
//                   padding: const EdgeInsets.only(left: 4.0),
//                   child: Center(
//                     child: Text(
//                       connectionStatus == 1 ? "Online": connectionStatus == 2 ? "Web": "Offline",
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 14.0),
//                     ),
//                   ),
//                 ),
//                 title: Padding(
//                   padding: const EdgeInsets.only(left: 140.0),
//                   child: Image(
//                     image: AssetImage('assets/images/main_logo.png'),
//                     height: 50.0,
//                     // width: 150.0,
//                   ),
//                 ),
//               ),
//               body: ListView(
//                 children: <Widget>[
//                   SizedBox(height: 20.0),
//                   GameScroll(
//                     futureGames: _futureFavoriteGames,
//                     title: 'Meus favoritos',
//                     imageHeight: 150.0,
//                     imageWidth: 200.0,
//                   ),
//                   SizedBox(height: 10.0),
//                   GameScroll(
//                     futureGames: _futureShooterGames,
//                     title: 'FPS para Windows',
//                     imageHeight: 150.0,
//                     imageWidth: 200.0,
//                   ),
//                 ],
//               ),
//             );
//           } else if (snapshot.hasError) {}
//           return Container(child: Text("${snapshot.error}"),);
//         })