import 'package:flutter/material.dart';
import 'package:listys_app/core/localization/app_localizations.dart';
import 'package:listys_app/features/home/presentation/widgets/header.dart';

class EmptyFavorite extends StatelessWidget {
  const EmptyFavorite({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Header(),
                  const SizedBox(height: 12),
                  Column(
                    children: [
                      Image.asset('assets/images/fav/empty.png', width: 320, height: 200),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        loc.no_favorites_yet,
                        style: const TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                    Text(
                    loc.empty_favorite_description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                const Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                      height: 56,
                      
                      ),
                    ),
                  ],
                ),
                  const SizedBox(height: 12),
                  Container(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}