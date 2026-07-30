import 'package:flutter/material.dart';
import 'package:listys_app/core/localization/app_localizations.dart';
import 'package:listys_app/core/localization/locale_cubit/locale_state.dart';
import 'package:listys_app/core/theme/app_color.dart';
import 'package:listys_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:listys_app/core/pages/presenrarion/cubit/view/about_screen.dart';
import 'package:listys_app/core/pages/presenrarion/cubit/view/contact_us_screen.dart';
import 'package:listys_app/core/pages/presenrarion/cubit/view/privacy_policy_screen.dart';
import 'package:listys_app/features/nearby_map/presentation/view/nearby_map_screen.dart';
import 'package:listys_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:listys_app/features/sining/login_screen.dart';
import 'package:listys_app/core/di/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listys_app/core/localization/locale_cubit/locale_cubit.dart';
import 'package:listys_app/core/networking/dio_factory.dart';

class CustomHomeDrawer extends StatelessWidget {
  final Function(int) onNavigate; 
  const CustomHomeDrawer({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    
    return Drawer(
      backgroundColor: AppColors.backgroundGradient.colors.first.withOpacity(0.9), 
      child: Column(
        children: [
          BlocProvider(
            create: (_) => getIt<ProfileCubit>()..fetchProfile(),
            child: BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                final user = state is ProfileLoaded
                    ? state.user
                    : state is ProfileUpdateSuccess
                        ? state.user
                        : context.read<ProfileCubit>().cachedUser;

                final isLoading = state is ProfileLoading && user == null;

                return UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(
                    color: Color(0x07FFFFFF),
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: const Color(0xFFF9B933),
                    backgroundImage: (user != null && user.hasImage)
                        ? NetworkImage(user.fullImageUrl)
                        : null,
                    child: (user == null || !user.hasImage)
                        ? const Icon(Icons.person, color: Colors.white, size: 40)
                        : null,
                  ),
                  accountName: Text(
                    isLoading ? loc.loading : (user?.name ?? ''), 
                    style: const TextStyle(
                      fontWeight: FontWeight.bold, 
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  accountEmail: Text(
                    user?.email ?? '', 
                    style: const TextStyle(color: Colors.white70),
                  ),
                );
              },
            ),
          ),
          
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  icon: Icons.home_rounded,
                  title: loc.home,
                  onTap: () {
                    Navigator.pop(context); 
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.explore_outlined, 
                  title: loc.nearbyMap,
                  onTap: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NearbyMapScreen(),
                    ),
                  );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.favorite_border_rounded,
                  title: loc.favorites,
                  onTap: () {
                    Navigator.pop(context); 
                    onNavigate(1); 
                  },
                ),
                _buildDrawerItem(
                icon: Icons.person_outline,
                title: loc.profile,
                onTap: () {
                  Navigator.pop(context);
                  onNavigate(2); 
                },
                ),

                const Divider(color: Colors.white24, height: 32),

                _buildDrawerItem(
                  icon: Icons.language_rounded,
                  title: loc.language,
                  trailing: BlocBuilder<LocaleCubit, LocaleState>(
                    builder: (context, state) {
                      // عرض اللغة الحالية في الـ trailing
                      final isArabic = state.locale.languageCode == 'ar';
                      return Text(
                        isArabic ? 'العربية' : 'English',
                        style: const TextStyle(color: Color(0xFFF9B933), fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                  onTap: () {
                    // 2. منطق تبديل اللغة مباشرة
                    final localeCubit = context.read<LocaleCubit>();
                    
                    if (localeCubit.isArabic) {
                      localeCubit.setEnglish();
                    } else {
                      localeCubit.setArabic();
                    }

                    DioFactory.addDioHeaders();
                    
                    Navigator.pop(context);
                  },
                ),

                // _buildDrawerItem(
                //   icon: Icons.settings_outlined,
                //   title: loc.settings,
                //   onTap: () {
                //     // Navigation logic
                //   },
                // ),

                const Divider(color: Colors.white24, height: 32),

                _buildDrawerItem(
                  icon: Icons.privacy_tip_outlined,
                  title:loc.privacyPolicy,
                  onTap: () {
                    Navigator.pop(context); 
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
                    );
                  },
                ),

                _buildDrawerItem(
                  icon: Icons.headset_mic_outlined,
                  title:loc.contactUs,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => const ContactUsScreen()),
                    );
                  },
                ),

                _buildDrawerItem(
                  icon: Icons.info_outline_rounded,
                  title: loc.aboutListys,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => const AboutListysScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
          
          const Divider(color: Colors.white24, height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child:_buildDrawerItem(
            icon: Icons.logout_rounded,
            title: loc.logout,
            iconColor: Colors.redAccent,
            textColor: Colors.redAccent,
            onTap: () async {
              Navigator.pop(context);

              final authRepository = getIt<AuthRepository>();
              await authRepository.logout();

              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
          ),
          ),
          const SizedBox(height: 12), 
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color iconColor = Colors.white70,
    Color textColor = Colors.white,
    Widget? trailing, 
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: TextStyle(color: textColor, fontSize: 16),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }
}