import 'package:civic_voice/components/controller/dashboard_controller.dart';
import 'package:civic_voice/dashboard/components/utils/map_widget.dart';
import 'package:civic_voice/dashboard/components/utils/side_bar.dart';
import 'package:civic_voice/dashboard/components/utils/table_widget.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DashboardController _controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          const SideBar(),
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
                              Obx(() {
                                return Row(
                                  children: [
                                    Expanded(
                                      child: _pieChart(
                                        _controller.pending.value,
                                        Colors.red,
                                        "Issue Pending",
                                      ),
                                    ),
                                    Expanded(
                                      child: _pieChart(
                                        _controller.working.value,
                                        Colors.yellow,
                                        "Issue Working on",
                                      ),
                                    ),
                                    Expanded(
                                      child: _pieChart(
                                        _controller.resolved.value,
                                        Colors.green,
                                        "Issue Resolved",
                                      ),
                                    ),
                                  ],
                                );
                              }),
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
}
