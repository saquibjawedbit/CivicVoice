import 'package:civic_voice/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmationScreen extends StatefulWidget {
  const ConfirmationScreen({super.key});

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Success animation
                    ScaleTransition(
                      scale: CurvedAnimation(
                        parent: _animationController,
                        curve: Curves.elasticOut,
                      ),
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.green.shade600,
                          size: 80,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Success message with animation
                    FadeTransition(
                      opacity: CurvedAnimation(
                        parent: _animationController,
                        curve: const Interval(0.5, 1.0),
                      ),
                      child: _buildSuccessContent(),
                    ),

                    const SizedBox(height: 40),

                    // Next steps info card
                    FadeTransition(
                      opacity: CurvedAnimation(
                        parent: _animationController,
                        curve: const Interval(0.7, 1.0),
                      ),
                      child: _buildNextStepsCard(context),
                    ),
                  ],
                ),
              ),

              // Button section
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Get.offAll(
                        () => const HomeScreen(),
                        transition: Transition.fade,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.home),
                          SizedBox(width: 10),
                          Text(
                            "RETURN TO HOME",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      // Go to history/track complaints screen
                      // This can be implemented later
                      Get.snackbar(
                        "Coming Soon",
                        "Track your complaint feature will be available soon!",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.grey.shade800,
                        colorText: Colors.white,
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history,
                          size: 18,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Track your complaint",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
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

  Widget _buildSuccessContent() {
    return const Column(
      children: [
        Text(
          "Thank You!",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 16),
        Text(
          "Your complaint has been successfully submitted",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            color: Colors.black54,
          ),
        ),
        SizedBox(height: 8),
        Text(
          "We will notify you once there's an update",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildNextStepsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 10),
              Text(
                "What happens next?",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildProcessStep(
            icon: Icons.description,
            text: "Our team will review your complaint",
            isFirst: true,
          ),
          _buildProcessStep(
            icon: Icons.assignment_turned_in,
            text: "The issue will be assigned to relevant department",
          ),
          _buildProcessStep(
            icon: Icons.notifications_active,
            text: "You'll receive updates on the status of your complaint",
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildProcessStep({
    required IconData icon,
    required String text,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 18,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 30,
                color: Theme.of(context).colorScheme.primary,
              ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: isLast ? 0 : 16),
            ],
          ),
        ),
      ],
    );
  }
}
