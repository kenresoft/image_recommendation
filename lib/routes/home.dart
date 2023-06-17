import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_recommendation/data/constants/constants.dart';
import 'package:image_recommendation/main.dart';
import 'package:image_recommendation/routes/error.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<FirebaseApp> _initialization;
  var maps = Constants.maps;
  ColorScheme? color;

  @override
  void initState() {
    super.initState();
    _initialization = Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    color = Theme.of(context).colorScheme;
    return FutureBuilder<FirebaseApp>(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            const ErrorPage();
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(
                elevation: 1,
                shadowColor: Colors.white70,
                title: const Text(Constants.appName),
              ),
              body: ListView.builder(
                itemCount: maps.length,
                itemBuilder: (BuildContext context, int index) {
                  return imageContainer(index + 1);
                },
              ),
            );
          }
          return const CircularProgressIndicator();
        });
  }

  Widget imageContainer(int index) {
    return GestureDetector(
      onTap: () {
        launch(context, Constants.error);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(5),
            color: Colors.deepPurple.shade200,
            height: 230,
            width: 300,
            child: Column(
              children: [
                Image(image: ExactAssetImage(maps[index]!), height: 90),
                const SizedBox(height: 5),
                const Text(
                  'Title',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Short description',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 5),
                RatingBar(
                  initialRating: 0,
                  maxRating: 10,
                  allowHalfRating: true,
                  updateOnDrag: true,
                  ratingWidget: RatingWidget(
                    full: const Icon(Icons.star, color: Colors.greenAccent),
                    half: const Icon(Icons.star_half, color: Colors.yellowAccent),
                    empty: const Icon(Icons.star_border, color: Colors.grey),
                  ),
                  onRatingUpdate: (double value) {
                    log(value.toString());
                  },
                ),
                const SizedBox(height: 10),
                const Text(
                  'Views: 1000',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildLaunch() => launch(context, Constants.dashboard);

  onClickCard(String title) => log(title);
}
