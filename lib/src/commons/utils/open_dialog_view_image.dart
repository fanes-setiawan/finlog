import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:finlog/src/commons/constants/styles/sizing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:photo_view/photo_view.dart';

Future<void> openDialogViewImage(String image, {bool isLocal = false}) async {
  await SmartDialog.show(
    alignment: Alignment.center,
    builder: (_) => SafeArea(
      child: Container(
        width: 0.6.sw,
        height: 1.sh,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Sizing.borderRadiusLarge),
          color: Colors.black,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Sizing.borderRadiusLarge),
          child: Stack(
            children: [
              // Zoomable Image
              PhotoView(
                imageProvider: isLocal ? FileImage(File(image)) as ImageProvider : CachedNetworkImageProvider(image),
                loadingBuilder: (context, event) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(Icons.error, color: Colors.red, size: 40),
                ),
                minScale: PhotoViewComputedScale.covered,
                backgroundDecoration: const BoxDecoration(color: Colors.black),
              ),
              // Close Button
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  onPressed: () => SmartDialog.dismiss(),
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.black54),
                    shape: MaterialStatePropertyAll(CircleBorder()),
                    padding: MaterialStatePropertyAll(EdgeInsets.all(8)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
