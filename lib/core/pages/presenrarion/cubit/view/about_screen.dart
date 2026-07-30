import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listys_app/core/network/dio_client.dart';
import 'package:listys_app/core/pages/presenrarion/cubit/view/page_cubit.dart';
import 'package:listys_app/core/localization/app_localizations.dart';
import 'package:shimmer/shimmer.dart';

class AboutListysScreen extends StatelessWidget {
  const AboutListysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) => PagesCubit(DioClient())..fetchPage('about-us'),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white12,
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      loc.aboutListys,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<PagesCubit, PagesState>(
                  builder: (context, state) {
                    if (state is PagesLoading) {
                      return _buildAboutUsSkeleton();
                    } else if (state is PagesError) {
                      return Center(
                        child: Text(state.message, style: const TextStyle(color: Colors.white)),
                      );
                    } else if (state is PagesLoaded) {
                      final content = state.pageData['content'];
                      final paragraphs = (content['paragraphs'] as List<dynamic>? ?? [])
                          .map((e) => e.toString())
                          .join('\n\n'); 
                      
                      final version = content['version'] ?? '1.0.0';

                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(24.0),
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: const Color(0x07FFFFFF),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: const Color(0x09FFFFFF), width: 1),
                              ),
                              child: Image.asset(
                                'assets/images/splash/listys_logo.png',
                                width: 150,
                                height: 80,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 40),
                            Text(
                              loc.discoverWorldAroundYou,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white, height: 1.3),
                            ),
                            const SizedBox(height: 24),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: const Color(0x07FFFFFF),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: const Color(0x09FFFFFF), width: 1),
                              ),
                              child: Text(
                                paragraphs.isNotEmpty ? paragraphs : loc.aboutListysDesc,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16, color: Colors.grey[300], height: 1.6),
                              ),
                            ),
                            const SizedBox(height: 40),
                            Text(
                              "${loc.version} $version",
                              style: TextStyle(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAboutUsSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[700]!,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Container(width: 190, height: 120, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(24))),
            const SizedBox(height: 40),
            Container(width: 220, height: 28, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(6))),
            const SizedBox(height: 8),
            Container(width: 160, height: 28, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(6))),
            const SizedBox(height: 24),
            Container(width: double.infinity, height: 180, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(16))),
            const SizedBox(height: 40),
            Container(width: 100, height: 14, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(4))),
          ],
        ),
      ),
    );
  }
}