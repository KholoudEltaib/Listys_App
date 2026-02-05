// // lib/core/helpers/social_login_helper.dart

// import 'package:flutter/material.dart';
// import '../../features/auth/presentation/screens/social_login_webview_screen.dart';

// class SocialLoginHelper {
//   static const String baseUrl = 'https://listys.net/api'; // Your backend URL

//   /// Opens WebView for social login and returns token
//   static Future<Map<String, dynamic>?> loginWithProvider(
//     BuildContext context,
//     String provider,
//   ) async {
//     try {
//       print('🔵 Opening $provider login WebView...');
      
//       final result = await Navigator.push<Map<String, dynamic>>(
//         context,
//         MaterialPageRoute(
//           builder: (context) => SocialLoginWebViewScreen(
//             provider: provider,
//             baseUrl: baseUrl,
//           ),
//         ),
//       );
      
//       if (result != null) {
//         print('🟢 Social login successful: $result');
//         return result;
//       } else {
//         print('⚠️ Social login cancelled');
//         return null;
//       }
//     } catch (e) {
//       print('❌ Social login error: $e');
//       return null;
//     }
//   }

//   /// Login with Google
//   static Future<Map<String, dynamic>?> loginWithGoogle(BuildContext context) {
//     return loginWithProvider(context, 'google');
//   }

//   /// Login with Facebook
//   static Future<Map<String, dynamic>?> loginWithFacebook(BuildContext context) {
//     return loginWithProvider(context, 'facebook');
//   }
// }