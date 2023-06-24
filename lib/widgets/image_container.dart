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
                Image(image: ExactAssetImage(asset), height: 90),
                const SizedBox(height: 5),
                Text(snapshot.id.wrap(25), style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 5),
                const Text('Short description', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 5),
                RatingBar(
                  initialRating: (snapshot.get('rating')).toDouble(),
                  maxRating: 10,
                  allowHalfRating: true,
                  updateOnDrag: true,
                  ratingWidget: RatingWidget(
                    full: const Icon(Icons.star, color: Colors.greenAccent),
                    half: const Icon(Icons.star_half, color: Colors.yellowAccent),
                    empty: const Icon(Icons.star_border, color: Colors.grey),
                  ),
                  onRatingUpdate: (double value) {
                    _updateRating(value);
                  },
                ),
                const SizedBox(height: 10),
                Text(
                  'Views: ${snapshot.get('views')}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String get asset {
    try {
      return Constants.maps[index]!;
    } catch (e) {
      //return Constants.maps[Constants.maps.keys.last]!;
      return Constants.maps.let((it) => it[it.keys.last]);
    }
  }

  void _updateRating(double value) {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      final secureSnapshot = await transaction.get(snapshot.reference);

      final double rating = secureSnapshot.get('rating') as double;

      transaction.update(secureSnapshot.reference, {'rating': value}); // debug here....
      log('DOCUMENT: ${secureSnapshot.reference.id} | VALUE: $value');
    });
  }
}

extension<R> on R {
  T let<T>(T? Function(R it) f) {
    dynamic any;
    return f(this) ?? any;
  }
}

extension on String {
  String wrap(int end, [int start = 0]) {
    try {
      return substring(start, end);
    } catch (e) {
      return this;
    }
  }
}

extension on String {
  String wrap2({int? characterLimit}) {
    var cache = '';
    try {
      if (characterLimit != null) {
        for (var i = 0; i < characterLimit; ++i) {
          cache += this[i];
        }
      }
    } catch (e) {
      return this;
    }
    return cache;
  }
}
