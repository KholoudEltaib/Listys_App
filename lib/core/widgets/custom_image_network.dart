import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomImageNetwork extends StatelessWidget {
  const CustomImageNetwork(
      {super.key, required this.image, this.width, this.height});

  final String image;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      image,
      fit: BoxFit.cover,
      width: width,
      height: height,
      errorBuilder: (_, __, ___) => Center(
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            shape: BoxShape.circle, 
            color: Colors.grey[800], // Darkened to fit your dark theme
          ),
          child: const Center(
            child: Icon(
              Icons.image,
              color: Colors.grey,
            ),
          ),
        ),
      ),
      loadingBuilder: (_, child, progress) => progress == null
          ? child
          : Shimmer.fromColors(
              baseColor: Colors.grey[800]!,
              highlightColor: Colors.grey[700]!,
              child: Container(
                width: width ?? double.infinity,
                height: height ?? double.infinity,
                color: Colors.black, // Requires a solid color to render shimmer
              ),
            ),
    );
  }
}