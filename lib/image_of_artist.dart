import 'package:flutter/material.dart';

class ImageOfArtist extends StatelessWidget {
  const ImageOfArtist({
    super.key,
    required String? artistImage,
  }) : _artistImage = artistImage;

  final String? _artistImage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          _artistImage!,
          width: 300,
          height: 300,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
