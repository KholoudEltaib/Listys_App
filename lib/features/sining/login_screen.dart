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

  // Future<void> _loginWithInstagram() async {
  //   context.read<AuthBloc>().add(LoginWithInstagramRequested());
  // }

  Future<void> _loginWithEmail() async {
    if (!_formKey.currentState!.validate()) return;
    
    context.read<AuthBloc>().add(LoginWithEmailRequested(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    ));
  }

  // Future<void> _loginWithGoogle() async {
  //   context.read<AuthBloc>().add(LoginWithGoogleRequested(context: context));
  // }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
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
              
              // Welcome Back Title
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
              
              BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red.shade100,
                        duration: const Duration(seconds: 4),
                      ),
                    );
                  } else if (state is AuthAuthenticated) {
                    // Navigate to Main Screen after successful login
                    Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.mainScreen,
                    (route) => false, 
                  );
                  }
                },
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Email Section
                      _buildLabel(loc.email),
                      const SizedBox(height: 8),
                      _buildEmailField(loc),
                      const SizedBox(height: 24),
                      
                      // Password Section
                      _buildLabel(loc.password),
                      const SizedBox(height: 8),
                      _buildPasswordField(loc),
                      const SizedBox(height: 16),
                      
                      // Forget Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>  ForgetPasswordScreen(),
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
                      // Sign In Button
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          return SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: state is AuthLoading
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : ElevatedButton(
                                    onPressed: _loginWithEmail,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFF9B933),
                                      foregroundColor: const Color(0xFF212529),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      textStyle: const TextStyle(
                                        fontFamily: 'Instrument Sans',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                    ),
                                    child: Text(loc.login),
                                  ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      
                      // Or sign with text
                      
                      Row(
                      children: [
                        const Expanded(
                          child: Divider(
                            color: Colors.white30,
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
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
                          child: Divider(
                            color: Colors.white30,
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                      const SizedBox(height: 20),
                      
                      // Social Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _SocialIconButton(
                            icon: Icons.g_mobiledata_rounded,
                            onTap: () {
                              context.read<AuthBloc>().add(LoginWithGoogleRequested(context: context)); 
                            },
                          ),                          
                          const SizedBox(width: 24),
                          _SocialIconButton(
                            icon: Icons.facebook,
                            onTap: () {
                            context.read<AuthBloc>().add(LoginWithFacebookRequested(context: context)); 
                            },
                          ),
                          
                        ],
                      ),
                      const SizedBox(height: 32),
                      
                      // Don't have an account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            // "Don't have an account ? ",
                            loc.dontHaveAccount,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontFamily: 'Instrument Sans',
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
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
              ),
            ],
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
        style: const TextStyle(
          fontFamily: 'Instrument Sans', 
          color: Colors.white,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.email, color: Colors.white54),
          border: InputBorder.none,
          hintText: loc.enter_your_email,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontFamily: 'Instrument Sans',
            fontSize: 16,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return loc.email;
          }
          if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+').hasMatch(value)) {
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
        obscureText: true,
        style: const TextStyle(
          fontFamily: 'Instrument Sans', 
          color: Colors.white,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock, color: Colors.white54),
          border: InputBorder.none,
          hintText: '**********',
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontFamily: 'Instrument Sans',
            fontSize: 16,
            letterSpacing: 2,
          ),
        ),
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

class _SocialIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _SocialIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  State<_SocialIconButton> createState() => _SocialIconButtonState();
}

class _SocialIconButtonState extends State<_SocialIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 120),
      vsync: this,
      lowerBound: 0.0,
      upperBound: 1.0,
    );

    _scaleAnim = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          width: 50,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(widget.icon, color: Colors.white, size: 24),
        ),
      ),
    );
  }
}
