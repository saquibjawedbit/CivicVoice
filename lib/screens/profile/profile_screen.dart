import 'dart:io';

import 'package:civic_voice/components/utils/buttons/primary_blue_button.dart';
import 'package:civic_voice/components/controller/db_controller.dart';
import 'package:civic_voice/components/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    loadData();
    super.initState();
  }

  void loadData() async {
    _phoneController.text =
        FirebaseAuth.instance.currentUser!.phoneNumber.toString();

    UserModel? user = _dbController.user;

    if (user == null) {
      await _dbController.getUser();
      user = _dbController.user;
    }

    try {
      _emailController.text = user!.email ?? "";
      _nameController.text = user.name ?? "";
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedImage;
    });
  }

  final DBController _dbController = Get.find();
  final _formKey = GlobalKey<FormState>();

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      String phoneNumber =
          FirebaseAuth.instance.currentUser!.phoneNumber.toString();
      String name = _nameController.text.toString();
      String emailId = _emailController.text.toString();
      UserModel user =
          UserModel(phoneNumber: phoneNumber, email: emailId, name: name);
      _dbController.updateUser(user);
      Get.back();
    }
  }

  bool _isValidEmail(String value) {
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            _imagePicker(context),
            const SizedBox(
              height: 20,
            ),
            _textField(
              "Username",
              context,
              _nameController,
              (value) {
                if (value == null || value.isEmpty) {
                  return "Required";
                }

                return null;
              },
            ),
            _textField(
              "Email I'd",
              context,
              _emailController,
              (value) {
                if (value == null || value.isEmpty || !_isValidEmail(value)) {
                  return "Invalid Email Address";
                }

                return null;
              },
            ),
            _textField("Phone Number", context, _phoneController, (value) {
              return null;
            }, isEnabled: false),
            const SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: PrimaryBlueButton(
                text: "Update",
                textColor: Colors.white,
                onTap: _onSubmit,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textField(String title, BuildContext context,
      TextEditingController controller, String? Function(String?)? validator,
      {bool isEnabled = true}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      constraints: const BoxConstraints(maxWidth: 600),
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const SizedBox(
            height: 2,
          ),
          TextFormField(
            enabled: isEnabled,
            controller: controller,
            decoration: InputDecoration(
              labelText: title,
              floatingLabelBehavior: FloatingLabelBehavior.never,
            ),
            validator: validator,
          ),
        ],
      ),
    );
  }

  Container _imagePicker(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.primary,
      padding: const EdgeInsets.only(bottom: 8),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50, // You can adjust this based on your requirement
            backgroundImage: _image != null
                ? FileImage(File(_image!.path))
                : null, // If no image is selected, the background is transparent.
            child: _image == null
                ? const Icon(Icons.add_a_photo,
                    size: 50) // Placeholder icon if no image is selected.
                : null, // Avoid showing the icon when an image is picked.
          ),
          const SizedBox(
            height: 08,
          ),
          InkWell(
            onTap: _pickImage,
            child: const Text(
              "Change Picture",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
