import 'package:flutter/material.dart';

class ArtistInfo extends StatelessWidget {
  const ArtistInfo({
    super.key,
    required String? artistInfo,
  }) : _artistInfo = artistInfo;

  final String? _artistInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Makes the container take full width
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF1DB954), // Spotify Green
            Color(0xFF121212), // Dark Gray
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center( // Centers the 'Artist Information' text
            child: Text(
              'Artist Information',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            color: Colors.transparent, // Makes card background transparent
            elevation: 0, // No shadow for the card
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SingleChildScrollView(
                child: Text(
                  _artistInfo ?? 'No information available',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white, // Light Gray Text Color
                    height: 1.8,
                    letterSpacing: 0.8,
                  ),
                  textAlign: TextAlign.left, // Align text from left
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
