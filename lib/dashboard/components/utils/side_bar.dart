import 'package:flutter/material.dart';

class SideBar extends StatefulWidget {
  const SideBar({
    super.key,
  });

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  int _selectedOption = 0;

  final List<Map<String, dynamic>> sidebarOptions = [
    {'icon': Icons.home, 'label': 'Home'},
    {'icon': Icons.account_circle_rounded, 'label': 'User Info'},
    {'icon': Icons.settings, 'label': 'Settings'},
    {'icon': Icons.notifications, 'label': 'Notifications'},
  ];

  GestureDetector _sideBarButtons(int i, BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _selectedOption = i),
      child: Container(
        color: _selectedOption == i
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
            _sideBarButtons(i, context),
        ],
      ),
    );
  }
}
