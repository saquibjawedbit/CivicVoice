import 'package:civic_voice/components/utils/buttons/primary_blue_button.dart';
import 'package:civic_voice/models/complain_model.dart';
import 'package:flutter/material.dart';
import 'package:civic_voice/screens/contact-us/contact_us.dart';
import 'package:get/get.dart';

class HistoryDetailScreen extends StatelessWidget {
  const HistoryDetailScreen({super.key, required this.complainModel});

  final ComplainModel complainModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Complaint Details",
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _allDetails(context),
          ),
        ),
      ),
    );
  }

  List<Widget> _allDetails(BuildContext context) {
    return [
      _userImage(),
      const SizedBox(
        height: 16,
      ),
      _status(context),
      const SizedBox(
        height: 32,
      ),
      _details(context),
      const SizedBox(
        height: 16,
      ),
      Text(
        "Created At: ${complainModel.complaintDate.toString().substring(0, 10)}",
        style: Theme.of(context).textTheme.displayMedium,
      ),
      const SizedBox(
        height: 8,
      ),
      Text(
        "Description: ${complainModel.description}",
        style: Theme.of(context).textTheme.displayMedium,
      ),
      const SizedBox(
        height: 16,
      ),
      Text(
        "Address: ${complainModel.address}",
        style: Theme.of(context).textTheme.displayMedium,
      ),
      const SizedBox(
        height: 16,
      ),
      Text(
        "Landmark: ${complainModel.landMark}",
        style: Theme.of(context).textTheme.displayMedium,
      ),
      const SizedBox(
        height: 32,
      ),
      PrimaryBlueButton(
          text: "Contact Us",
          textColor: Colors.white,
          onTap: () {
            Get.to(
              () => ContactUs(),
              transition: Transition.leftToRightWithFade,
            );
          }),
      const SizedBox(
        height: 32,
      ),
    ];
  }

  Widget _details(BuildContext context) {
    return Text(
      complainModel.title,
      style: Theme.of(context).textTheme.displayLarge,
    );
  }

  Row _status(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Status: ",
          style: Theme.of(context).textTheme.displayLarge,
        ),
        Text(
          (complainModel.status == 0)
              ? "Working on it !"
              : (complainModel.status == 2 ? "Resolved" : "Not Resolved"),
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ],
    );
  }

  SizedBox _userImage() {
    return SizedBox(
      height: 300,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          complainModel.imageUrl == ""
              ? "https://images.unsplash.com/photo-1587691592099-24045742c181?q=80&w=2073&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
              : complainModel.imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
