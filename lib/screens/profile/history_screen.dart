import 'package:civic_voice/components/models/complain_model.dart';
import 'package:civic_voice/screens/profile/history_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final List<ComplainModel> list = [
    ComplainModel(
      id: '1',
      title: "Hello",
      description: "Lorem Ipsum",
      category: "Dry Waste",
      complaintDate: DateTime(2024, 2, 1),
      address: "India",
      landMark: "India",
      imageUrl: '',
    ),
    ComplainModel(
      id: '1',
      title: "Hello",
      description: "Lorem Ipsum",
      category: "Dry Waste",
      complaintDate: DateTime(2024, 2, 1),
      address: "India",
      landMark: "India",
      imageUrl: '',
    ),
    ComplainModel(
      id: '1',
      title: "Hello",
      description: "Lorem Ipsum",
      category: "Dry Waste",
      complaintDate: DateTime(2024, 2, 1),
      address: "India",
      landMark: "India",
      imageUrl: '',
    ),
  ];

  String searchQuery = "";

  void _filterList(String query) {
    // setState(() {
    //   searchQuery = query.toLowerCase();
    //   filteredItems = items
    //       .where((item) => item.toLowerCase().contains(searchQuery))
    //       .toList();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "History",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filterList,
              decoration: InputDecoration(
                labelText: 'Search',
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                ),
                prefixIconColor: Theme.of(context).colorScheme.primary,
                border: _inputBorder(context, 1.2),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(
                  list[index].title,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                subtitle: Text(
                  list[index].complaintDate.toString().substring(0, 10),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                trailing: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: list[index].status == 0
                        ? const Color.fromARGB(255, 234, 211, 4)
                        : (list[index].status == 1 ? Colors.green : Colors.red),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    list[index].status == 0
                        ? "Working on it !"
                        : (list[index].status == 1
                            ? "Resolved"
                            : "Not Resolved"),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                onTap: () => Get.to(
                  () => HistoryDetailScreen(
                    complainModel: list[index],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder _inputBorder(context, double width) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.primary,
        width: width,
      ),
    );
  }
}
