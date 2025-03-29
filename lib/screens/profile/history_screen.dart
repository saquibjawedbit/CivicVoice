import 'package:civic_voice/models/complain_model.dart';
import 'package:civic_voice/screens/profile/history_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting
import 'package:civic_voice/components/controller/complaint_controller.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with TickerProviderStateMixin {
  List<ComplainModel> list = [];

  late List<ComplainModel> _filteredItems = []; // Initialize with empty list
  late AnimationController _fadeController;
  late AnimationController _slideController;
  bool _isSortedAscending = true;
  String _filterStatus = "All";

  // Add ComplaintController instance
  final ComplaintController _complaintController =
      Get.put(ComplaintController());

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeController.forward();
    _slideController.forward();

    _loadData();
    super.initState();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _loadData() async {
    // Use the complaint controller to fetch real data
    await _complaintController.fetchUserComplaints();

    setState(() {
      // Convert Map<String, dynamic> to ComplainModel objects
      list = _complaintController.complaints.map((complaintMap) {
        return ComplainModel.fromMap(complaintMap, complaintMap['id']);
      }).toList();

      _filteredItems = list;
    });
  }

  String searchQuery = "";

  void _filterList() {
    setState(() {
      searchQuery = _searchController.text.toLowerCase();

      _filteredItems = list.where((item) {
        // First filter by search text
        final matchesSearch = item.title.toLowerCase().contains(searchQuery);

        // Then filter by status if not "All"
        final matchesStatus = _filterStatus == "All" ||
            (_filterStatus == "Working" && item.statusCode == 0) ||
            (_filterStatus == "Resolved" && item.statusCode == 2) ||
            (_filterStatus == "Not Resolved" && item.statusCode == 1);

        return matchesSearch && matchesStatus;
      }).toList();

      // Sort the list if needed
      _sortList(fromFilter: true);
    });
  }

  void _sortList({bool fromFilter = false}) {
    if (!fromFilter) {
      setState(() {
        _isSortedAscending = !_isSortedAscending;
      });
    }

    setState(() {
      _filteredItems.sort((a, b) {
        if (_isSortedAscending) {
          return a.complaintDate.compareTo(b.complaintDate);
        } else {
          return b.complaintDate.compareTo(a.complaintDate);
        }
      });
    });
  }

  void _filterByStatus(String status) {
    setState(() {
      _filterStatus = status;
      _filterList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
          "Complaint History",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _loadData(), // Add refresh functionality
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            tooltip: 'Refresh complaints',
          ),
          IconButton(
            onPressed: () => _sortList(),
            icon: Icon(
              _isSortedAscending
                  ? Icons.sort_by_alpha
                  : Icons.sort_by_alpha_outlined,
              color: Colors.white,
            ),
            tooltip: _isSortedAscending
                ? 'Sort newest to oldest'
                : 'Sort oldest to newest',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _complaintController.fetchUserComplaints();
          _loadData();
        },
        color: Theme.of(context).colorScheme.primary,
        child: Column(
          children: [
            _buildSearchContainer(),
            _buildFilterChips(),
            _buildHistoryList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.filter_list, color: Colors.white),
        onPressed: _showFilterOptions,
      ),
    );
  }

  Widget _buildSearchContainer() {
    return FadeTransition(
      opacity: _fadeController,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          onChanged: (value) => _filterList(),
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withOpacity(0.2),
            hintText: 'Search complaints...',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
            prefixIcon: const Icon(Icons.search, color: Colors.white),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.white),
                    onPressed: () {
                      _searchController.clear();
                      _filterList();
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, -0.5),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _slideController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
      )),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterChip("All", Icons.list),
              const SizedBox(width: 12),
              _buildFilterChip("Working", Icons.pending_actions,
                  color: Colors.orange),
              const SizedBox(width: 12),
              _buildFilterChip("Resolved", Icons.check_circle,
                  color: Colors.green),
              const SizedBox(width: 12),
              _buildFilterChip("Not Resolved", Icons.cancel, color: Colors.red),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, IconData icon, {Color? color}) {
    final isSelected = _filterStatus == label;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: isSelected
            ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
            : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.grey.shade300,
          width: 1.5,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  blurRadius: 4,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: InkWell(
        onTap: () => _filterByStatus(label),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: color ?? Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryList() {
    // Show loading indicator when fetching complaints
    if (_complaintController.isLoading.value) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                "Loading complaints...",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (list.isEmpty) {
      return Expanded(
        child: FadeTransition(
          opacity: _fadeController,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.history,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  "No complaints yet",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Your submitted complaints will appear here",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_filteredItems.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: 80,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                "No matching complaints found",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Try adjusting your search or filters",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80), // Add padding for FAB
        physics: const BouncingScrollPhysics(),
        itemCount: _filteredItems.length,
        itemBuilder: (context, index) {
          final animation = Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: _slideController,
            curve: Interval(
              0.4 + (index * 0.1).clamp(0.0, 0.6),
              0.7 + (index * 0.1).clamp(0.0, 0.9),
              curve: Curves.easeOut,
            ),
          ));

          return SlideTransition(
            position: animation,
            child: _historyCard(index, context),
          );
        },
      ),
    );
  }

  Widget _historyCard(int index, BuildContext context) {
    final complaint = _filteredItems[index];

    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (complaint.statusCode) {
      case 0:
        statusColor = Colors.orange;
        statusText = "Working on it!";
        statusIcon = Icons.pending_actions;
        break;
      case 2:
        statusColor = Colors.green;
        statusText = "Resolved";
        statusIcon = Icons.check_circle;
        break;
      default:
        statusColor = Colors.red;
        statusText = "Not Resolved";
        statusIcon = Icons.cancel;
    }

    // Improved date formatting
    final DateFormat formatter = DateFormat('MMM dd, yyyy');
    final String formattedDate = formatter.format(complaint.complaintDate);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => Get.to(
          () => HistoryDetailScreen(complainModel: complaint),
          transition: Transition.rightToLeftWithFade,
        ),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left side status column
                  Container(
                    width: 70,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            statusIcon,
                            color: statusColor,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            statusText,
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Vertical divider
                  Container(
                    height: 80,
                    width: 1,
                    color: Colors.grey.shade200,
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                  ),

                  // Right side content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          complaint.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        // Improved address layout with better overflow handling
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                complaint.address,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              formattedDate,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                ),
                onPressed: () => Get.to(
                  () => HistoryDetailScreen(complainModel: complaint),
                  transition: Transition.rightToLeftWithFade,
                ),
                child: Text(
                  "View Details",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Filter & Sort",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Status",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _filterOptionButton("All", () {
                    _filterByStatus("All");
                    Navigator.pop(context);
                  }, isSelected: _filterStatus == "All"),
                  _filterOptionButton("Working", () {
                    _filterByStatus("Working");
                    Navigator.pop(context);
                  },
                      color: Colors.orange,
                      isSelected: _filterStatus == "Working"),
                  _filterOptionButton("Resolved", () {
                    _filterByStatus("Resolved");
                    Navigator.pop(context);
                  },
                      color: Colors.green,
                      isSelected: _filterStatus == "Resolved"),
                  _filterOptionButton("Not Resolved", () {
                    _filterByStatus("Not Resolved");
                    Navigator.pop(context);
                  },
                      color: Colors.red,
                      isSelected: _filterStatus == "Not Resolved"),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Sort By",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _filterOptionButton("Newest First", () {
                    setState(() => _isSortedAscending = false);
                    _sortList();
                    Navigator.pop(context);
                  }, isSelected: !_isSortedAscending),
                  _filterOptionButton("Oldest First", () {
                    setState(() => _isSortedAscending = true);
                    _sortList();
                    Navigator.pop(context);
                  }, isSelected: _isSortedAscending),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _filterOptionButton(String text, VoidCallback onTap,
      {Color? color, bool isSelected = false}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? (color ?? Theme.of(context).colorScheme.primary)
              : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? (color ?? Theme.of(context).colorScheme.primary)
                : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : (color ?? Colors.black87),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
