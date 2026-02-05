// // lib/features/auth/presentation/screens/social_login_webview_screen.dart

// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class SocialLoginWebViewScreen extends StatefulWidget {
//   final String provider; // 'google' or 'facebook'
//   final String baseUrl; // Your backend URL

//   const SocialLoginWebViewScreen({
//     Key? key,
//     required this.provider,
//     required this.baseUrl,
//   }) : super(key: key);

//   @override
//   State<SocialLoginWebViewScreen> createState() => _SocialLoginWebViewScreenState();
// }

// class _SocialLoginWebViewScreenState extends State<SocialLoginWebViewScreen> {
//   late final WebViewController _controller;
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _initializeWebView();
//   }

//   void _initializeWebView() {
//     _controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onPageStarted: (String url) {
//             print('🔵 Page started loading: $url');
//             _checkForCallback(url);
//           },
//           onPageFinished: (String url) {
//             print('🟢 Page finished loading: $url');
//             setState(() {
//               _isLoading = false;
//             });
//           },
//           onWebResourceError: (WebResourceError error) {
//             print('❌ WebView error: ${error.description}');
//             setState(() {
//               _isLoading = false;
//             });
//           },
//         ),
//       )
//       ..loadRequest(
//         Uri.parse('${widget.baseUrl}/auth/social/${widget.provider}'),
//       );
//   }

//   void _checkForCallback(String url) {
//     // Check if URL contains the success callback
//     if (url.contains('/auth/social/callback') || url.contains('success=true')) {
//       print('🎉 Social login successful! URL: $url');
      
//       // Extract token from URL
//       final uri = Uri.parse(url);
//       final token = uri.queryParameters['token'];
//       final userData = uri.queryParameters['user'];
      
//       if (token != null) {
//         // Return token to previous screen
//         Navigator.pop(context, {
//           'token': token,
//           'user': userData,
//         });
//       } else {
//         print('❌ No token found in callback URL');
//         _showError('Login failed. No token received.');
//       }
//     }
    
//     // Check for error
//     if (url.contains('error=')) {
//       final uri = Uri.parse(url);
//       final error = uri.queryParameters['error'] ?? 'Unknown error';
//       print('❌ Social login error: $error');
//       _showError(error);
//     }
//   }

//   void _showError(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red,
//       ),
//     );
    
//     // Close after 2 seconds
//     Future.delayed(const Duration(seconds: 2), () {
//       if (mounted) {
//         Navigator.pop(context);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Sign in with ${widget.provider == 'google' ? 'Google' : 'Facebook'}'),
//         leading: IconButton(
//           icon: const Icon(Icons.close),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Stack(
//         children: [
//           WebViewWidget(controller: _controller),
//           if (_isLoading)
//             const Center(
//               child: CircularProgressIndicator(),
//             ),
//         ],
//       ),
//     );
//   }
// }