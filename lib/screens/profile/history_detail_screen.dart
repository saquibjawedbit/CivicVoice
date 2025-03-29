import 'package:civic_voice/components/utils/buttons/primary_blue_button.dart';
import 'package:civic_voice/models/complain_model.dart';
import 'package:flutter/material.dart';
import 'package:civic_voice/screens/contact-us/contact_us.dart';
import 'package:get/get.dart';

class HistoryDetailScreen extends StatefulWidget {
  const HistoryDetailScreen({super.key, required this.complainModel});

  final ComplainModel complainModel;

  @override
  State<HistoryDetailScreen> createState() => _HistoryDetailScreenState();
}

class _HistoryDetailScreenState extends State<HistoryDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _showStatusTimeline = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animationController.forward();

    // Show timeline after a delay for a smooth UX
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _showStatusTimeline = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive layout
    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.height < 600;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
          "Complaint Details",
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _shareComplaint,
            icon: const Icon(Icons.share, color: Colors.white),
            tooltip: "Share complaint",
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeroImageSection(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatusSection(context, isSmallScreen),
                  _buildDetailSection(context, isSmallScreen),
                  _buildLocationSection(context, isSmallScreen),
                  if (_showStatusTimeline) _buildStatusTimeline(context),
                  _buildActionsSection(context, isSmallScreen),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroImageSection(BuildContext context) {
    return Stack(
      children: [
        // Hero image
        Hero(
          tag: 'complaint_image_${widget.complainModel.title.hashCode}',
          child: SizedBox(
            height: 240,
            width: double.infinity,
            child: ShaderMask(
              shaderCallback: (rect) {
                return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black, Colors.transparent],
                ).createShader(Rect.fromLTRB(0, 180, rect.width, rect.height));
              },
              blendMode: BlendMode.dstIn,
              child: Image.network(
                widget.complainModel.imageUrl == ""
                    ? "https://images.unsplash.com/photo-1587691592099-24045742c181?q=80&w=2073&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
                    : widget.complainModel.imageUrl!,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),

        // Status overlay
        Positioned(
          top: 12,
          right: 12,
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: _animationController,
              curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
            ),
            child: _buildStatusBadge(),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge() {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (widget.complainModel.statusCode) {
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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            statusIcon,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            statusText,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSection(BuildContext context, bool isSmallScreen) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.5),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.7, curve: Curves.easeOut),
      )),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.2, 0.7, curve: Curves.easeOut),
        ),
        child: Container(
          margin: const EdgeInsets.only(top: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.complainModel.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Created on: ${widget.complainModel.complaintDate.toString().substring(0, 10)}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.tag,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Complaint ID: CMP${widget.complainModel.complaintDate.millisecondsSinceEpoch.toString().substring(5, 13)}",
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
      ),
    );
  }

  Widget _buildDetailSection(BuildContext context, bool isSmallScreen) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.5),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
      )),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
        ),
        child: Container(
          margin: const EdgeInsets.only(top: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.description,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Description",
                    style: TextStyle(
                      fontSize: isSmallScreen ? 16 : 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                widget.complainModel.description,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationSection(BuildContext context, bool isSmallScreen) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.5),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 0.9, curve: Curves.easeOut),
      )),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.4, 0.9, curve: Curves.easeOut),
        ),
        child: Container(
          margin: const EdgeInsets.only(top: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Location",
                    style: TextStyle(
                      fontSize: isSmallScreen ? 16 : 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _locationRow(
                  Icons.home_work, "Address", widget.complainModel.address),
              const SizedBox(height: 12),
              _locationRow(
                  Icons.place, "Landmark", widget.complainModel.landMark!),
              const SizedBox(height: 16),
              // Map placeholder with error handling
              Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[200],
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.blue.shade50,
                              Colors.blue.shade100,
                            ],
                          ),
                        ),
                        child: Icon(
                          Icons.map,
                          size: 40,
                          color: Colors.blue.shade300,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        alignment: Alignment.center,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            _openInMaps(widget.complainModel.latitude,
                                widget.complainModel.longitude);
                          },
                          icon: const Icon(Icons.map, color: Colors.blue),
                          label: const Text("Open in Maps",
                              style: TextStyle(color: Colors.blue)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openInMaps(double latitude, double longitude) {
    // This would be implemented to open the location in a maps app
    Get.snackbar(
      "Open Maps",
      "Maps integration will be available soon",
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(8),
      backgroundColor: Colors.black87,
      colorText: Colors.white,
    );
  }

  Widget _locationRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.grey[600], size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                softWrap: true,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusTimeline(BuildContext context) {
    return AnimatedOpacity(
      opacity: _showStatusTimeline ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 600),
      child: Container(
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.timeline,
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  "Status Timeline",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _timelineItem(
              "Submitted",
              widget.complainModel.complaintDate.toString().substring(0, 10),
              Icons.flag,
              Colors.blue,
              isFirst: true,
              isDone: true,
            ),
            _timelineItem(
              "Under Review",
              "${widget.complainModel.complaintDate.add(const Duration(days: 1)).toString().substring(0, 10)}",
              Icons.search,
              Colors.amber,
              isDone: true,
            ),
            _timelineItem(
              "In Progress",
              widget.complainModel.statusCode >= 0
                  ? "${widget.complainModel.complaintDate.add(const Duration(days: 2)).toString().substring(0, 10)}"
                  : "Pending",
              Icons.engineering,
              Colors.orange,
              isDone: widget.complainModel.statusCode >= 0,
            ),
            _timelineItem(
              "Resolved",
              widget.complainModel.statusCode == 2
                  ? "${widget.complainModel.complaintDate.add(const Duration(days: 5)).toString().substring(0, 10)}"
                  : "Pending",
              Icons.check_circle,
              Colors.green,
              isLast: true,
              isDone: widget.complainModel.statusCode == 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _timelineItem(String title, String date, IconData icon, Color color,
      {bool isFirst = false, bool isLast = false, bool isDone = false}) {
    return Row(
      children: [
        Column(
          children: [
            // Top connector
            if (!isFirst)
              Container(
                width: 2,
                height: 20,
                color: isDone ? color : Colors.grey[300],
              ),

            // Circle indicator
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDone ? color : Colors.grey[300],
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 16,
              ),
            ),

            // Bottom connector
            if (!isLast)
              Container(
                width: 2,
                height: 20,
                color: !isDone ? Colors.grey[300] : color,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(bottom: isLast ? 0 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDone ? color : Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDone ? Colors.black87 : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionsSection(BuildContext context, bool isSmallScreen) {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryBlueButton(
            text: "Contact Support",
            textColor: Colors.white,
            onTap: () {
              Get.to(
                () => const ContactUs(),
                transition: Transition.rightToLeftWithFade,
              );
            },
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: BorderSide(color: Theme.of(context).colorScheme.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: _reportIssue,
            icon:
                Icon(Icons.flag, color: Theme.of(context).colorScheme.primary),
            label: Text(
              "Report a Problem with this Complaint",
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  void _shareComplaint() {
    // Share functionality would be implemented here
    Get.snackbar(
      "Share",
      "Sharing functionality will be implemented soon",
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(8),
      backgroundColor: Colors.black87,
      colorText: Colors.white,
    );
  }

  void _reportIssue() {
    // Report issue functionality would be implemented here
    Get.snackbar(
      "Report",
      "Issue reporting functionality will be implemented soon",
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(8),
      backgroundColor: Colors.black87,
      colorText: Colors.white,
    );
  }
}
