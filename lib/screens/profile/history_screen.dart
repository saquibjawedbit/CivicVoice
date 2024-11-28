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
      id: '2',
      title: "Yello",
      description: "Lorem Ipsum",
      category: "Dry Waste",
      complaintDate: DateTime(2024, 2, 1),
      address: "India",
      landMark: "India",
      imageUrl: '',
    ),
    ComplainModel(
      id: '3',
      title: "Sello",
      description: "Lorem Ipsum",
      category: "Dry Waste",
      complaintDate: DateTime(2024, 2, 1),
      address: "India",
      landMark: "India",
      imageUrl: '',
    ),
  ];

  late List<ComplainModel> _filteredItems;

  @override
  void initState() {
    _filteredItems = list;
    super.initState();
  }

  String searchQuery = "";

  void _filterList(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      _filteredItems = list
          .where((item) => item.title.toLowerCase().contains(searchQuery))
          .toList();
    });
  }

  void _sortList() {
    setState(() {
      _filteredItems = _filteredItems.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    //TODO:: fetch and show history
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "History",
          style: Theme.of(context).textTheme.titleSmall,
        ),
        actions: [
          IconButton(
            onPressed: _sortList,
            icon: const Icon(
              Icons.sort,
            ),
            color: Theme.of(context).colorScheme.primary,
          )
        ],
      ),
      body: Column(
        children: [
          _searchBar(),
          _historyPage(),
        ],
      ),
    );
  }

  Expanded _historyPage() {
    return Expanded(
      child: ListView.builder(
        itemCount: _filteredItems.length,
        itemBuilder: (context, index) => _historyTille(index, context),
      ),
    );
  }

  ListTile _historyTille(int index, BuildContext context) {
    return ListTile(
      title: Text(
        _filteredItems[index].title,
        style: Theme.of(context).textTheme.labelMedium,
      ),
      subtitle: Text(
        _filteredItems[index].complaintDate.toString().substring(0, 10),
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: _filteredItems[index].status == 0
              ? const Color.fromARGB(255, 234, 211, 4)
              : (_filteredItems[index].status == 1 ? Colors.green : Colors.red),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          _filteredItems[index].status == 0
              ? "Working on it !"
              : (_filteredItems[index].status == 1
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
          complainModel: _filteredItems[index],
        ),
      ),
    );
  }

  Padding _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: _filterList,
        decoration: const InputDecoration(
          labelText: 'Search',
          prefixIcon: Icon(
            Icons.search,
          ),
        ),
      ),
    );
  }
}
