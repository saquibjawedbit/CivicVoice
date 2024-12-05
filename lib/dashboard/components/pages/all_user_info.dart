import 'package:civic_voice/components/controller/dashboard_controller.dart';
import 'package:civic_voice/components/models/complain_model.dart';
import 'package:civic_voice/dashboard/components/utils/side_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllUserInfo extends StatefulWidget {
  const AllUserInfo({super.key});

  @override
  State<AllUserInfo> createState() => _AllUserInfoState();
}

class _AllUserInfoState extends State<AllUserInfo> {
  List<ComplainModel> _complainsList = [];
  final DashboardController _dashboardController = Get.find();

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  void _loadData() async {
    _complainsList =
        await _dashboardController.fetchAllComplainModel("jamshedpur");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const SideBar(),
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 24),
            child: Column(
              children: [
                Text(
                  "Users Information",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
