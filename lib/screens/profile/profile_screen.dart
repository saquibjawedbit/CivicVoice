import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        centerTitle: true,
        title: Text(
          "Edit Profile",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          _imagePicker(context),
          const SizedBox(
            height: 20,
          ),
          _textField("Username"),
          _textField("Email I'd"),
          _textField("Phone Number"),
        ],
      ),
    );
  }

  _textField(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      constraints: const BoxConstraints(maxWidth: 600),
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 2,
          ),
          TextFormField(
            cursorColor: const Color.fromARGB(255, 216, 218, 220),
            decoration: InputDecoration(
              labelText: title,
              border: _inputBorder(),
              focusedBorder: _inputBorder(),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
              floatingLabelBehavior: FloatingLabelBehavior.never,
            ),
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder _inputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Color.fromARGB(255, 216, 218, 220),
      ),
    );
  }

  Container _imagePicker(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.secondary,
      padding: const EdgeInsets.only(bottom: 8),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/images/avatar.png"),
          const SizedBox(
            height: 08,
          ),
          const Text(
            "Change Picture",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
