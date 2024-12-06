import 'package:civic_voice/dashboard/components/utils/side_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      Get.toNamed('/auth');
      return const Placeholder();
    }

    const String data =
        "Notifications can be send to the user through here. users of the specified/selected hotspot can be selected collectively a public health alert and all the users of that area.";
    return Scaffold(
      body: Row(
        children: [
          const SideBar(selectedOption: 3),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 12, top: 24),
              child: Column(
                children: [
                  Text(
                    "Notification Manager",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: 44),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  const SizedBox(
                    width: 420,
                    child: Text(
                      data,
                      softWrap: true,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Comming Soon !",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontSize: 32),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
