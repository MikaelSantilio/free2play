import 'package:flutter/material.dart';
import 'package:free2play/models/game.dart';
import 'package:free2play/models/nested_models.dart';
import 'package:free2play/utils.dart';
import 'package:free2play/screens/detail.dart';
// import 'dart:convert';
// import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';

// ignore: must_be_immutable
class GameScroll extends StatelessWidget {
  Future<List<Game>>? futureGames;
  final String title;
  final double imageHeight;
  final double imageWidth;

  GameScroll({
    Key? key,
    required this.futureGames,
    required this.title,
    required this.imageHeight,
    required this.imageWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                title,
                style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            ],
          ),
        ),
        Container(
          height: imageHeight,
          child: FutureBuilder<List<Game>>(
            future: futureGames,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Game>? data = snapshot.data;
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  physics: const AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DetailScreen(),
                            settings: RouteSettings(
                              arguments: data[index],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 20.0,
                        ),
                        width: imageWidth,
                        child: Stack(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: CachedNetworkImage(
                                imageUrl: data[index].thumbnailUrl,
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
                            Container(
                              padding: const EdgeInsets.all(5.0),
                              alignment: Alignment.bottomRight,
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: Container(
                                      // margin: EdgeInsets.all(10),
                                      color: const Color(0xFF4834D4),
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.5),
                                        child: Text(
                                          data[index].genre,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.0),
                                        ),
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}",
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0));
              }
              // By default show a loading spinner.
              return Container(
                  child: Center(child: const CircularProgressIndicator()));
            },
          ),
        ),
      ],
    );
  }
}

class ScreenshotScroll extends StatelessWidget {
  List<Screenshot> screenshots;
  final String title;
  final double imageHeight;
  final double imageWidth;

  ScreenshotScroll({
    Key? key,
    required this.screenshots,
    required this.title,
    required this.imageHeight,
    required this.imageWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                title,
                style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            ],
          ),
        ),
        Container(
          height: imageHeight,
          child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  physics: const AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: screenshots.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DetailScreen(),
                            settings: RouteSettings(
                              arguments: screenshots[index],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 20.0,
                        ),
                        width: imageWidth,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: CachedNetworkImage(
                            imageUrl: screenshots[index].image,
                            fit: BoxFit.cover,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    Center(
                                      child: CircularProgressIndicator(
                                          value: downloadProgress.progress),
                                    ),
                            errorWidget: (context, url, error) =>
                                const Icon(
                              Icons.signal_wifi_off,
                              size: 30.0,
                              color: ProjectColors.gray,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

