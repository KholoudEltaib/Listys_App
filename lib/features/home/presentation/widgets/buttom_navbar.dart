import 'package:flutter/material.dart';
import 'package:listys_app/core/localization/app_localizations.dart';
import 'package:listys_app/core/theme/app_color.dart';
import 'package:listys_app/features/favorite/presentation/widgets/fav_root.dart';
import 'package:listys_app/features/home/presentation/screens/home_screen.dart';
import 'package:listys_app/features/profile/presentation/view/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  List<Widget> get _screens => [
    const HomeScreen(),
    const FavoritesRoot(),
    ProfileScreen(),
  ];

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // ---------- PageView ----------
          PageView(
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            children: _screens,
          ),

          // ---------- Bottom Navbar ----------
          ButtomNavbar(
            currentIndex: _currentIndex,
            onTap: _onNavTap,
          ),
        ],
      ),
    );
  }
}

class ButtomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const ButtomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Positioned(
      left: 20,
      right: 20,
      bottom: 40,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        height: 64,
        decoration: BoxDecoration(
          color: Colors.grey[850]!.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
          NavBarIcon(
            icon: Icons.home_filled,
            label: currentIndex == 0 ? loc.home : '',
            isSelected: currentIndex == 0,
            onTap: () => onTap(0),
          ),
          NavBarIcon(
            icon: currentIndex == 1 ? Icons.favorite : Icons.favorite_border,
            label: currentIndex == 1 ? loc.favorites : '',
            isSelected: currentIndex == 1,
            onTap: () => onTap(1),
          ),
          NavBarIcon(
            icon: Icons.person,
            label: currentIndex == 2 ? loc.profile : '',
            isSelected: currentIndex == 2,
            onTap: () => onTap(2),
          ),
        ],
        ),
      ),
    );
  }
}

class NavBarIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const NavBarIcon({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor = isSelected ? AppColors.primaryColor : Colors.transparent;
    Color iconColor = isSelected ? Colors.black : Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: label.isEmpty
            ? const EdgeInsets.all(8)
            : const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: label.isEmpty
            ? Icon(icon, color: iconColor, size: 24)
            : Row(
                children: [
                  Icon(icon, color: iconColor, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      color: iconColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
