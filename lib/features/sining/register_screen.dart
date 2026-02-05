import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listys_app/core/routes/app_routes.dart';
import 'package:listys_app/features/home/presentation/widgets/buttom_navbar.dart';
import 'package:listys_app/features/sining/login_screen.dart';
import 'package:listys_app/features/sining/otp_screen.dart';
import '../auth/presentation/bloc/auth_bloc.dart';
import '../auth/presentation/bloc/auth_event.dart';
import '../auth/presentation/bloc/auth_state.dart';
import 'package:listys_app/core/localization/app_localizations.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    
    context.read<AuthBloc>().add(RegisterRequested(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
    ));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
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
                loc.translate('createAccount'),
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
                    Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.mainScreen,
                    (route) => false, 
                  );  
                  // Navigator.of(context).pushReplacement(
                  //   MaterialPageRoute(
                  //     builder: (context) => const MainScreen(),
                  //   ),
                  // );
                    // Navigator.of(context).pushReplacement(
                    //   MaterialPageRoute(
                    //     builder: (context) => OtpVerificationScreen(email: _emailController.text.trim()),
                    //   ),
                    // );
                  }
                },
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Name Section
                      _buildLabel(loc.translate('name')),
                      const SizedBox(height: 8),
                      _buildNameField(loc),
                      const SizedBox(height: 24),
                      
                      // Email Section
                      _buildLabel(loc.translate('email')),
                      const SizedBox(height: 8),
                      _buildEmailField(loc),
                      const SizedBox(height: 24),
                      
                      // Password Section
                      _buildLabel(loc.translate('password')),
                      const SizedBox(height: 8),
                      _buildPasswordField(loc),
                      const SizedBox(height: 24),
                      
                      // Confirm Password Section
                      _buildLabel(loc.translate('confirmPassword')),
                      const SizedBox(height: 8),
                      _buildConfirmPasswordField(loc),
                      const SizedBox(height: 28),
                      
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
                                    onPressed: _register,
                                    onLongPress: () {
                                      // اختياري: للحاجة إلى test OTP screen مباشرة
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => OtpVerificationScreen(email: _emailController.text.trim()),
                                        ),
                                      );
                                    },
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
                                    child: Text(loc.translate('createAccount')),
                                  ),
                          );
                        },
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

  Widget _buildNameField(AppLocalizations loc) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextFormField(
        controller: _nameController,
        style: const TextStyle(
          fontFamily: 'Instrument Sans', 
          color: Colors.white,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.person, color: Colors.white54),
          border: InputBorder.none,
          hintText: loc.enter_your_name,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontFamily: 'Instrument Sans',
            fontSize: 16,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return loc.name;
          }
          return null;
        },
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
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.email, color: Colors.white54),
          hintText: loc.enter_your_email,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontFamily: 'Instrument Sans',
            fontSize: 16,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return loc.translate('email');
          }
          if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+').hasMatch(value)) {
            return loc.translate('invalidEmail');
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
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.lock, color: Colors.white54),
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
            return loc.translate('password');
          }
          if (value.length < 8) {
            return loc.translate('passwordTooShort');
          }
          return null;
        },
      ),
    );
  }

  Widget _buildConfirmPasswordField(AppLocalizations loc) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextFormField(
        controller: _confirmPasswordController,
        obscureText: true,
        style: const TextStyle(
          fontFamily: 'Instrument Sans', 
          color: Colors.white,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '**********',
          prefixIcon: const Icon(Icons.lock, color: Colors.white54),
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontFamily: 'Instrument Sans',
            fontSize: 16,
            letterSpacing: 2,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return loc.translate('confirmPassword');
          }
          if (value != _passwordController.text) {
            return loc.translate('passwordsDoNotMatch');
          }
          return null;
        },
      ),
    );
  }
}