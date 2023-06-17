import 'dart:developer';
import 'package:flutt';
import 'package:flutter/material.dart';
import 'package:image_recommendation/data/constants/constants.dart';
import 'package:image_recommendation/main.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var list = ['Designer', 'Category', 'Attention'];

  ColorScheme? color;

  @override
  Widget build(BuildContext context) {
    color = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Image With Title, Description, Rating Bar, and Views Counter'),
      ),
      body: Center(
        child: Column(
          children: [
            Image.asset(
              'assets/image.png',
            ),
            const SizedBox(height: 10),
            const Text(
              'Title',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 5),
            const Text(
              'Short description',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            RatingBar(
              initialRating: 3,
              maxRating: 10,
              ratingWidget: RatingWidget(
                full: const Icon(Icons.star, color: Colors.yellow),
                half: const Icon(Icons.star_half, color: Colors.yellow),
                empty: const Icon(Icons.star_border, color: Colors.grey),
              ),
              onRatingChanged: (rating) {},
            ),
            const SizedBox(height: 10),
            const Text(
              'Views: 1000',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  buildLaunch() => launch(context, Constants.dashboard);

  onClickCard(String title) => log(title);
}
