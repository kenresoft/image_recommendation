import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../data/constants/constants.dart';
import '../main.dart';

class ImageContainer extends StatelessWidget {
  const ImageContainer({
    super.key,
    required this.index,
    required this.snapshot,
  });

  final int index;
  final QueryDocumentSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
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
                Image(image: ExactAssetImage(Constants.maps[index]!), height: 90),
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
                Text(
                  'Views: ${snapshot.get('views') as String}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
