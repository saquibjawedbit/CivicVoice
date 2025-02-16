import 'package:civic_voice/components/controller/dashboard_controller.dart';
import 'package:civic_voice/components/models/user_model.dart';
import 'package:civic_voice/dashboard/components/utils/side_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key, required this.uid});
  final String uid;

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  UserModel? _userModel;
  final DashboardController _dbController = Get.find();

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  void _loadData() async {
    _userModel = await _dbController.fetchUser(widget.uid);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const SideBar(
            selectedOption: 0,
          ),
          (_userModel == null)
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.only(left: 36, right: 12, top: 24),
                  child: Column(
                    children: [
                      Text(
                        "All Complaints",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "UID: ${_userModel!.id ?? "Error loading"}",
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            "User Name: ${_userModel!.name ?? "Not Updated"}",
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            "Phone Number: ${_userModel!.phoneNumber}",
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            "Email Id: ${_userModel!.email}",
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            "Number of Complains: ${_userModel!.complaintCount}",
                            style: Theme.of(context).textTheme.displayLarge,
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
}
