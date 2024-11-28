import 'package:civic_voice/components/buttons/primary_blue_button.dart';
import 'package:civic_voice/components/models/complain_model.dart';
import 'package:flutter/material.dart';

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _allDetails(context),
        ),
      ),
    );
  }

  List<Widget> _allDetails(BuildContext context) {
    return [
      _userImage(),
      const SizedBox(
        height: 8,
      ),
      _status(context),
      const SizedBox(
        height: 8,
      ),
      _details(context),
      Text(
        complainModel.description,
        style: Theme.of(context).textTheme.displayMedium,
      ),
      Text(
        "Address: ${complainModel.address}",
        style: Theme.of(context).textTheme.displayMedium,
      ),
      Text(
        "Landmark: ${complainModel.address}",
        style: Theme.of(context).textTheme.displayMedium,
      ),
      const SizedBox(
        height: 16,
      ),
      PrimaryBlueButton(
          text: "Contact Us", textColor: Colors.white, onTap: () {}),
    ];
  }

  Row _details(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          complainModel.title,
          style: Theme.of(context).textTheme.displayLarge,
        ),
        Text(
          complainModel.complaintDate.toString().substring(0, 10),
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ],
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
              : (complainModel.status == 1 ? "Resolved" : "Not Resolved"),
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ],
    );
  }

  SizedBox _userImage() {
    return SizedBox(
      height: 300,
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
