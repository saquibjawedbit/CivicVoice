import 'package:civic_voice/models/query_model.dart';
import 'package:civic_voice/components/utils/buttons/primary_blue_button.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactUs extends StatelessWidget {
  ContactUs({super.key});

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Contact Us",
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: _body(context),
      ),
    );
  }

  Column _body(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 12,
        ),
        Text(
          "Civic Voice",
          style: Theme.of(context).textTheme.displayLarge,
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          "At Civic Voice, we're here to ensure your voice is heard. Contact us anytime for support or assistance!",
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const SizedBox(
          height: 18,
        ),
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: "Title",
                ),
                maxLength: 50,
                validator: (value) {
                  if (value == null || value == '') {
                    return "Required";
                  }

                  return null;
                },
              ),
              const SizedBox(
                height: 2,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  hintText: "Description",
                ),
                maxLength: 300,
                maxLines: 5,
                validator: (value) {
                  if (value == null || value == '') {
                    return "Required";
                  }

                  return null;
                },
              ),
              const SizedBox(
                height: 2,
              ),
              PrimaryBlueButton(
                text: "Submit",
                textColor: Colors.white,
                onTap: _onSubmit,
              )
            ],
          ),
        ),
      ],
    );
  }

  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      Get.back();
      Get.snackbar("Success!", "Your Feedback is sent, Thank You!");
    }
  }
}
