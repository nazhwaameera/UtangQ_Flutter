import 'package:flutter/material.dart';

class WelcomeCard extends StatelessWidget {
  final String message;

  const WelcomeCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      // Define the shape of the card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      // Define how the card's content should be clipped
      clipBehavior: Clip.antiAliasWithSaveLayer,
      // Define the child widget of the card
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Add padding around the row widget
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Add an image widget to display an image
                Image.asset(
                  "asset/images/dashboard.jpg", // Replace this with your image path
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
                // Add some spacing between the image and the text
                Container(width: 20),
                // Add an expanded widget to take up the remaining horizontal space
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Add some spacing between the top of the card and the title
                      Container(height: 5),
                      // Add a title widget
                      Text(
                        message,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      // Add some spacing between the title and the subtitle
                      Container(height: 15),
                      // Add a subtitle widget
                      Text(
                        "Start splitting your bills and pay yours.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[500],
                        ),
                      ),
                      // Add some spacing between the subtitle and the text
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
