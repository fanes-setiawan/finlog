import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileAvatar extends StatelessWidget {
  final String imageUrl;
  final double size;
  final double borderWidth;
  final Color borderColor;
  final Color backgroundColor;

  const ProfileAvatar({
    super.key,
    required this.imageUrl,
    this.size = 60.0,
    this.borderWidth = 2.0,
    this.borderColor = Colors.black,
    this.backgroundColor = Colors.white, // Default background color
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor, // Added background color
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
      ),
      child: ClipOval(
        child: AspectRatio(
          aspectRatio: 1.0, // width/height = 1 untuk menjaga bentuk lingkaran
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Icon(
              Icons.person,
              color: Colors.black,
              size: 40 / 60 * size,
            ),
            errorWidget: (context, url, error) => Icon(
              Icons.person,
              color: Colors.black,
              size: 40 / 60 * size,
            ),
          ),
        ),
      ),
    );
  }
}
