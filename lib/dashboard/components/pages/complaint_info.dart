import 'package:civic_voice/components/models/complain_model.dart';
import 'package:civic_voice/dashboard/components/utils/side_bar.dart';
import 'package:flutter/material.dart';

class ComplaintInfo extends StatefulWidget {
  const ComplaintInfo({super.key, required this.complainId});

  final String complainId;
  @override
  State<ComplaintInfo> createState() => _ComplaintInfoState();
}

class _ComplaintInfoState extends State<ComplaintInfo> {
  ComplainModel? _complainModel;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  void _loadData() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const SideBar(),
          (_complainModel == null)
              ? const Center(child: CircularProgressIndicator())
              : const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [],
                ),
        ],
      ),
    );
  }
}
