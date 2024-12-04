import 'package:civic_voice/components/controller/dashboard_controller.dart';
import 'package:civic_voice/components/models/complain_model.dart';
import 'package:civic_voice/components/utils/buttons/primary_blue_button.dart';
import 'package:civic_voice/dashboard/components/utils/side_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ComplaintInfo extends StatefulWidget {
  const ComplaintInfo({super.key, required this.complainId});

  final String complainId;
  @override
  State<ComplaintInfo> createState() => _ComplaintInfoState();
}

class _ComplaintInfoState extends State<ComplaintInfo> {
  ComplainModel? _complainModel;

  final DashboardController _dashboardController = Get.find();

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  void _loadData() async {
    _complainModel =
        await _dashboardController.fetchComplain(widget.complainId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const SideBar(),
          (_complainModel == null)
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.only(left: 36, right: 12, top: 24),
                  child: Column(
                    children: [
                      Text(
                        "User Information",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "UID: ${_complainModel!.id ?? "Error loading"}",
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            "Title: ${_complainModel!.title}",
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            "Description: ${_complainModel!.description}",
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            "Category: ${_complainModel!.category}",
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            "Report Date: ${_complainModel!.complaintDate.toDate()}",
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            "Address: ${_complainModel!.address}",
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            "landmark: ${_complainModel!.landMark}",
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            "Status: ${(_complainModel!.status == 0) ? "Pending" : (_complainModel!.status == 1) ? "Working" : "Resolved"}",
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            "Admin: ${_complainModel!.adminId ?? "Not Assigned"}",
                            style: Theme.of(context).textTheme.displayLarge,
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
                    ],
                  ),
                ),
        ],
      ),
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
            await _dashboardController.updateStatus(2, widget.complainId);
            setState(() {});
            break;
          case 'Pending':
            // Add logic for marking as pending
            await _dashboardController.updateStatus(1, widget.complainId);
            setState(() {});
            break;
          case 'Working':
            // Add logic for marking as working
            await _dashboardController.updateStatus(0, widget.complainId);
            setState(() {});
            break;
        }
      }
    });
  }
}
