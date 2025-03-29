import 'dart:io';

import 'package:camera/camera.dart';
import 'package:civic_voice/components/constants/category_complaint.dart';
import 'package:civic_voice/components/controller/complaint_controller.dart';
import 'package:civic_voice/components/controller/location_controller.dart';
import 'package:civic_voice/screens/complain/confirmation_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubmitDetailScreen extends StatefulWidget {
  const SubmitDetailScreen({super.key, required this.image});

  final XFile image;

  @override
  State<SubmitDetailScreen> createState() => _SubmitDetailScreenState();
}

class _SubmitDetailScreenState extends State<SubmitDetailScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController addressController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String? category;
  bool _isSubmitting = false;

  final LocationController _locationController = Get.find();
  final ComplaintController _complaintController = Get.find();

  @override
  void initState() {
    setState(() {
      addressController.text = _locationController.address;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 2,
        title: const Text(
          "Report Details",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      backgroundColor: Colors.grey.shade50,
      body: Stack(
        children: [
          // Form content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader("Location Information"),
                    const SizedBox(height: 16),
                    _buildInputField(
                      controller: addressController,
                      labelText: "Address",
                      hintText: "Confirm or edit your address",
                      prefixIcon: Icons.home,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Address is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      controller: landmarkController,
                      labelText: "Landmark",
                      hintText: "Enter a nearby landmark",
                      prefixIcon: Icons.location_city,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Landmark is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    _buildSectionHeader("Complaint Information"),
                    const SizedBox(height: 16),
                    _buildInputField(
                      controller: titleController,
                      labelText: "Title",
                      hintText: "Enter a title for your complaint",
                      prefixIcon: Icons.title,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Title is required";
                        } else if (value.length >= 80) {
                          return "Title should be less than 80 characters";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildCategoryDropdown(),
                    const SizedBox(height: 16),
                    _buildDescriptionField(),
                    const SizedBox(height: 32),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
          ),
          // Loading overlay
          if (_isSubmitting)
            Container(
              color: Colors.black.withOpacity(0.4),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            title == "Location Information"
                ? Icons.location_on
                : Icons.report_problem,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData prefixIcon,
    required String? Function(String?) validator,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefixIcon:
              Icon(prefixIcon, color: Theme.of(context).colorScheme.primary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 1,
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: TextFormField(
        controller: descriptionController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Description is required";
          } else if (value.length > 300) {
            return "Description should be less than 300 characters";
          }
          return null;
        },
        maxLines: 5,
        maxLength: 300,
        decoration: InputDecoration(
          labelText: "Description",
          hintText: "Briefly explain the issue (10-100 words)",
          alignLabelWithHint: true,
          counterText: "",
          prefixIcon: const Padding(
            padding: EdgeInsets.only(bottom: 80),
            child: Icon(Icons.description),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 1,
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Category is required";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: "Category",
          hintText: "Select issue category",
          prefixIcon: Icon(Icons.category,
              color: Theme.of(context).colorScheme.primary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
        items: problemCategory.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? selectedItem) {
          setState(() {
            category = selectedItem;
          });
        },
        isExpanded: true,
        icon: Icon(Icons.arrow_drop_down,
            color: Theme.of(context).colorScheme.primary),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        onPressed: _isSubmitting ? null : _onSubmit,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isSubmitting)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              )
            else
              const Text(
                "SUBMIT REPORT",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            if (!_isSubmitting) ...[
              const SizedBox(width: 8),
              const Icon(Icons.send, size: 18),
            ]
          ],
        ),
      ),
    );
  }

  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      try {
        // Store location data but don't use yet - for future implementations
        // These values will be used when submitting to a backend

        await _complaintController.postComplaint(
          title: titleController.text,
          description: descriptionController.text,
          location: addressController.text,
          landmark: landmarkController.text,
          category: category!,
          imageFile: File(widget.image.path),
          latitude: _locationController.latitude.toString(),
          longitude: _locationController.longitude.toString(),
        );

        Get.offAll(() => const ConfirmationScreen());
      } catch (e) {
        Get.snackbar(
          "Error",
          "Failed to submit report. Please try again.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
        }
      }
    }
  }
}
