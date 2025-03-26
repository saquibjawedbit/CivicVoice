import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:civic_voice/components/controller/location_controller.dart';
import 'package:civic_voice/screens/complain/submit_screen.dart';
import 'package:civic_voice/screens/profile/history_screen.dart';
import 'package:civic_voice/screens/profile/profile_screen.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  CameraController? _cameraController;
  late List<CameraDescription> cameras;
  XFile? imageFile;

  bool _isLoading = false;
  bool _flashEnabled = false;

  final LocationController _locationController = Get.put(LocationController());

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      _cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (_cameraController != null) {
        _initializeCamera();
      }
    }
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

  Future<void> _toggleFlash() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      if (_flashEnabled) {
        await _cameraController!.setFlashMode(FlashMode.off);
      } else {
        await _cameraController!.setFlashMode(FlashMode.torch);
      }

      setState(() {
        _flashEnabled = !_flashEnabled;
      });
    } catch (e) {
      debugPrint("Error toggling flash: $e");
    }
  }

  Future<void> _captureImage() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      try {
        // Capture the image and save it as a file
        imageFile = await _cameraController!.takePicture();
        setState(() {
          _isLoading = true;
        });
        await _locationController.requestAddress();
        debugPrint("Image captured: ${imageFile!.path}");
        if (imageFile != null) {
          Get.to(
            () => SubmitScreen(imageFile: imageFile!),
            transition: Transition.fadeIn,
          );
        }
      } catch (e) {
        debugPrint("Error capturing image: $e");
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 16),
              Text(
                'Initializing camera...',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _appBar(),
      body: Stack(
        children: [
          SizedBox.expand(child: CameraPreview(_cameraController!)),
          _cameraOverlay(), // Add camera overlay for better framing
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Processing...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          if (!_isLoading) _guideText(),
          if (!_isLoading) _controlsOverlay(),
        ],
      ),
    );
  }

  Widget _cameraOverlay() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
      ),
      child: Stack(
        children: [
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              height: MediaQuery.of(context).size.width * 0.85,
              decoration: BoxDecoration(
                border:
                    Border.all(color: Colors.white.withOpacity(0.8), width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _guideText() {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.15,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
        ),
        child: const Text(
          'Frame the civic issue clearly in the box',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 84,
      title: const Text(
        "CIVIC VOICE",
        style: TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              blurRadius: 10.0,
              color: Colors.black45,
              offset: Offset(2, 2),
            ),
          ],
        ),
      ),
      leadingWidth: 72,
      leading: Container(
        margin: const EdgeInsets.only(left: 8),
        decoration: const BoxDecoration(
          color: Colors.black38,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: () {
            Get.to(
              () => const HistoryScreen(),
              transition: Transition.leftToRight,
            );
          },
          icon: const Icon(
            Icons.menu,
            size: 32,
            color: Colors.white,
          ),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          decoration: const BoxDecoration(
            color: Colors.black38,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () {
              Get.to(
                () => const ProfileScreen(),
                transition: Transition.rightToLeft,
              );
            },
            icon: const Icon(
              Icons.account_circle_sharp,
              color: Colors.white,
              size: 38,
            ),
          ),
        ),
      ],
    );
  }

  Widget _controlsOverlay() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.7),
              Colors.transparent,
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildControlButton(
              icon: Icons.image,
              label: 'Gallery',
              onTap: _pickImageFromGallery,
            ),
            _buildCaptureButton(),
            _buildControlButton(
              icon: _flashEnabled ? Icons.flash_on : Icons.flash_off,
              label: _flashEnabled ? 'Flash On' : 'Flash Off',
              onTap: _toggleFlash,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.white30,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaptureButton() {
    return GestureDetector(
      onTap: _captureImage,
      child: Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.2),
          border: Border.all(
            color: Colors.white,
            width: 4,
          ),
        ),
        child: Center(
          child: Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
            ),
            child: Image.asset(
              'assets/images/logo-circular.png',
              height: 50,
              width: 50,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _isLoading = true;
        });
        await _locationController.requestAddress();
        Get.to(
          () => SubmitScreen(imageFile: pickedFile),
          transition: Transition.fadeIn,
        );
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
