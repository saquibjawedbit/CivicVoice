import 'package:civic_voice/dashboard/components/constants/sidebar_constant.dart';
import 'package:civic_voice/dashboard/components/pages/all_user_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SideBar extends StatelessWidget {
  const SideBar({
    super.key,
    required this.selectedOption,
  });

  final int selectedOption;

  GestureDetector _sideBarButtons(int i, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => const AllUserInfo());
      },
      child: Container(
        color: selectedOption == i
            ? Theme.of(context).colorScheme.secondary.withOpacity(0.2)
            : Colors.transparent,
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Icon(
              sidebarOptions[i]['icon'],
              color: Colors.white,
            ),
            const SizedBox(
              width: 2,
            ),
            Text(
              sidebarOptions[i]['label'],
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      color: Theme.of(context).colorScheme.primary,
      child: Column(
        children: [
          const SizedBox(height: 20),
          for (int i = 0; i < sidebarOptions.length; i++)
            _sideBarButtons(
              i,
              context,
            ),
        ],
      ),
    );
  }
}
