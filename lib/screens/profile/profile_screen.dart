import 'dart:io';

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

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
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
    _phoneController.text = "+91 1234567890";
    _emailController.text = "user@example.com";
    _nameController.text = "John Doe";
    // UserModel? user =

    // if (user == null) {
    //   await _dbController.getUser();
    //   user = _dbController.user;
    // }

    // try {
    //   _emailController.text = user!.email;
    //   _nameController.text = user.name ?? "";
    // } catch (e) {
    //   debugPrint(e.toString());
    // }
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Take a photo'),
                onTap: () => _pickImage(ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () => _pickImage(ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );
  }

  final _formKey = GlobalKey<FormState>();

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      // Show loading indicator
      setState(() {
        _isUploading = true;
      });

      // Simulate network delay
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _isUploading = false;
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        Get.back();
      });
    }
  }

  bool _isValidEmail(String value) {
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(value);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Stack(
        children: [
          FadeTransition(
            opacity: _animation,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _profileHeader(context),
                    const SizedBox(height: 16),
                    Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 12, bottom: 8),
                              child: Text(
                                "Personal Information",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            _textField(
                              "Username",
                              context,
                              _nameController,
                              (value) {
                                if (value == null || value.isEmpty) {
                                  return "Username is required";
                                }
                                return null;
                              },
                              icon: Icons.person,
                            ),
                            _textField(
                              "Email Address",
                              context,
                              _emailController,
                              (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    !_isValidEmail(value)) {
                                  return "Please enter a valid email address";
                                }
                                return null;
                              },
                              icon: Icons.email,
                            ),
                            _textField(
                              "Phone Number",
                              context,
                              _phoneController,
                              (value) {
                                return null;
                              },
                              isEnabled: false,
                              icon: Icons.phone,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        width: double.infinity,
                        child: PrimaryBlueButton(
                          text: "Save Changes",
                          textColor: Colors.white,
                          onTap: _onSubmit,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
          if (_isUploading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _textField(String title, BuildContext context,
      TextEditingController controller, String? Function(String?)? validator,
      {bool isEnabled = true, IconData? icon}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        enabled: isEnabled,
        controller: controller,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          prefixIcon: icon != null
              ? Icon(icon, color: Theme.of(context).colorScheme.primary)
              : null,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          labelText: title,
          labelStyle: TextStyle(color: Colors.grey[600]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          filled: true,
          fillColor: isEnabled ? Colors.white : Colors.grey[100],
        ),
        validator: validator,
      ),
    );
  }

  Widget _profileHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.only(bottom: 30),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  backgroundImage: _image != null
                      ? FileImage(File(_image!.path))
                      : const AssetImage('assets/images/avatar.png')
                          as ImageProvider,
                ),
              ),
              Positioned(
                right: 0,
                bottom: 5,
                child: GestureDetector(
                  onTap: _showImageSourceActionSheet,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 20,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _nameController.text,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _emailController.text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
