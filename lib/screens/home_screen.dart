import 'package:camera/camera.dart';
import 'package:civic_voice/components/controller/location_controller.dart';
import 'package:civic_voice/screens/complain/submit_screen.dart';
import 'package:civic_voice/screens/profile/history_screen.dart';
import 'package:civic_voice/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CameraController? _cameraController;
  late List<CameraDescription> cameras;
  XFile? imageFile;

  final LocationController _locationController = Get.put(LocationController());

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    _cameraController = CameraController(
      cameras[0],
      ResolutionPreset.high,
    );
    await _cameraController!.initialize();
    _locationController.requestPermission();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _captureImage() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      try {
        // Capture the image and save it as a file
        imageFile = await _cameraController!.takePicture();
        _locationController.requestAddress();
        if (imageFile != null) {
          Get.to(
            () => SubmitScreen(imageFile: imageFile!),
            transition: Transition.fadeIn,
          );
        }
      } catch (e) {
        debugPrint("Error capturing image: $e");
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _appBar(),
      body: Stack(
        children: [
          SizedBox.expand(child: CameraPreview(_cameraController!)),
          _captureButton()
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      centerTitle: true,
      // backgroundColor: Colors.transparent,
      backgroundColor:
          Theme.of(context).colorScheme.primary, // Semi-transparent bar
      toolbarHeight: 84,
      title: const Text(
        "CIVIC VOICE",
        style: TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
      leadingWidth: 72,
      leading: IconButton(
        onPressed: () {
          Get.to(
            () => const HistoryScreen(),
            transition: Transition.leftToRight,
          );
        },
        icon: const Icon(
          Icons.menu,
          size: 36,
          color: Colors.white,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Get.to(
              () => const ProfileScreen(),
              transition: Transition.rightToLeft,
            );
          },
          icon: const Icon(
            Icons.account_circle_sharp,
            color: Colors.white,
            size: 42,
          ),
        ),
      ],
    );
  }

  Align _captureButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: InkWell(
          onTap: _captureImage,
          child: Opacity(
            opacity: 0.4,
            child: Image.asset(
              'assets/images/logo-circular.png',
              height: 136,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
