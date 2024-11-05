import 'package:civic_voice/components/buttons/primary_blue_button.dart';
import 'package:civic_voice/components/constants/category_complaint.dart';
import 'package:civic_voice/screens/complain/confirmation_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TitleScreen extends StatelessWidget {
  const TitleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _entryView(),
            PrimaryBlueButton(
              text: "Submit",
              textColor: Colors.white,
              bgColor: Theme.of(context).colorScheme.primary,
              onTap: () {
                Get.offAll(() => const ConfirmationScreen());
              },
            )
          ],
        ),
      ),
    );
  }

  Column _entryView() {
    return Column(
      children: [
        _titleInput(
          "Enter Header",
          "Give one word or title to your \ncomplaint",
          60,
        ),
        const SizedBox(
          height: 28,
        ),
        _titleInput(
          "Briefly Explain your Complaint",
          "0-150 Words",
          200,
        ),
        const SizedBox(
          height: 28,
        ),
        _categoryChooser(),
      ],
    );
  }

  Row _categoryChooser() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Choose a\nCategory-",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        DropdownMenu(
          leadingIcon: const Icon(Icons.search),
          width: 270,
          requestFocusOnTap: true,
          hintText: "Select a Category",
          inputDecorationTheme: InputDecorationTheme(
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.deepPurple,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.black,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.black,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          dropdownMenuEntries: [
            for (int i = 0; i < problemCategory.length; i++)
              DropdownMenuEntry(
                value: problemCategory[i],
                label: problemCategory[i],
                style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                  Color.fromARGB(117, 197, 239, 243),
                )),
              ),
          ],
        ),
      ],
    );
  }

  Column _titleInput(String title, String hintText, double height) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(
          height: 04,
        ),
        SizedBox(
          height: height,
          child: TextField(
            expands: true,
            maxLines: null,
            decoration: InputDecoration(
              hintText: hintText,
              filled: true,
              fillColor: const Color.fromARGB(
                  117, 197, 239, 243), // Gray background color
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.black, width: 2.0), // Black bottom border
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                ), // Different radii for the top corners only
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 2.0,
                ), // Black bottom border on focus
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
