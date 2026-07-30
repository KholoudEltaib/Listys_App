import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listys_app/core/network/dio_client.dart';
import 'package:listys_app/core/pages/presenrarion/cubit/view/page_cubit.dart';
import 'package:listys_app/core/theme/app_color.dart';
import 'package:listys_app/core/localization/app_localizations.dart';
import 'package:shimmer/shimmer.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) => PagesCubit(DioClient())..fetchPage('contact-us'),
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
                      loc.contactUs,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<PagesCubit, PagesState>(
                  builder: (context, state) {
                    if (state is PagesLoading) {
                      return _buildContactUsSkeleton();
                    } else if (state is PagesError) {
                      return Center(
                        child: Text(state.message, style: const TextStyle(color: Colors.white)),
                      );
                    } else if (state is PagesLoaded) {
                      final content = state.pageData['content'];
                      final email = content['email'] ?? "listys.2025@gmail.com";
                      final message = content['message'] ?? loc.contactUsDesc;

                      return Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.headset_mic_rounded, size: 80, color: AppColors.primaryColor),
                            ),
                            const SizedBox(height: 32),
                            Text(
                              loc.wereHereToHelp,
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              message,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16, color: Colors.grey[400], height: 1.5),
                            ),
                            const SizedBox(height: 40),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              decoration: BoxDecoration(
                                color: const Color(0x07FFFFFF),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: const Color(0x09FFFFFF), width: 1),
                              ),
                              child: Column(
                                children: [
                                  const Icon(Icons.email_outlined, color: Colors.white, size: 28),
                                  const SizedBox(height: 12),
                                  Text(
                                    email,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
                                  ),
                                ],
                              ),
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

  Widget _buildContactUsSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[700]!,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 128, height: 128, decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle)),
            const SizedBox(height: 32),
            Container(width: 200, height: 24, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(6))),
            const SizedBox(height: 12),
            Container(width: double.infinity, height: 48, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(6))),
            const SizedBox(height: 40),
            Container(width: double.infinity, height: 100, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(16))),
          ],
        ),
      ),
    );
  }
}