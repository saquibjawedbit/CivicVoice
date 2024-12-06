import 'package:civic_voice/components/controller/dashboard_controller.dart';
import 'package:civic_voice/components/models/user_model.dart';
import 'package:civic_voice/dashboard/components/utils/side_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final DashboardController dbController = DashboardController();

  @override
  void initState() {
    _loadUser();
    super.initState();
  }

  void _loadUser() async {
    if (FirebaseAuth.instance.currentUser == null) {
      Get.offNamed('/auth');
    }

    if (dbController.userModel == null) {
      bool isAdmin = await dbController
          .isAdmin(FirebaseAuth.instance.currentUser!.phoneNumber.toString());
      if (!isAdmin) Get.offAllNamed('/auth');
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    UserModel? userModel = dbController.userModel;
    return Scaffold(
      body: Row(
        children: [
          const SideBar(selectedOption: 2),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 12, top: 12),
              child: (userModel == null)
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Admin Information",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontSize: 42),
                        ),
                        const SizedBox(
                          height: 120,
                        ),
                        Text(
                          "name: ${dbController.userModel!.name!}",
                          style: _textStyle(),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          "phoneNumber: ${dbController.userModel!.phoneNumber}",
                          style: _textStyle(),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          "id: ${dbController.userModel!.id!}",
                          style: _textStyle(),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _textStyle() {
    return const TextStyle(
      fontSize: 24,
      color: Colors.black,
    );
  }
}
