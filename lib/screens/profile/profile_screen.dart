import 'dart:io';
import 'dart:ui';

import 'package:civic_voice/components/controller/authentication_controller.dart';
import 'package:civic_voice/components/utils/buttons/primary_blue_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  bool _isUploading = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // Get the authentication controller
  final AuthenticationController _authController =
      Get.find<AuthenticationController>();

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();

    loadData();
  }

  void loadData() async {
    // Default values in case no user data is available
    _phoneController.text = "";
    _emailController.text = "";
    _nameController.text = "";

    // Check if we have user data
    if (_authController.user.value == null) {
      // Try to fetch user data if we don't have it yet
      await _authController.getUserData();
    }

    // Update fields with user data if available
    if (_authController.user.value != null) {
      try {
        final userData = _authController.user.value!;
        setState(() {
          _emailController.text = userData['email'] ?? "";
          _nameController.text = userData['name'] ?? "";
          _phoneController.text = userData['phone'] ?? "";
        });
      } catch (e) {
        debugPrint('Error loading user data: $e');
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    Navigator.of(context).pop();
    try {
      setState(() {
        _isUploading = true;
      });

      final XFile? pickedImage = await _picker.pickImage(source: source);

      if (pickedImage != null) {
        setState(() {
          _image = pickedImage;
        });
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(25)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: 50,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          "Select Photo",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildImageSourceOption(
                              icon: Icons.camera_alt,
                              label: "Camera",
                              onTap: () => _pickImage(ImageSource.camera),
                            ),
                            _buildImageSourceOption(
                              icon: Icons.image,
                              label: "Gallery",
                              onTap: () => _pickImage(ImageSource.gallery),
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
        );
      },
    );
  }

  Widget _buildImageSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              icon,
              size: 30,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          TextButton(
            onPressed: () => _showLogoutConfirmation(),
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
      body: Obx(() {
        // Show loading indicator while fetching user data
        if (_authController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return FadeTransition(
              opacity: _animation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildProfileImage(),
                    const SizedBox(height: 24),
                    _buildInputField(
                      label: 'Full Name',
                      controller: _nameController,
                      icon: Icons.person,
                      enabled: false,
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      label: 'Email',
                      controller: _emailController,
                      icon: Icons.email,
                      enabled: false,
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      label: 'Phone Number',
                      controller: _phoneController,
                      icon: Icons.phone,
                      enabled: false,
                    ),
                    const SizedBox(height: 40),
                    PrimaryBlueButton(
                      text: 'Update Profile',
                      textColor: Colors.white,
                      bgColor: Theme.of(context).primaryColor,
                      onTap: () {
                        // Profile update logic would go here
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Profile update functionality coming soon'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildProfileImage() {
    return Stack(
      children: [
        SizedBox(
          width: 120,
          height: 120,
          child: _isUploading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _image != null
                      ? FileImage(File(_image!.path))
                      : _authController.user.value != null &&
                              _authController.user.value!['profilePicture'] !=
                                  null
                          ? NetworkImage(_authController
                              .user.value!['profilePicture'] as String)
                          : const AssetImage('assets/images/avatar.png')
                              as ImageProvider,
                ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: InkWell(
            onTap: _showImageSourceActionSheet,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool enabled = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        style: TextStyle(
          color: enabled ? Colors.black : Colors.grey[700],
        ),
      ),
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _authController.logout();
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
