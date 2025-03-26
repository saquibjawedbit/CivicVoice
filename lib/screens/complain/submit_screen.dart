import 'package:camera/camera.dart';
import 'package:civic_voice/components/view/image_view.dart';
import 'package:civic_voice/screens/complain/submit_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubmitScreen extends StatelessWidget {
  const SubmitScreen({super.key, required this.imageFile});

  final XFile imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.primary,
          size: 28,
        ),
        title: Text(
          "Review Image",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    // Get screen size for responsive layout
    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.height < 600;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Colors.blue.shade50,
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: isSmallScreen ? 8 : 16,
            horizontal: 24,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo with adaptive size
                  TweenAnimationBuilder(
                    duration: const Duration(milliseconds: 800),
                    tween: Tween<double>(begin: 0.8, end: 1.0),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Image.asset(
                          'assets/images/logo-1.png',
                          height: isSmallScreen
                              ? 80
                              : constraints.maxHeight *
                                  0.15, // Responsive height
                          fit: BoxFit.contain,
                        ),
                      );
                    },
                  ),

                  SizedBox(height: isSmallScreen ? 10 : 20),

                  // Header text
                  Text(
                    "Is this the issue you want to report?",
                    style: TextStyle(
                      fontSize: isSmallScreen ? 16 : 18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: isSmallScreen ? 8 : 16),

                  // Image container with flexible height
                  Expanded(
                    flex: 3,
                    child: Container(
                      constraints: BoxConstraints(
                        maxHeight: constraints.maxHeight * 0.5,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: ImageView(imageFile: imageFile),
                      ),
                    ),
                  ),

                  // Flexible spacer
                  Spacer(flex: isSmallScreen ? 1 : 2),

                  // Action buttons
                  Row(
                    children: [
                      // Retake button
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.red.shade700,
                            elevation: 2,
                            padding: EdgeInsets.symmetric(
                              vertical: isSmallScreen ? 8 : 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Colors.red.shade200),
                            ),
                          ),
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.refresh),
                          label: Text(
                            "Retake",
                            style: TextStyle(
                              fontSize: isSmallScreen ? 14 : 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Confirm button
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            foregroundColor: Colors.white,
                            elevation: 2,
                            padding: EdgeInsets.symmetric(
                              vertical: isSmallScreen ? 8 : 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Get.to(
                              () => SubmitDetailScreen(image: imageFile),
                              transition: Transition.rightToLeftWithFade,
                            );
                          },
                          icon: const Icon(Icons.check),
                          label: Text(
                            "Confirm Image",
                            style: TextStyle(
                              fontSize: isSmallScreen ? 14 : 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: isSmallScreen ? 12 : 24),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
