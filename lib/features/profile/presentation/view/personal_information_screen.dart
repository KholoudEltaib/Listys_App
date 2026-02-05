// features/profile/presentation/view/personal_information_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:listys_app/core/helper/app_constants.dart';
import 'package:listys_app/core/localization/app_localizations.dart';
import 'package:listys_app/core/theme/app_color.dart';
import 'package:listys_app/core/di/service_locator.dart';
import 'package:listys_app/features/profile/domain/entities/user.dart';
import 'package:listys_app/features/profile/presentation/cubit/profile_cubit.dart';

class PersonalInformationScreen extends StatefulWidget {
  final User user;

  const PersonalInformationScreen({
    super.key,
    required this.user,
  });

  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState
    extends State<PersonalInformationScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  String? _imagePath;
  final ImagePicker _picker = ImagePicker();
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    
    // Listen to text changes
    _nameController.addListener(_checkForChanges);
    _emailController.addListener(_checkForChanges);
  }

  @override
  void dispose() {
    _nameController.removeListener(_checkForChanges);
    _emailController.removeListener(_checkForChanges);
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _checkForChanges() {
    final hasNameChanged = _nameController.text.trim() != widget.user.name;
    final hasEmailChanged = _emailController.text.trim() != widget.user.email;
    final hasImageChanged = _imagePath != null;

    setState(() {
      _hasChanges = hasNameChanged || hasEmailChanged || hasImageChanged;
    });
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _imagePath = image.path;
          _hasChanges = true;
        });
      }
    } on Exception catch (e) {
      if (mounted) {
        _showErrorSnackBar('Failed to pick image: ${e.toString()}');
      }
    }
  }

  void _saveChanges(BuildContext context) {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();

    // Validation
    if (name.isEmpty) {
      _showErrorSnackBar('Please enter your name');
      return;
    }

    if (email.isEmpty) {
      _showErrorSnackBar('Please enter your email');
      return;
    }

    // Email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      _showErrorSnackBar('Please enter a valid email address');
      return;
    }

    // Check if there are actually changes
    if (!_hasChanges) {
      _showInfoSnackBar('No changes to save');
      return;
    }

    // Call cubit to update profile
    context.read<ProfileCubit>().updateProfile(
          name: name,
          email: email,
          imagePath: _imagePath,
        );
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showInfoSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return BlocProvider.value(
      value: getIt<ProfileCubit>(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: BlocConsumer<ProfileCubit, ProfileState>(
            listener: (context, state) {
              if (state is ProfileUpdateSuccess) {
                _showSuccessSnackBar('Profile updated successfully');
                // Reset the changes flag
                setState(() {
                  _hasChanges = false;
                  _imagePath = null;
                });
                // Delay navigation to show success message
                Future.delayed(const Duration(milliseconds: 500), () {
                  if (mounted) {
                    Navigator.pop(context);
                  }
                });
              } else if (state is ProfileUpdateError) {
                _showErrorSnackBar(state.message);
                print('❌ Profile Update Error: ${state.message}');
              }
            },
            builder: (context, state) {
              final isLoading = state is ProfileUpdateLoading;

              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleHeader(title: loc.personal_information),
                        const SizedBox(height: 20),

                        // Profile Image
                        Center(
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.white24,
                                backgroundImage: _imagePath != null
                                    ? FileImage(File(_imagePath!))
                                        as ImageProvider
                                    : widget.user.image != null &&
                                            widget.user.image!.isNotEmpty
                                        ? NetworkImage(widget.user.image!)
                                        : null,
                                child: _imagePath == null &&
                                        (widget.user.image == null ||
                                            widget.user.image!.isEmpty)
                                    ? const Icon(
                                        Icons.person,
                                        size: 50,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: isLoading ? null : _pickImage,
                                  child: Container(
                                    height: 32,
                                    width: 32,
                                    decoration: BoxDecoration(
                                      color: isLoading 
                                          ? Colors.grey 
                                          : AppColors.primaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.camera_alt,
                                      size: 18,
                                      color: isLoading 
                                          ? Colors.white54 
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        Text(
                          loc.name,
                          style: const TextStyle(
                            color: Colors.white70, 
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _CustomTextField(
                          controller: _nameController,
                          hint: loc.enter_your_name,
                          icon: Icons.person,
                          enabled: !isLoading,
                        ),

                        const SizedBox(height: 20),

                        Text(
                          loc.email,
                          style: const TextStyle(
                            color: Colors.white70, 
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _CustomTextField(
                          controller: _emailController,
                          hint: loc.enter_your_email,
                          icon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                          enabled: !isLoading,
                        ),

                        const Spacer(),

                        // Save button
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _hasChanges && !isLoading
                                  ? AppColors.primaryColor
                                  : Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: isLoading || !_hasChanges
                                ? null
                                : () => _saveChanges(context),
                            child: isLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    loc.save_changes,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: _hasChanges 
                                          ? Colors.black 
                                          : Colors.white54,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                        
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),

                  // Loading overlay
                  if (isLoading)
                    Container(
                      color: Colors.black54,
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Updating profile...',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool enabled;
  final TextInputType? keyboardType;

  const _CustomTextField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.enabled = true,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: const Color(0x10FFFFFF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: enabled ? Colors.white24 : Colors.white10,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Icon(
            icon, 
            color: enabled ? Colors.white70 : Colors.white30,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              enabled: enabled,
              keyboardType: keyboardType,
              style: TextStyle(
                color: enabled ? Colors.white : Colors.white54,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: TextStyle(
                  color: enabled ? Colors.white54 : Colors.white30,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}

// Title Header widget (if not already defined elsewhere)
class TitleHeader extends StatelessWidget {
  final String title;

  const TitleHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}