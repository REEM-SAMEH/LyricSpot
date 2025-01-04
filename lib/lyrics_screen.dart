import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const List<String> badWords = [
  "damn",
  "hell",
  "crap",
  "stupid",
  "idiot",
  "moron",
  "jerk",
  "bastard",
  "dumb",
  "ugly",
  "suck",
  "fool",
  "loser",
  "scum",
  "trash",
  "dirtbag",
  "shut up",
  "retard",
  "nonsense",
  "freak",
  "annoying",
  "sex",
  "dirty",
  "fuck",
  "غبي",
  "سخيف",
  "أحمق",
  "قذر",
  "حقير",
  "لعنة",
  "غجر",
  "خنزير",
  "تافه",
  "مقرف",
  "فاشل",
  "سافل",
  "مشبوه",
  "هامل",
  "خبيث",
  "قبيح",
  "عاهر",
  "متخلف",
  "وقح",
  "أخرس",
  "خرا",
  "صدرها",
];

class LyricsScreen extends StatefulWidget {
  final String trackName;
  final String artistName;

  const LyricsScreen({
    super.key,
    required this.artistName,
    required this.trackName,
  });

  @override
  State<LyricsScreen> createState() => _LyricsScreenState();
}

class _LyricsScreenState extends State<LyricsScreen> {
  String lyrics = 'Fetching lyrics...';
  final List<String> inappropriateWords = badWords;

  Future<void> getLyrics() async {
    String url =
        'https://lrclib.net/api/get?artist_name=${Uri.encodeComponent(widget.artistName)}&track_name=${Uri.encodeComponent(widget.trackName)}';

    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data.containsKey('plainLyrics') && data['plainLyrics'] != null) {
          setState(() {
            lyrics = utf8.decode(data['plainLyrics'].toString().runes.toList());

            for (String word in inappropriateWords) {
              final regex = RegExp(
                  r'(^|\W)' + RegExp.escape(word) + r'($|\W)', caseSensitive: false);
              lyrics = lyrics.replaceAllMapped(
                regex,
                    (match) => match.group(0)!.replaceAll(RegExp(r'\S'), '*'),
              );
            }
          });
        }
      } else {
        setState(() {
          lyrics = 'Failed to fetch lyrics: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        lyrics = 'An error occurred: $e';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getLyrics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lyrics Viewer'),
        centerTitle: true,
        backgroundColor: const Color(0xFF1DB954), // Spotify Green
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF1DB954), // Spotify Green
                Color(0xFF121212), // Dark Background
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    widget.artistName,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.trackName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Lyrics',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      lyrics,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
