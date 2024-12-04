import 'package:civic_voice/components/controller/dashboard_controller.dart';
import 'package:civic_voice/dashboard/map_widget.dart';
import 'package:civic_voice/dashboard/table_widget.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedOption = 0;

  final DashboardController _controller = Get.put(DashboardController());

  final List<Map<String, dynamic>> sidebarOptions = [
    {'icon': Icons.home, 'label': 'Home'},
    {'icon': Icons.account_circle_rounded, 'label': 'User Info'},
    {'icon': Icons.settings, 'label': 'Settings'},
    {'icon': Icons.notifications, 'label': 'Notifications'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 240,
            color: Theme.of(context).colorScheme.primary,
            child: Column(
              children: [
                const SizedBox(height: 20),
                for (int i = 0; i < sidebarOptions.length; i++)
                  _sideBarButtons(i, context),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: Column(
              children: [
                // Map and Pie Chart
                Expanded(
                  flex: 4,
                  child: Row(
                    children: [
                      // Map Placeholder
                      _map(),
                      // Pie Chart
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "Summary",
                                style: Theme.of(context).textTheme.displayLarge,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: _pieChart(
                                      30,
                                      Colors.red,
                                      "Issue Pending",
                                    ),
                                  ),
                                  Expanded(
                                    child: _pieChart(
                                      60,
                                      Colors.yellow,
                                      "Issue Working on",
                                    ),
                                  ),
                                  Expanded(
                                    child: _pieChart(
                                      90,
                                      Colors.green,
                                      "Issue Resolved",
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Table
                const TableWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _map() {
    return const MapWidget();
  }

  Widget _pieChart(double value, Color color, String content) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  value: value,
                  title: '$value%',
                  color: color,
                  radius: 50,
                ),
                PieChartSectionData(
                  value: 100 - value,
                  title: '${100 - value}%',
                  color: Colors.grey,
                  radius: 50,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          content,
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
  }

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
}
