import 'dart:io';

import 'package:camera/camera.dart';
import 'package:civic_voice/components/utils/buttons/primary_blue_button.dart';
import 'package:civic_voice/components/constants/category_complaint.dart';
import 'package:civic_voice/components/controller/db_controller.dart';
import 'package:civic_voice/components/controller/location_controller.dart';
import 'package:civic_voice/components/models/complain_model.dart';
import 'package:civic_voice/screens/complain/confirmation_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:dropdown_search/dropdown_search.dart';

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

  final LocationController _locationController = Get.find();
  final DBController _dbController = Get.find();

  bool _isLoading = false;

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
        backgroundColor: Colors.transparent,
        title: Text(
          "Civic Voice",
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        child: Stack(
          children: [
            if (_isLoading)
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.white.withOpacity(0.5),
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              ),
            SingleChildScrollView(
              child: _form(context),
            ),
          ],
        ),
      ),
    );
  }

  Column _form(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Form(
          key: _formKey,
          child: Column(
            children: [
              _textField(
                context,
                "Confirm / Edit Address",
                addressController,
                (value) {
                  if (value == null || value.isEmpty) {
                    return "Required";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 8),
              _textField(
                context,
                "Enter Nearby Landmark",
                landmarkController,
                (value) {
                  if (value == null || value.isEmpty) {
                    return "Required";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 8),
              _textField(
                context,
                "Enter Title",
                titleController,
                (value) {
                  if (value == null || value.isEmpty) {
                    return "Required";
                  } else if (value.length >= 80) {
                    return "Title should be less than 80 characters";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 8),
              _dropDownSearch(context),
              const SizedBox(height: 8),
              _textField(
                context,
                "Breifly Explain Your Comments in 10 to 100 words",
                descriptionController,
                (value) {
                  if (value == null || value.isEmpty) {
                    return "Required";
                  } else if (value.length >= 80) {
                    return "Description should be less than 300 characters";
                  }

                  return null;
                },
                length: 400,
                maxLines: 8,
              ),
              const SizedBox(height: 12),
              PrimaryBlueButton(
                text: "Next",
                textColor: Colors.white,
                bgColor: Theme.of(context).colorScheme.primary,
                onTap: _onSubmit,
              )
            ],
          ),
        )
      ],
    );
  }

  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      String? url = await _dbController.uploadImage(File(widget.image.path));

      if (url == null) {
        Get.snackbar("Something went wrong !", "Not able to upload image");
        setState(() {
          _isLoading = false;
        });
        return;
      }
      double lats = _locationController.lats;
      double longs = _locationController.longs;
      ComplainModel complainModel = ComplainModel(
        title: titleController.value.text,
        description: descriptionController.value.text,
        category: category!,
        complaintDate: Timestamp.fromDate(DateTime.now()),
        address: addressController.value.text,
        landMark: landmarkController.value.text,
        imageUrl: url,
        userId: FirebaseAuth.instance.currentUser!.uid,
        latitude: lats,
        longitude: longs,
      );

      _dbController.storeComplain(complainModel);

      Get.offAll(() => const ConfirmationScreen());
    }
  }

  Column _textField(BuildContext context, String text,
      TextEditingController controller, String? Function(String?)? validator,
      {int? maxLines, int length = 50}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 2,
        ),
        TextFormField(
          controller: controller,
          validator: validator,
          maxLength: length,
          maxLines: maxLines,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          cursorColor: Theme.of(context).colorScheme.primary,
          decoration: InputDecoration(
            // labelText: "$text*",
            counterText: "",
            hintText: text,
          ),
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _dropDownSearch(context) {
    return DropdownSearch<String>(
      validator: (value) {
        if (value == null) {
          return "Required";
        }
        return null;
      },
      popupProps: PopupProps.menu(
        fit: FlexFit.loose,
        itemBuilder: (context, item, isDisabled, isSelected) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Text(
            item,
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),
      ),
      items: (f, cs) => problemCategory,
      filterFn: (item, filter) =>
          item.toLowerCase().contains(filter.toLowerCase()), // Search logic,

      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          hintText: "Choose a Category",
          suffixIconColor:
              Theme.of(context).colorScheme.onPrimary.withOpacity(0.6),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 16,
          ),
        ),
        baseStyle: Theme.of(context).textTheme.displayMedium!.copyWith(
              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.6),
            ),
      ),
      onChanged: (String? selectedItem) {
        category = selectedItem;
      },
    );
  }
}
