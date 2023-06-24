import 'dart:developer';
import 'dart:math' as rand show Random;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  var maps = Constants.maps;
  ColorScheme? color;
  late TextEditingController _textEditingController;

  static Stream<QuerySnapshot> getStream() {
    return FirebaseFirestore.instance.collection('dataset').orderBy('views').snapshots();
  }

  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    color = Theme.of(context).colorScheme;
    return buildDocument();
  }

  StreamBuilder<QuerySnapshot> buildDocument() {
    return StreamBuilder<QuerySnapshot>(
        stream: getStream(),
        builder: (context, snapshot) {
          var collection = snapshot.data;
          if (snapshot.hasError) {
            const ErrorPage();
          }
          if (snapshot.hasData) {
            if (collection != null) {
              return Scaffold(
                appBar: AppBar(elevation: 1, shadowColor: Colors.white70, title: const Text(Constants.appName), actions: [
                  TextButton(
                    onPressed: () async {
                      List<Map<String, dynamic>> list = [
                        {
                          'image_id': rand.Random().nextInt(100),
                          'rating': rand.Random().nextInt(10).toDouble(),
                          'views': rand.Random().nextInt(1000),
                        },
                        {
                          'image_id': rand.Random().nextInt(100),
                          'rating': rand.Random().nextInt(10).toDouble(),
                          'views': rand.Random().nextInt(1000),
                        },
                        {
                          'image_id': rand.Random().nextInt(100),
                          'rating': rand.Random().nextInt(10).toDouble(),
                          'views': rand.Random().nextInt(1000),
                        }
                      ];
                      final batch = FirebaseFirestore.instance.batch();
                      var all = FirebaseFirestore.instance.collection('dataset');
                      for (var d in list) {
                        try {
                          batch.set(all.doc(), d);
                        } catch (e) {
                          log(e.toString());
                        }
                      }
                      batch.commit();
                    },
                    child: const Text('Load all'),
                  ),
                  IconButton(
                    onPressed: () => displayDialog(context),
                    icon: const Icon(CupertinoIcons.doc_person),
                  )
                ]),
                body: ListView.builder(
                  itemCount: collection.docs.length /*maps.length*/,
                  itemBuilder: (BuildContext context, int index) {
                    return ImageContainer(
                      index: index + 1,
                      snapshot: collection.docs[index],
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

  displayDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add document"),
          content: SizedBox(
            height: 150,
            child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              TextField(
                controller: _textEditingController,
                onChanged: (String value) {
                  if (value.trim().isEmpty || value.trim().length < 3) {
                    launch(context, Constants.error);
                  }
                },
                inputFormatters: [TextInputFormatter.withFunction((oldValue, newValue) => newValue)],
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                color: Colors.deepPurple.shade200,
                onPressed: () {
                  try {
                    FirebaseFirestore.instance.collection('dataset').doc(_textEditingController.text.trim()).set({
                      'image_id': rand.Random().nextInt(100),
                      'rating': rand.Random().nextInt(10).toDouble(),
                      'views': rand.Random().nextInt(1000),
                    });
                  } finally {
                    Navigator.pop(context);
                  }
                },
                child: const Text('Create'),
              )
            ]),
          ),
        );
      },
    );
  }
}
