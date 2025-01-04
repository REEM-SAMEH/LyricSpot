import 'package:flutter/material.dart';

class ArabicLyricsScreen extends StatefulWidget {
  final String songId;
  final String artistName;

  ArabicLyricsScreen({required this.songId, required this.artistName});

  @override
  _ArabicLyricsScreenState createState() => _ArabicLyricsScreenState();
}

class _ArabicLyricsScreenState extends State<ArabicLyricsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Arabic Lyrics - ${widget.artistName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Song ID: ${widget.songId}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Artist: ${widget.artistName}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            // Your lyrics content or API call to fetch lyrics will go here
            Expanded(
              child: Center(
                child: Text(
                  'Lyrics will be displayed here...',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
