import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/storage_service.dart';
import '../models/complaint.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

class _HomeScreenState extends State<HomeScreen> {
  CameraController? _cameraController;
  late List<CameraDescription> cameras;
  XFile? imageFile;

  bool _isLoading = false;

  final LocationController _locationController = Get.put(LocationController());

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  final StorageService _storageService = StorageService();

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
        setState(() {
          _isLoading = true;
        });
        await _locationController.requestAddress();
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

  Future<void> _pickImages() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null) {
      setState(() {
        _selectedImages.addAll(images.map((xFile) => File(xFile.path)));
      });
    }
  }

  Future<void> _submitComplaint() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final user = FirebaseAuth.instance.currentUser;
        final complaintId =
            FirebaseFirestore.instance.collection('complaints').doc().id;

        // Upload images first
        final imageUrls = await _storageService.uploadComplaintImages(
          complaintId,
          _selectedImages,
        );

        // Create complaint
        final complaint = Complaint(
          id: complaintId,
          userId: user!.uid,
          title: _titleController.text,
          description: _descriptionController.text,
          timestamp: DateTime.now(),
          imageUrls: imageUrls,
        );

        // Save to Firestore
        await FirebaseFirestore.instance
            .collection('complaints')
            .doc(complaintId)
            .set(complaint.toMap());

        // Clear form
        _titleController.clear();
        _descriptionController.clear();
        setState(() {
          _selectedImages.clear();
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Complaint submitted successfully')),
        );
      } catch (e) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting complaint: $e')),
        );
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
          if (_isLoading)
            const Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          if (!_isLoading) _captureButton(),
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: 'Complaint Title'),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Please enter a title' : null,
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Please enter a description'
                        : null,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _pickImages,
                    icon: Icon(Icons.photo_library),
                    label: Text('Add Images'),
                  ),
                  if (_selectedImages.isNotEmpty) ...[
                    SizedBox(height: 16),
                    Container(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _selectedImages.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Stack(
                              children: [
                                Image.file(_selectedImages[index]),
                                Positioned(
                                  right: 0,
                                  child: IconButton(
                                    icon: Icon(Icons.close, color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        _selectedImages.removeAt(index);
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _submitComplaint,
                    child: Text('Submit Complaint'),
                  ),
                ],
              ),
            ),
          ),
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
