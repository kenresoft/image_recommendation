import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_recommendation/data/constants/constants.dart';
import 'package:image_recommendation/main.dart';
import 'package:image_recommendation/routes/error.dart';

import '../widgets/image_container.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<FirebaseApp> _initialization;
  var maps = Constants.maps;
  ColorScheme? color;

  static Stream<QuerySnapshot> getStream() {
    return FirebaseFirestore.instance.collection('dataset').orderBy('views').snapshots();
  }

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
            return const ErrorPage();
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return buildDocument();
          }
          return const CircularProgressIndicator();
        });
  }

  StreamBuilder<QuerySnapshot<Object?>> buildDocument() {
    return StreamBuilder<QuerySnapshot>(
        stream: getStream(),
        builder: (context, snapshot) {
          var data = snapshot.data;
          if (snapshot.hasError) {
            const ErrorPage();
          }
          if (snapshot.hasData) {
            if (data != null) {
              return Scaffold(
                appBar: AppBar(
                  elevation: 1,
                  shadowColor: Colors.white70,
                  title: const Text(Constants.appName),
                ),
                body: ListView.builder(
                  itemCount: maps.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ImageContainer(
                      index: index + 1,
                      snapshot: data.docs[index],
                    );
                  },
                ),
              );
            }
          }
          return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 155,
                vertical: 360,
              ),
              child: const CircularProgressIndicator());
        });
  }

  buildLaunch() => launch(context, Constants.dashboard);

  onClickCard(String title) => log(title);
}
