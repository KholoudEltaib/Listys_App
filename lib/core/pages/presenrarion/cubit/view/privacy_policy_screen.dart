import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listys_app/core/network/dio_client.dart';
import 'package:listys_app/core/pages/presenrarion/cubit/view/page_cubit.dart';
import 'package:listys_app/core/theme/app_color.dart';
import 'package:listys_app/core/localization/app_localizations.dart';
import 'package:listys_app/core/theme/shimmer_loading.dart';
import 'package:shimmer/shimmer.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) => PagesCubit(DioClient())..fetchPage('privacy-policy'),
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
                      loc.privacyPolicy,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<PagesCubit, PagesState>(
                  builder: (context, state) {
                    if (state is PagesLoading) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Shimmer.fromColors(
                              baseColor: Colors.grey[800]!,
                              highlightColor: Colors.grey[700]!,
                              child: Container(width: 150, height: 14, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(4))),
                            ),
                            const SizedBox(height: 24),
                            const Expanded(child: ShimmerVerticalList(itemCount: 4, height: 110)), 
                          ],
                        ),
                      );
                    } else if (state is PagesError) {
                      return Center(
                        child: Text(state.message, style: const TextStyle(color: Colors.white)),
                      );
                    } else if (state is PagesLoaded) {
                      final content = state.pageData['content'];
                      final sections = content['sections'] as List<dynamic>? ?? [];

                      return SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(loc.lastUpdated, style: TextStyle(color: Colors.grey[500], fontSize: 14)),
                            const SizedBox(height: 24),
                            ...sections.map((section) {
                              return _buildPolicyCard(
                                title: section['title'] ?? '',
                                content: section['body'] ?? '',
                              );
                            }),
                            const SizedBox(height: 40),
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

  Widget _buildPolicyCard({required String title, required String content}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0x07FFFFFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x09FFFFFF), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryColor)),
          const SizedBox(height: 8),
          Text(content, style: TextStyle(fontSize: 15, color: Colors.grey[300], height: 1.5)),
        ],
      ),
    );
  }
}