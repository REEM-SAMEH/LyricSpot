import 'package:flutter/material.dart';
import 'package:spotify_lyrics/lyrics_screen.dart';

class TopTracksListView extends StatelessWidget {
  const TopTracksListView({
    super.key,
    required List<String> topTracks,
    required String? artistInfo,
  })  : _topTracks = topTracks,
        _artistInfo = artistInfo;

  final List<String> _topTracks;
  final String? _artistInfo;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _topTracks.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 4,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 16.0,
            ),
            leading: CircleAvatar(
              radius: 24,
              backgroundColor: const Color(0xFF1DB954), // Spotify Green for circle
              child: Text(
                (index + 1).toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            title: Text(
              _topTracks[index],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            subtitle: const Text(
              'Tap to view lyrics',
              style: TextStyle(color: Colors.grey),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF1DB954), // Spotify Green for the arrow icon
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    List<String> lines = _artistInfo!.split('\n');
                    String artistName = '';
                    for (var line in lines) {
                      if (line.startsWith('Artist:')) {
                        artistName = line.substring('Artist:'.length).trim();
                        break;
                      }
                    }
                    return LyricsScreen(
                      artistName: artistName,
                      trackName: _topTracks[index],
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
