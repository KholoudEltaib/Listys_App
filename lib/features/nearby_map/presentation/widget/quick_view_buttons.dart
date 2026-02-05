// // features/nearby_map/presentation/widgets/quick_view_buttons.dart

// import 'package:flutter/material.dart';
// import 'package:listys_app/features/nearby_map/presentation/cubit/nearby_map_state.dart';
// import 'package:listys_app/features/nearby_map/presentation/view/nearby_map_screen.dart';

// /// Quick access buttons to open map with different view modes
// class QuickViewButtons extends StatelessWidget {
//   const QuickViewButtons({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Explore Places',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               Expanded(
//                 child: _QuickViewCard(
//                   icon: Icons.my_location,
//                   title: 'Nearby',
//                   subtitle: '10 km',
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFFF9B933), Color(0xFFFFD700)],
//                   ),
//                   onTap: () => _openMapWithMode(context, ViewMode.nearby, 10),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _QuickViewCard(
//                   icon: Icons.location_city,
//                   title: 'City',
//                   subtitle: 'All in city',
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
//                   ),
//                   onTap: () => _openMapWithMode(context, ViewMode.city, 50),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           _QuickViewCard(
//             icon: Icons.explore,
//             title: 'Explore All Places',
//             subtitle: 'View all available locations',
//             gradient: const LinearGradient(
//               colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
//             ),
//             onTap: () => _openMapWithMode(context, ViewMode.unlimited, 1000),
//             isWide: true,
//           ),
//         ],
//       ),
//     );
//   }

//   void _openMapWithMode(BuildContext context, ViewMode mode, double radius) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => NearbyMapScreen(
//           initialMode: mode,
//           initialRadius: radius,
//         ),
//       ),
//     );
//   }
// }

// class _QuickViewCard extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String subtitle;
//   final Gradient gradient;
//   final VoidCallback onTap;
//   final bool isWide;

//   const _QuickViewCard({
//     required this.icon,
//     required this.title,
//     required this.subtitle,
//     required this.gradient,
//     required this.onTap,
//     this.isWide = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.all(isWide ? 20 : 16),
//         decoration: BoxDecoration(
//           gradient: gradient,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.2),
//               blurRadius: 10,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: isWide
//             ? Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Icon(
//                       icon,
//                       color: Colors.white,
//                       size: 28,
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           title,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           subtitle,
//                           style: TextStyle(
//                             color: Colors.white.withOpacity(0.9),
//                             fontSize: 13,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const Icon(
//                     Icons.arrow_forward_ios,
//                     color: Colors.white,
//                     size: 20,
//                   ),
//                 ],
//               )
//             : Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Icon(
//                     icon,
//                     color: Colors.white,
//                     size: 32,
//                   ),
//                   const SizedBox(height: 12),
//                   Text(
//                     title,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     subtitle,
//                     style: TextStyle(
//                       color: Colors.white.withOpacity(0.9),
//                       fontSize: 12,
//                     ),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }
// }