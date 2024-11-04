import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CameraController? _cameraController;
  late List<CameraDescription> cameras;
  XFile? imageFile;

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
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _captureImage() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      try {
        // Capture the image and save it as a file
        imageFile = await _cameraController!.takePicture();
        setState(() {});
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
      title: Text(
        "CIVIC VOICE",
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 24,
        ),
      ),
      leading: IconButton(
        onPressed: () {},
        icon: const Icon(
          Icons.menu,
          size: 36,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.account_circle_sharp,
            color: Theme.of(context).colorScheme.primary,
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
          onTap: () {
            _captureImage();
          },
          child: Image.asset(
            'assets/images/logo-circular.png',
            height: 136,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
