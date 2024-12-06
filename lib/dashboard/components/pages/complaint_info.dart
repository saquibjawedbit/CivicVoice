import 'package:civic_voice/components/controller/dashboard_controller.dart';
import 'package:civic_voice/components/models/complain_model.dart';
import 'package:civic_voice/components/utils/buttons/primary_blue_button.dart';
import 'package:civic_voice/dashboard/components/utils/side_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ComplaintInfo extends StatefulWidget {
  const ComplaintInfo({super.key});

  @override
  State<ComplaintInfo> createState() => _ComplaintInfoState();
}

class _ComplaintInfoState extends State<ComplaintInfo> {
  ComplainModel? _complainModel;

  final DashboardController _dashboardController = Get.find();

  late String complainId;

  @override
  void didChangeDependencies() {
    _loadData();
    super.didChangeDependencies();
  }

  void _loadData() async {
    try {
      final args = ModalRoute.of(context)!.settings.arguments as String;
      _complainModel = await _dashboardController.fetchComplain(args);
      complainId = args;
      setState(() {});
    }
    // ignore: empty_catches
    catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      Get.toNamed('/auth');
      return const Placeholder();
    }

    return Scaffold(
      body: Row(
        children: [
          const SideBar(
            selectedOption: 0,
          ),
          (_complainModel == null)
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 36, right: 12, top: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Complaint Information",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontSize: 42),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _details(context),
                              const SizedBox(
                                width: 20,
                              ),
                              const Expanded(
                                child: Icon(
                                  Icons.image,
                                  size: 600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  SizedBox _details(BuildContext context) {
    return SizedBox(
      width: 720,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "UID: ${_complainModel!.id ?? "Error loading"}",
            style: _textStyle(),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            "Title: ${_complainModel!.title}",
            style: _textStyle(),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            "Description: ${_complainModel!.description}",
            style: _textStyle(),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            "Category: ${_complainModel!.category}",
            style: _textStyle(),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            "Report Date: ${_complainModel!.complaintDate.toDate()}",
            style: _textStyle(),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            "Address: ${_complainModel!.address}",
            style: _textStyle(),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            "landmark: ${_complainModel!.landMark}",
            style: _textStyle(),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            "Status: ${(_complainModel!.status == 0) ? "Pending" : (_complainModel!.status == 1) ? "Working" : "Resolved"}",
            style: _textStyle(),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            "Admin: ${_complainModel!.adminId ?? "Not Assigned"}",
            style: _textStyle(),
          ),
          const SizedBox(
            height: 36,
          ),
          PrimaryBlueButton(
            text: "Change Status",
            textColor: Colors.white,
            onTap: () {
              _showMenu(context);
            },
          ),
        ],
      ),
    );
  }

  TextStyle _textStyle() {
    return const TextStyle(
      fontSize: 18,
      color: Colors.black,
    );
  }

  void _showMenu(context) {
    final width = MediaQuery.of(context).size.width / 2;
    final height = MediaQuery.of(context).size.height / 2;
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(width - 50, height - 50, width + 50,
          height + 50), // Adjust position if needed
      items: const [
        PopupMenuItem(
          value: 'Completed',
          child: Text('Mark as Completed'),
        ),
        PopupMenuItem(
          value: 'Pending',
          child: Text('Mark as Pending'),
        ),
        PopupMenuItem(
          value: 'Working',
          child: Text('Mark as Working'),
        ),
      ],
    ).then((value) async {
      if (value != null) {
        // Handle the selected option
        switch (value) {
          case 'Completed':
            // Add logic for marking as completed
            await _dashboardController.updateStatus(2, complainId);
            setState(() {});
            break;
          case 'Pending':
            // Add logic for marking as pending
            await _dashboardController.updateStatus(1, complainId);
            setState(() {});
            break;
          case 'Working':
            // Add logic for marking as working
            await _dashboardController.updateStatus(0, complainId);
            setState(() {});
            break;
        }
      }
    });
  }
}
