import 'package:civic_voice/components/models/complain_model.dart';
import 'package:flutter/material.dart';

class HistoryDetailScreen extends StatelessWidget {
  const HistoryDetailScreen({super.key, required this.complainModel});

  final ComplainModel complainModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Complaint Details",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 300,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  complainModel.imageUrl == ""
                      ? "https://images.unsplash.com/photo-1587691592099-24045742c181?q=80&w=2073&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
                      : complainModel.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    (complainModel.status == 0)
                        ? "Working on it !"
                        : (complainModel.status == 1
                            ? "Resolved"
                            : "Not Resolved"),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    (complainModel.resolvedDate == null)
                        ? DateTime.now().toString().substring(0, 10)
                        : complainModel.complaintDate
                            .toString()
                            .substring(0, 10),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  complainModel.title,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  complainModel.complaintDate.toString().substring(0, 10),
                  style: _textStyle(context),
                ),
              ],
            ),
            Text(
              complainModel.description,
              style: _textStyle(context),
            ),
            Text(
              "Address: ${complainModel.address}",
              style: _textStyle(context),
            ),
            Text(
              "Landmark: ${complainModel.address}",
              style: _textStyle(context),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _textStyle(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.onPrimary,
      fontSize: 18,
    );
  }
}
