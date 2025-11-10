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

  Widget _buildSymptomDialogContent(BuildContext dialogContext) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white, // Dialog background color
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12.0,
            offset: Offset(0.0, 8.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // To make the dialog wrap content
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // --- Title ---
          Text(
            "Describe Your Symptoms",
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),

          // --- Subtitle/Description ---
          Text(
            "Please list any symptoms you're experiencing (e.g., itching, redness, bumps).",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),

          // --- Text Field ---
          TextField(
            controller: _symptomsController,
            decoration: InputDecoration(
              labelText: "Symptoms",
              hintText: "e.g., Itchy and red rash on my arm...",
              // Add a prefix icon
              icon: Icon(Icons.edit_note_rounded,
                  color: theme.colorScheme.primary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              // Style the border when it's focused
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(
                  color: theme.colorScheme.primary,
                  width: 2.0,
                ),
              ),
            ),
            autofocus: true,
            maxLines: 3,
            minLines: 1,
            // Automatically capitalize the first letter of sentences
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 24),

          // --- Action Buttons ---
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              // Secondary button (Skip)
              TextButton(
                style: TextButton.styleFrom(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text(
                  "Skip",
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  Navigator.of(dialogContext).pop(""); // Pass empty string
                },
              ),
              const SizedBox(width: 8),

              // Primary button (Confirm)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text(
                  "Confirm",
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  Navigator.of(dialogContext).pop(_symptomsController.text);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _promptForSymptoms() async {
    // Clear the controller from previous inputs
    _symptomsController.clear();

    final String? symptoms = await showDialog<String>(
      context: context,
      barrierDismissible: false, // User must interact
      builder: (BuildContext dialogContext) {
        // Using Dialog directly for more customization
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent, // We set color on the container
          child: _buildSymptomDialogContent(dialogContext),
        );
      },
    );

    // After the dialog closes, navigate.
    if (!mounted) return;
    _navigateToDetection(symptoms ?? "");
  }

  // --- MODIFIED ---
  // Now accepts a symptoms string to pass forward
  void _navigateToDetection(String symptoms) {
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