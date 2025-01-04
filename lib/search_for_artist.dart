import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:spotify_lyrics/artist_info.dart';
import 'package:spotify_lyrics/image_of_artist.dart';
import 'dart:developer';
import 'dart:convert';
import 'package:spotify_lyrics/top_tracks_list_view.dart';

const String clientId = 'fe66c062654344b6a2d20d0016fb0462';
const String clientSecret = 'a0ad3d3630d94018a5339480255e85f7';
const Color spotifyGreen = Color(0xFF1DB954);  // Spotify's color

class SearchForArtist extends StatefulWidget {
  const SearchForArtist({super.key});

  @override
  State<SearchForArtist> createState() => _SearchForArtistState();
}

class _SearchForArtistState extends State<SearchForArtist> {
  final TextEditingController _artistNameController = TextEditingController();
  String? _artistInfo;
  List<String> _topTracks = [];
  bool _isLoading = false;
  String? _artistImage;

  Future<String?> _getSpotifyAccessToken() async {
    final String credentials =
    base64Encode(utf8.encode('$clientId:$clientSecret'));

    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {
        'Authorization': 'Basic $credentials',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'grant_type': 'client_credentials',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['access_token'];
    } else {
      log('Failed to get access token: ${response.statusCode}');
      return null;
    }
  }

  Future<void> _getArtistAndTopTracks(String artistName) async {
    setState(() {
      _isLoading = true;
      _topTracks = [];
    });

    final accessToken = await _getSpotifyAccessToken();
    if (accessToken == null) return;

    final artistResponse = await http.get(
      Uri.parse(
          'https://api.spotify.com/v1/search?q=$artistName&type=artist&limit=1'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (artistResponse.statusCode == 200) {
      final Map<String, dynamic> artistData = json.decode(artistResponse.body);
      if (artistData['artists']['items'].isNotEmpty) {
        final artist = artistData['artists']['items'][0];
        final artistId = artist['id'];

        setState(() {
          _artistInfo = 'Artist: ${artist['name']}\n'
              'Followers: ${artist['followers']['total']}\n'
              'Genres: ${artist['genres'].join(', ')}\n'
              'Popularity: ${artist['popularity']}\n';

          _artistImage = artist['images'][0]['url'];
        });

        await _getTopTracks(artistId, accessToken);
      } else {
        setState(() {
          _artistInfo = 'No artist found.';
        });
      }
    } else {
      log('Error fetching artist info: ${artistResponse.statusCode}');
    }

    setState(() => _isLoading = false);
  }

  Future<void> _getTopTracks(String artistId, String token) async {
    final topTracksResponse = await http.get(
      Uri.parse(
          'https://api.spotify.com/v1/artists/$artistId/top-tracks?market=US'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (topTracksResponse.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(topTracksResponse.body);
      final List<dynamic> tracks = data['tracks'];
      setState(() {
        _topTracks = tracks.map((track) => track['name'].toString()).toList();
      });
    } else {
      log('Error fetching top tracks: ${topTracksResponse.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spotify Artist Search'),
        centerTitle: true,
        backgroundColor: spotifyGreen, // Spotify's Green
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Circular Search Bar with onSubmitted callback
              TextField(
                controller: _artistNameController,
                decoration: InputDecoration(
                  labelText: 'Search Artist',
                  labelStyle: const TextStyle(
                    fontSize: 20,
                    color: spotifyGreen,  // Change label text color to Spotify's Green
                  ),
                  hintText: 'Enter artist name...',
                  hintStyle: const TextStyle(color: spotifyGreen), // Hint text style
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0), // Circular border
                    borderSide: const BorderSide(color: spotifyGreen, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(color: spotifyGreen, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0), // Circular border
                    borderSide: const BorderSide(color: Colors.white, width: 2),
                  ),
                  prefixIcon: const Icon(Icons.search, color: spotifyGreen),  // Icon on the left side
                  suffixIcon: _artistNameController.text.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear, color: spotifyGreen),
                    onPressed: () {
                      _artistNameController.clear();
                      setState(() {});
                    },
                  )
                      : null, // Clear button when there's text
                  filled: true,
                  fillColor: spotifyGreen.withOpacity(0.1), // Background color with light opacity
                  contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20), // Padding inside text field
                ),
                style: const TextStyle(
                  fontSize: 18,  // Text size inside text field
                  color: Colors.black87, // Text color
                ),
                onSubmitted: (text) {
                  if (text.isNotEmpty) {
                    _getArtistAndTopTracks(text);
                  }
                },
              ),

              const SizedBox(height: 16),
              const SizedBox(height: 20),
              if (_isLoading) const Center(child: CircularProgressIndicator()),
              if (!_isLoading && _artistInfo != null) ...[
                if (_artistImage != null)
                  ImageOfArtist(artistImage: _artistImage),
                const SizedBox(height: 16),
                ArtistInfo(artistInfo: _artistInfo),
                const SizedBox(height: 16),
                if (_topTracks.isNotEmpty) ...[
                  const Text(
                    'Top Tracks:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TopTracksListView(
                    topTracks: _topTracks,
                    artistInfo: _artistInfo,
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
