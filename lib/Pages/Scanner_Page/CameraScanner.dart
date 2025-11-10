import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'DetectionInformation.dart';

class Camerascanner extends StatefulWidget {
  const Camerascanner({super.key});

  @override
  State<Camerascanner> createState() => _CamerascannerState();
}

class _CamerascannerState extends State<Camerascanner> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  List<CameraDescription>? _cameras;
  bool _isFrontCamera = false;
  bool _isProcessing = false;

  final List<XFile> _capturedImages = [];
  final int _requiredImageCount = 3;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera({bool front = false}) async {
    _cameras = await availableCameras();
    if (_cameras == null || _cameras!.isEmpty) {
      print("No cameras found");
      return;
    }
    final selectedCamera = front
        ? _cameras!.firstWhere(
          (cam) => cam.lensDirection == CameraLensDirection.front,
      orElse: () => _cameras!.first,
    )
        : _cameras!.firstWhere(
          (cam) => cam.lensDirection == CameraLensDirection.back,
      orElse: () => _cameras!.first,
    );
    await _controller?.dispose();
    _controller = CameraController(
      selectedCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    // Re-assign the future here
    _initializeControllerFuture = _controller!.initialize();

    // Use a try-catch to see if initialization fails
    try {
      await _initializeControllerFuture;
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      print("->!! CAMERA INIT ERROR: $e");
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _navigateToDetection() {
    if (!mounted) return;
    final List<String> imagePaths =
    _capturedImages.map((img) => img.path).toList();
    print(
        "-> NAVIGATION START: Navigating with ${imagePaths.length} images...");
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => Detectioninformation(imagePaths: imagePaths),
      ),
    );
  }

  Future<void> _takePicture() async {
    if (_isProcessing) return;
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      setState(() {
        _isProcessing = true;
      });
      print("-> CAPTURE START: Taking picture...");
      await _initializeControllerFuture;
      final image = await _controller!.takePicture();
      print("-> CAPTURE SUCCESS: Picture saved to ${image.path}");
      setState(() {
        _capturedImages.add(image);
      });
      if (_capturedImages.length == _requiredImageCount) {
        _navigateToDetection();
      }
    } catch (e) {
      print("->!! CAPTURE ERROR: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _pickFromGallery() async {
    // Add a print statement to be sure it's called
    print("-> GALLERY: _pickFromGallery() CALLED.");
    if (_isProcessing) return;
    try {
      setState(() {
        _isProcessing = true;
      });
      print("-> GALLERY: Opening gallery...");
      final List<XFile> images = await ImagePicker().pickMultiImage();
      if (images.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No images selected.')),
          );
        }
        return;
      }
      if (images.length != _requiredImageCount) {
        print("-> GALLERY ERROR: User picked ${images.length} images.");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                Text('Please select exactly $_requiredImageCount photos.')),
          );
        }
        return;
      }
      print("-> GALLERY SUCCESS: Picked 3 images.");
      setState(() {
        _capturedImages.addAll(images);
      });
      _navigateToDetection();
    } catch (e) {
      print("->!! GALLERY ERROR: $e"); // <-- Check your debug console for this!
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _toggleCamera() async {
    _isFrontCamera = !_isFrontCamera;
    await _initializeCamera(front: _isFrontCamera);
  }

  @override
  Widget build(BuildContext context) {
    final Color darkBlue = const Color(0xFF1A1A2F);
    final Color lightGrey = const Color(0xFFF0F0F0);
    final Color accentBlue = const Color(0xFF007AFF);

    // Show a loading spinner until the camera is ready
    if (_controller == null || !_controller!.value.isInitialized) {
      return Scaffold(
        backgroundColor: darkBlue,
        appBar: _buildAppBar(accentBlue),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // --- FIX IS HERE ---
    // Get the camera's aspect ratio
    final cameraAspectRatio = _controller!.value.aspectRatio;
    // --- END FIX ---

    return Scaffold(
      backgroundColor: darkBlue,
      appBar: _buildAppBar(accentBlue),
      body: Stack(
        children: [
          // --- CAMERA PREVIEW ---
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller!.value.previewSize!.height,
                  height: _controller!.value.previewSize!.width,
                  child: CameraPreview(_controller!),
                ),
              ),
            ),
          ),
          // --- BLUE BORDER ---
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 50),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: accentBlue,
                  width: 3.0,
                ),
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
          ),
          // ... (Rest of your Stack children are the same)
          Center(
            child: Text(
              'Position the affected skin area\nwithin the frame',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 16,
              ),
            ),
          ),
          Positioned(
            bottom: 15,
            left: 0,
            right: 0,
            child: Text(
              _capturedImages.isEmpty
                  ? 'Tap the button below to scan'
                  : 'Image ${_capturedImages.length + 1} of $_requiredImageCount',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Positioned(
          //   bottom: 20,
          //   left: 20,
          //   right: 20,
          //   child: Container(
          //     height: 80,
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: List.generate(
          //         _requiredImageCount,
          //             (index) => Container(
          //           width: 60,
          //           height: 60,
          //           margin: const EdgeInsets.symmetric(horizontal: 8),
          //           decoration: BoxDecoration(
          //             color: Colors.black.withOpacity(0.5),
          //             borderRadius: BorderRadius.circular(8),
          //             border: Border.all(color: Colors.white, width: 1),
          //           ),
          //           child: index < _capturedImages.length
          //               ? ClipRRect(
          //             borderRadius: BorderRadius.circular(8),
          //             child: Image.file(
          //               File(_capturedImages[index].path),
          //               fit: BoxFit.cover,
          //             ),
          //           )
          //               : Icon(
          //             Icons.image_not_supported_outlined,
          //             color: Colors.white60,
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 90,
        color: lightGrey,
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.photo_library_outlined,
                  size: 30, color: Colors.black54),
              onPressed: _isProcessing ? null : _pickFromGallery,
            ),
            IconButton(
              icon: _isProcessing
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Icon(Icons.camera_alt),
              iconSize: 35,
              color: Colors.white,
              style: IconButton.styleFrom(
                backgroundColor: accentBlue,
                padding: const EdgeInsets.all(15),
                shape: const CircleBorder(),
              ),
              onPressed: _isProcessing ? null : _takePicture,
            ),
            IconButton(
              icon: const Icon(Icons.rotate_left_sharp,
                  size: 30, color: Colors.black54),
              onPressed: _isProcessing ? null : _toggleCamera,
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(Color accentBlue) {
    return AppBar(
      title: const Text(
        'Skin Scanner',
        style: TextStyle(color: Colors.white),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }
}