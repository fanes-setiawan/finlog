import 'dart:io';

import 'package:finlog/src/commons/extensions/translate_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';

import 'package:path_provider/path_provider.dart';


class ImageUtils {
  static Future<File?> compressImage({
    required File file,
  }) async {
    try {
      final filePath = file.absolute.path;
      final cleanPath =
          filePath.replaceAll(RegExp(r'compressed-\d+\.jpg$'), '');
      final compressedPath =
          "${cleanPath}compressed-${DateTime.now().millisecondsSinceEpoch}.jpg";

      var result = await FlutterImageCompress.compressAndGetFile(
        filePath,
        compressedPath,
        quality: 88,
      );
      if (result != null) {
        return File(result.path);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> _pickImage({
    void Function()? showLoading,
    void Function()? dismissLoading,
    void Function(String title, String desc)? showErrorDialog,
    void Function(File selectedImage)? onImageSelected,
    required ImageSource source,
    int? imageQuality,
  }) async {
    try {
      showLoading?.call();

      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        imageQuality: imageQuality,
      );

      dismissLoading?.call();
      if (pickedFile != null) {
        onImageSelected?.call(File(pickedFile.path));
      }
    } catch (e) {
      dismissLoading?.call();
      showErrorDialog?.call(
        'failPickImage'.trLabel(),
        "$e",
      );
    }
  }

  // pickImageFromCamera
  static Future<void> pickImageFromCamera({
    void Function()? showLoading,
    void Function()? dismissLoading,
    void Function(String title, String desc)? showErrorDialog,
    void Function(File selectedImage)? onImageSelected,
  }) async {
    _pickImage(
      showLoading: showLoading,
      dismissLoading: dismissLoading,
      showErrorDialog: showErrorDialog,
      onImageSelected: onImageSelected,
      source: ImageSource.camera,
      imageQuality: 25,
    );
  }

  // pickImageFromGallery
  static void pickImageFromGallery({
    void Function()? showLoading,
    void Function()? dismissLoading,
    void Function(String title, String desc)? showErrorDialog,
    void Function(File selectedImage)? onImageSelected,
  }) {
    _pickImage(
      showLoading: showLoading,
      dismissLoading: dismissLoading,
      showErrorDialog: showErrorDialog,
      onImageSelected: onImageSelected,
      source: ImageSource.gallery,
    );
  }

  // scanBarcode
  static Future<void> scanBarcode({
    required BuildContext context,
    void Function()? showLoading,
    void Function()? dismissLoading,
    void Function(String title, String desc)? showErrorDialog,
    void Function(String textBarcode)? onBarcodeScanned,
  }) async {
    try {
      // Check camera availability first
      if (!await _isCameraAvailable()) {
        showErrorDialog?.call(
          'Kamera Tidak Tersedia',
          'Perangkat tidak memiliki kamera atau kamera sedang digunakan aplikasi lain.',
        );
        return;
      }

      // Navigate to barcode scanner screen
      final result = await Navigator.of(context).push<String>(
        MaterialPageRoute(
          builder: (context) => const _BarcodeScannerScreen(),
        ),
      );

      dismissLoading?.call();

      // jika tidak diklik batal dan ada hasil scan
      if (result != null && result.isNotEmpty) {
        onBarcodeScanned?.call(result);
      }
    } catch (e) {
      dismissLoading?.call();
      showErrorDialog?.call(
        'failScan'.trLabel(),
        "$e",
      );
    }
  }

  // Check if camera is available
  static Future<bool> _isCameraAvailable() async {
    try {
      final controller = MobileScannerController();
      await controller.start();
      await controller.stop();
      controller.dispose();
      return true;
    } catch (e) {
      debugPrint('Camera availability check failed: $e');
      return false;
    }
  }

  // stream barcode
  static void streamBarcode({
    required BuildContext context,
    void Function()? showLoading,
    void Function()? dismissLoading,
    void Function(String title, String desc)? showErrorDialog,
    void Function(String textBarcode)? onBarcodeScanned,
  }) async {
    try {
      showLoading?.call();

      // Navigate to barcode scanner screen with streaming mode
      final result = await Navigator.of(context).push<String>(
        MaterialPageRoute(
          builder: (context) => const _BarcodeScannerScreen(isStreamMode: true),
        ),
      );

      dismissLoading?.call();

      // jika tidak diklik batal dan ada hasil scan
      if (result != null && result.isNotEmpty) {
        onBarcodeScanned?.call(result);
      }
    } catch (e) {
      dismissLoading?.call();
      showErrorDialog?.call(
        'failScan'.trLabel(),
        "$e",
      );
    }
  }

  /// mengubah komponen ui (widget) menjadi png
  static Future<Uint8List> capturePng(GlobalKey key) async {
    debugPrint("capturePng");
    try {
      RenderRepaintBoundary boundary =
          key.currentContext!.findRenderObject() as RenderRepaintBoundary;

      if (boundary.debugNeedsPaint) {
        debugPrint("Waiting for boundary to be painted.");
        await Future.delayed(const Duration(milliseconds: 20));
        return capturePng(key);
      }

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData?.buffer.asUint8List();
      // var base64 = base64Encode(pngBytes);

      debugPrint("berhasil");
      return pngBytes ?? Uint8List(0);
    } catch (e) {
      debugPrint("error capture png : $e");
      return Uint8List(0);
    }
  }

  /// mengubah uint8M menjadi objek File
  static Future<File> uint8ToFile(Uint8List uint8list,
      {bool saveLocally = false, String? fileName}) async {
    late File file;
    final tempDir = await getTemporaryDirectory();
    if (saveLocally) {
      Directory? documentDirectory = await getExternalStorageDirectory();
      file = await File(
              "${documentDirectory != null ? documentDirectory.path : tempDir.path}/${fileName ?? 'image'}.png")
          .create();
    } else {
      file = await File(
        '${tempDir.path}/${fileName ?? DateTime.now().millisecondsSinceEpoch}.png',
      ).create();
    }

    debugPrint("tempDir = $tempDir");
    debugPrint(file.path);
    file.writeAsBytesSync(uint8list);
    return file;
  }
}

/// Internal barcode scanner screen using mobile_scanner
class _BarcodeScannerScreen extends StatefulWidget {
  final bool isStreamMode;

  const _BarcodeScannerScreen({this.isStreamMode = false});

  @override
  State<_BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<_BarcodeScannerScreen> {
  late MobileScannerController cameraController;
  bool isScanned = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    cameraController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
      torchEnabled: false,
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture barcodeCapture) {
    if (isScanned) return;

    final barcode = barcodeCapture.barcodes.first;
    if (barcode.rawValue != null) {
      setState(() {
        isScanned = true;
      });

      // Add haptic feedback
      HapticFeedback.lightImpact();

      Navigator.of(context).pop(barcode.rawValue!);
    }
  }

  Widget _buildErrorWidget(MobileScannerException error) {
    String message = '';
    IconData icon = Icons.error;

    switch (error.errorCode) {
      case MobileScannerErrorCode.controllerUninitialized:
        message = 'Scanner belum siap, silakan tunggu...';
        icon = Icons.hourglass_empty;
        break;
      case MobileScannerErrorCode.permissionDenied:
        message =
            'Izin kamera diperlukan untuk scan barcode.\nBuka pengaturan untuk memberikan izin kamera.';
        icon = Icons.camera_alt_outlined;
        break;
      case MobileScannerErrorCode.unsupported:
        message = 'Perangkat tidak mendukung fitur scan barcode.';
        icon = Icons.phone_android;
        break;
      default:
        message =
            'Terjadi kesalahan pada kamera.\nPastikan kamera tidak digunakan aplikasi lain.';
        icon = Icons.camera_alt_outlined;
    }

    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            if (error.errorCode == MobileScannerErrorCode.permissionDenied)
              ElevatedButton(
                onPressed: () async {
                  // Restart scanner controller
                  try {
                    await cameraController.stop();
                    await cameraController.start();
                  } catch (e) {
                    debugPrint('Error restarting camera: $e');
                  }
                },
                child: const Text('Coba Lagi'),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('scanBarcode'.trLabel()),
        backgroundColor: const Color(0xFF39A0ED),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () {
              try {
                cameraController.toggleTorch();
              } catch (e) {
                debugPrint('Error toggling torch: $e');
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.cameraswitch),
            onPressed: () {
              try {
                cameraController.switchCamera();
              } catch (e) {
                debugPrint('Error switching camera: $e');
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: _onDetect,
            errorBuilder: (context, error, child) {
              return _buildErrorWidget(error);
            },
          ),
          // Overlay with scanning area
          Container(
            decoration: const ShapeDecoration(
              shape: _ScannerOverlayShape(),
            ),
          ),
          // Instructions
          Positioned(
            bottom: 80,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'scanBarcodeInstruction'.trLabel(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom shape for scanner overlay
class _ScannerOverlayShape extends ShapeBorder {
  const _ScannerOverlayShape();

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(10);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Path path = Path()..addRect(rect);
    Path hole = Path();

    // Create scanning area (square in center)
    double scanAreaSize = rect.width * 0.7;
    double left = (rect.width - scanAreaSize) / 2;
    double top = (rect.height - scanAreaSize) / 2;

    hole.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(left, top, scanAreaSize, scanAreaSize),
      const Radius.circular(12),
    ));

    return Path.combine(PathOperation.difference, path, hole);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    Paint paint = Paint()
      ..color = Colors.black54
      ..style = PaintingStyle.fill;

    canvas.drawPath(getOuterPath(rect), paint);

    // Draw corner lines for scanning area
    double scanAreaSize = rect.width * 0.7;
    double left = (rect.width - scanAreaSize) / 2;
    double top = (rect.height - scanAreaSize) / 2;

    Paint cornerPaint = Paint()
      ..color = const Color(0xFF39A0ED)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    double cornerLength = 30;

    // Top-left corner
    canvas.drawLine(
      Offset(left, top + cornerLength),
      Offset(left, top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left, top),
      Offset(left + cornerLength, top),
      cornerPaint,
    );

    // Top-right corner
    canvas.drawLine(
      Offset(left + scanAreaSize - cornerLength, top),
      Offset(left + scanAreaSize, top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left + scanAreaSize, top),
      Offset(left + scanAreaSize, top + cornerLength),
      cornerPaint,
    );

    // Bottom-left corner
    canvas.drawLine(
      Offset(left, top + scanAreaSize - cornerLength),
      Offset(left, top + scanAreaSize),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left, top + scanAreaSize),
      Offset(left + cornerLength, top + scanAreaSize),
      cornerPaint,
    );

    // Bottom-right corner
    canvas.drawLine(
      Offset(left + scanAreaSize - cornerLength, top + scanAreaSize),
      Offset(left + scanAreaSize, top + scanAreaSize),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left + scanAreaSize, top + scanAreaSize - cornerLength),
      Offset(left + scanAreaSize, top + scanAreaSize),
      cornerPaint,
    );
  }

  @override
  ShapeBorder scale(double t) => const _ScannerOverlayShape();
}
