import 'package:flutter/material.dart';
import 'package:spotify_lyrics/search_for_artist.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Serach For Artist',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF1db954)),
        useMaterial3: true,
      ),
      home: const SearchForArtist(),
    );
  }
}
