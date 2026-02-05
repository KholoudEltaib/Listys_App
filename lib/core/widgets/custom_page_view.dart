import 'package:flutter/material.dart';

class CustomPageView extends StatelessWidget {
  const CustomPageView({
    super.key,
    required this.tabController,
    required this.taps,
    required this.pages,
  });

  final TabController tabController;
  final List taps;
  final Widget Function(int index) pages;
  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
      physics: const NeverScrollableScrollPhysics(), // disables swipe
      children: List.generate(
        taps.length,
        (index) => AnimatedSwitcher(
          duration: const Duration(milliseconds: 1200),
          transitionBuilder: (Widget child, Animation<double> animation) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubicEmphasized,
            );
            return FadeTransition(
              opacity: curvedAnimation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0), // Less aggressive slide
                  end: Offset.zero,
                ).animate(curvedAnimation),
                child: child,
              ),
            );
          },
          child: pages(index),
        ),
      ),
    );
  }
}
