import 'package:camera/camera.dart';
import 'package:civic_voice/components/buttons/primary_blue_button.dart';
import 'package:civic_voice/components/constants/category_complaint.dart';
import 'package:civic_voice/screens/complain/confirmation_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dropdown_search/dropdown_search.dart';

class SubmitDetailScreen extends StatelessWidget {
  const SubmitDetailScreen({super.key, required this.image});

  final XFile image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Civic Voice",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ImageView(imageFile: image),
              const SizedBox(
                height: 20,
              ),
              Form(
                child: Column(
                  children: [
                    _textField(context, "Confirm / Edit Address"),
                    const SizedBox(height: 8),
                    _textField(context, "Enter Nearby Landmark"),
                    const SizedBox(height: 8),
                    _textField(context, "Enter Title"),
                    const SizedBox(height: 8),
                    _dropDownSearch(context),
                    const SizedBox(height: 8),
                    _textField(context, "Breifly Explain Your Comments",
                        length: 400, maxLines: 8),
                    const SizedBox(height: 12),
                    PrimaryBlueButton(
                        text: "Next",
                        textColor: Colors.white,
                        bgColor: Theme.of(context).colorScheme.primary,
                        onTap: () {
                          Get.to(() => const ConfirmationScreen());
                        })
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Column _textField(BuildContext context, String text,
      {int? maxLines, int length = 50}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 2,
        ),
        TextFormField(
          maxLength: length,
          maxLines: maxLines,
          cursorColor: Theme.of(context).colorScheme.primary,
          keyboardType: const TextInputType.numberWithOptions(),
          decoration: InputDecoration(
            // labelText: "$text*",
            counterText: "",
            hintText: "$text*",
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.6),
            ),
            border: _inputBorder(context, 1.2),
            focusedBorder: _inputBorder(context, 1.6),
            enabledBorder: _inputBorder(context, 1.2),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 18,
              horizontal: 16,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _inputBorder(context, double width) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.primary,
        width: width,
      ),
    );
  }

  Widget _dropDownSearch(context) {
    return DropdownSearch<String>(
      popupProps: PopupProps.menu(
        fit: FlexFit.loose,
        itemBuilder: (context, item, isDisabled, isSelected) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Text(
            item,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
            ),
          ),
        ),
      ),
      items: (f, cs) => problemCategory,
      filterFn: (item, filter) =>
          item.toLowerCase().contains(filter.toLowerCase()), // Search logic,

      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          border: _inputBorder(
            context,
            1.2,
          ),
          enabledBorder: _inputBorder(
            context,
            1.2,
          ),
          hintText: "Choose a Category",
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.6),
          ),
          suffixIconColor:
              Theme.of(context).colorScheme.onPrimary.withOpacity(0.6),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 16,
          ),
        ),
        baseStyle: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 16,
        ),
      ),
      onChanged: (String? selectedItem) {
        print('Selected item: $selectedItem');
      },
    );
  }
}
