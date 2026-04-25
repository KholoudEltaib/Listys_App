import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listys_app/core/routes/app_routes.dart';
import 'package:listys_app/features/sining/forget_password_screens/forgotpassword_screen.dart';
import '../auth/presentation/bloc/auth_bloc.dart';
import '../auth/presentation/bloc/auth_event.dart';
import '../auth/presentation/bloc/auth_state.dart';
import 'package:listys_app/core/localization/app_localizations.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  final void Function(Locale)? onLocaleChange;
  const LoginScreen({super.key, this.onLocaleChange});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  bool _hasAttemptedLogin = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _loginWithEmail() {
    setState(() => _hasAttemptedLogin = true);

    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    context.read<AuthBloc>().add(LoginWithEmailRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ));
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontFamily: 'Instrument Sans',
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFD32F2F),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            _showError(context, state.message);
          } else if (state is AuthAuthenticated) {
            // Only navigate on a genuine successful login —
            // this is inside the listener so it only fires on state changes.
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.mainScreen,
              (route) => false,
            );
          }
        },
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo
                Image.asset(
                  'assets/images/splash/listys_logo.png',
                  width: 190,
                  height: 80,
                ),
                const SizedBox(height: 40),

                // Title
                Text(
                  loc.welcomeBack,
                  style: const TextStyle(
                    fontFamily: 'Instrument Sans',
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ── Email ───────────────────────────────────────────
                      _buildLabel(loc.email),
                      const SizedBox(height: 8),
                      _buildEmailField(loc),
                      const SizedBox(height: 24),

                      // ── Password ────────────────────────────────────────
                      _buildLabel(loc.password),
                      const SizedBox(height: 8),
                      _buildPasswordField(loc),
                      const SizedBox(height: 8),

                      // ── Forgot Password ─────────────────────────────────
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const ForgetPasswordScreen(),
                              ),
                            );
                          },
                          child: Text(
                            loc.forgot_password,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontFamily: 'Instrument Sans',
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // ── Sign In Button ──────────────────────────────────
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          final isLoading = state is AuthLoading;
                          return SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : _loginWithEmail,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF9B933),
                                foregroundColor: const Color(0xFF212529),
                                disabledBackgroundColor:
                                    const Color(0xFFF9B933).withOpacity(0.6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                textStyle: const TextStyle(
                                  fontFamily: 'Instrument Sans',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                                elevation: 0,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Color(0xFF212529),
                                      ),
                                    )
                                  : Text(loc.login),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),

                      // ── Divider ─────────────────────────────────────────
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(color: Colors.white30, thickness: 1),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              loc.translate('orSignInWith'),
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontFamily: 'Instrument Sans',
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Divider(color: Colors.white30, thickness: 1),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // ── Google Button ───────────────────────────────────
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          final isLoading = state is AuthLoading;
                          return ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    FocusScope.of(context).unfocus();
                                    context.read<AuthBloc>().add(
                                          LoginWithGoogleRequested(
                                              context: context),
                                        );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF212529),
                              foregroundColor: const Color(0xFFF9B933),
                              disabledForegroundColor:
                                  const Color(0xFFF9B933).withOpacity(0.4),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: isLoading
                                      ? const Color(0xFFF9B933).withOpacity(0.3)
                                      : const Color(0xFFF9B933),
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              textStyle: const TextStyle(
                                fontFamily: 'Instrument Sans',
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                              elevation: 0,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Text(loc.login_with_google),
                          );
                        },
                      ),
                      const SizedBox(height: 32),

                      // ── Sign Up Link ────────────────────────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            loc.dontHaveAccount,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontFamily: 'Instrument Sans',
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const RegisterScreen(),
                                ),
                              );
                            },
                            child: Text(
                              loc.sign_up,
                              style: const TextStyle(
                                color: Color(0xFFF9B933),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Instrument Sans',
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontFamily: 'Instrument Sans',
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
    );
  }

  Widget _buildEmailField(AppLocalizations loc) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        style: const TextStyle(
          fontFamily: 'Instrument Sans',
          color: Colors.white,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.email_outlined, color: Colors.white54),
          border: InputBorder.none,
          hintText: loc.enter_your_email,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.4),
            fontFamily: 'Instrument Sans',
            fontSize: 16,
          ),
        ),
        autovalidateMode: _hasAttemptedLogin
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return loc.email; // replace with a proper message if available
          }
          if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+').hasMatch(value.trim())) {
            return loc.email;
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordField(AppLocalizations loc) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextFormField(
        controller: _passwordController,
        obscureText: _obscurePassword,
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (_) => _loginWithEmail(),
        style: const TextStyle(
          fontFamily: 'Instrument Sans',
          color: Colors.white,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock_outline, color: Colors.white54),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: Colors.white54,
              size: 20,
            ),
            onPressed: () =>
                setState(() => _obscurePassword = !_obscurePassword),
          ),
          border: InputBorder.none,
          hintText: '••••••••••',
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.4),
            fontFamily: 'Instrument Sans',
            fontSize: 16,
            letterSpacing: 2,
          ),
        ),
        autovalidateMode: _hasAttemptedLogin
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return loc.password;
          }
          return null;
        },
      ),
    );
  }
}