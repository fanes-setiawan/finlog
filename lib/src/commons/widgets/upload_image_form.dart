import 'dart:io';

import 'package:finlog/src/commons/constants/styles/app_colors.dart';
import 'package:finlog/src/commons/constants/styles/sizing.dart';
import 'package:finlog/src/commons/extensions/translate_extension.dart';
import 'package:finlog/src/commons/utils/image_utils.dart';
import 'package:finlog/src/commons/utils/open_dialog_view_image.dart';
import 'package:finlog/src/commons/widgets/app_text.dart';
import 'package:finlog/src/commons/widgets/primary_button.dart';
import 'package:finlog/src/commons/widgets/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gap/gap.dart';

class UploadImageForm extends StatefulWidget {
  final String? title;
  final String? description;
  final String uploadAreaText;
  final String buttonText;
  final Widget? initialImage;
  final File? initialFile;
  final VoidCallback? onUpload;
  final Function(dynamic)? onChanged; // Single callback for all image changes
  final UploadImageFormController? controller;

  const UploadImageForm({
    Key? key,
    this.title,
    this.description,
    this.uploadAreaText = 'Upload new image',
    this.buttonText = 'Upload now',
    this.initialImage,
    this.initialFile,
    this.onUpload,
    this.onChanged,
    this.controller,
  }) : super(key: key);

  @override
  State<UploadImageForm> createState() => _UploadImageFormState();
}

class _UploadImageFormState extends State<UploadImageForm> {
  Widget? _currentImage;
  late UploadImageFormController _controller;
  bool _isInternalController = false;

  @override
  void initState() {
    super.initState();

    // Initialize controller
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = UploadImageFormController();
      _isInternalController = true;
    }

    // Set initial image and file if provided
    _controller.setInitial(
      image: widget.initialImage,
      file: widget.initialFile,
    );

    // Set initial image widget - prioritize controller's image
    _currentImage = _controller.getCurrentImage();

    // Listen to controller changes
    _controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    if (_isInternalController) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onControllerChanged() {
    debugPrint('🔥 upload_image_form:85 ~ onControllerChanged');
    setState(() {
      _currentImage = _controller.getCurrentImage();
    });
  }

  void _selectImage() async {
    final isSelectFromGallery = await _selectSource();
    if (isSelectFromGallery == null) return;

    if (isSelectFromGallery) {
      ImageUtils.pickImageFromGallery(
        onImageSelected: _onImageSelected,
      );
    } else {
      ImageUtils.pickImageFromCamera(
        onImageSelected: _onImageSelected,
      );
    }
  }

  void _onImageSelected(File? pickedImage) {
    if (pickedImage != null) {
      _controller.setFile(pickedImage);

      // Call the onChanged callback if provided
      if (widget.onChanged != null) {
        widget.onChanged!(pickedImage);
      }
    }
  }

  void _clearImage() {
    _controller.clear();

    // Call the onChanged callback if provided
    if (widget.onChanged != null) {
      widget.onChanged!(null); // null indicates cleared/back to initial
    }
  }

  // return true when select from gallery
  // return false when select from camera
  Future<bool?> _selectSource() async {
    bool? isSelectFromGallery;

    await SmartDialog.show(
      builder: (context) {
        return SizedBox(
          width: 0.3.sw,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(Sizing.lg),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Sizing.borderRadiusMedium),
                  color: AppColors.white,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        SmartDialog.dismiss();
                        isSelectFromGallery = true;
                      },
                      icon: Padding(
                        padding: Spacing.x(Sizing.md),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(LucideIcons.image, size: Sizing.icon),
                            Gap(Sizing.sm),
                            AppText("gallery".trLabel()).labelMedium,
                          ],
                        ),
                      ),
                    ),
                    const Divider(),
                    IconButton(
                      onPressed: () {
                        SmartDialog.dismiss();
                        isSelectFromGallery = false;
                      },
                      icon: Padding(
                        padding: Spacing.x(Sizing.md),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(LucideIcons.camera, size: Sizing.icon),
                            Gap(Sizing.sm),
                            AppText("camera".trLabel()).labelMedium,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Gap(Sizing.sm),
              PrimaryButton(
                width: 0.3.sw,
                onPressed: () {
                  SmartDialog.dismiss();
                },
                label: "cancel".trLabel(),
              ),
            ],
          ),
        );
      },
    );

    return isSelectFromGallery;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        if (widget.title != null) ...[
          AppText(
            widget.title!,
          ).subtitleSmall.bold,
          Gap(Sizing.sm),
        ],
        // Description
        if (widget.description != null) ...[
          Text(
            widget.description!,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
              height: 1.5,
            ),
          ),
          Gap(Sizing.md),
        ],
        // Upload Area
        GestureDetector(
          onTap: _selectImage,
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: _currentImage != null ? Colors.grey[100] : AppColors.primary4,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey[300]!,
                width: 2,
                style: BorderStyle.solid,
              ),
            ),
            child: _currentImage != null
                ? Stack(
                    children: [
                      // Image Display
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: _currentImage!,
                        ),
                      ),
                      // Change Image Overlay
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withOpacity(0.6),
                          ),
                          child: IconButton(
                            onPressed: _selectImage,
                            icon: Icon(
                              LucideIcons.refresh_ccw,
                              color: Colors.white,
                              size: Sizing.icon,
                            ),
                          ),
                        ),
                      ),
                      // Clear Image Button (only show if image was selected, not initial)
                      if (_controller.hasSelectedImage)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red.withOpacity(0.8),
                            ),
                            child: IconButton(
                              onPressed: _clearImage,
                              icon: Icon(
                                LucideIcons.x,
                                color: Colors.white,
                                size: Sizing.icon,
                              ),
                            ),
                          ),
                        ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Upload Icon
                      Container(
                        width: Sizing.icon + Sizing.xl,
                        height: Sizing.icon + Sizing.xl,
                        decoration: const BoxDecoration(
                          color: AppColors.neutral6,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          LucideIcons.cloud_upload,
                          size: Sizing.icon * 1.5,
                          color: Colors.white,
                        ),
                      ),
                      Gap(Sizing.md),
                      // Upload Text
                      AppText(
                        widget.uploadAreaText,
                      ).labelSmall.color(AppColors.neutral6).semiBold,
                    ],
                  ),
          ),
        ),
        Gap(Sizing.md),
        // Upload Button
        PrimaryButton(
          width: double.infinity,
          onPressed: _selectImage,
          label: widget.buttonText,
        ),
      ],
    );
  }
}

class UploadImageFormController extends ChangeNotifier {
  File? _selectedFile;
  bool _hasSelectedImage = false;
  Widget? _initialImage;

  /// The currently selected file
  File? get file => _selectedFile;

  /// Whether a new image has been selected (not just initial image)
  bool get hasSelectedImage => _hasSelectedImage;

  /// Whether any file is currently set (including initial image)
  bool get hasFile => _selectedFile != null;

  /// The initial image widget
  Widget? get initialImage => _initialImage;

  /// Whether the initial image has been changed/replaced
  bool get isImageChanged => _hasSelectedImage;

  /// Get the current image widget to display
  Widget? getCurrentImage() {
    if (_selectedFile != null && _hasSelectedImage) {
      // If user has selected a new image, show it with tap gesture
      return GestureDetector(
        onTap: () => openDialogViewImage(_selectedFile!.path, isLocal: true),
        child: Image.file(
          _selectedFile!,
          fit: BoxFit.cover,
        ),
      );
    } else if (_selectedFile != null && !_hasSelectedImage) {
      // If initial file is set, show it with tap gesture
      return GestureDetector(
        onTap: () => openDialogViewImage(_selectedFile!.path, isLocal: true),
        child: Image.file(
          _selectedFile!,
          fit: BoxFit.cover,
        ),
      );
    } else if (_initialImage != null) {
      // If initial image widget is set, show it
      return _initialImage;
    }
    return null;
  }

  /// Set the initial image widget
  void setInitialImage(Widget? image) {
    _initialImage = image;
    notifyListeners();
  }

  /// Set the selected file
  void setFile(File? file) {
    _selectedFile = file;
    _hasSelectedImage = file != null;
    notifyListeners();
  }

  /// Clear the selected file (back to initial state)
  void clear() {
    _selectedFile = null;
    _hasSelectedImage = false;
    notifyListeners();
  }

  /// Set initial file (doesn't mark as selected)
  void setInitialFile(File? file) {
    debugPrint('🔥 upload_image_form:390 ~ setInitialFile');
    _selectedFile = file;
    _hasSelectedImage = false;
    notifyListeners();
  }

  /// Set both initial image widget and file
  void setInitial({Widget? image, File? file}) {
    _initialImage = image;
    _selectedFile = file;
    _hasSelectedImage = false;
    notifyListeners();
  }

  /// Reset to initial state with optional initial image and file
  void reset({Widget? initialImage, File? initialFile}) {
    _initialImage = initialImage;
    _selectedFile = initialFile;
    _hasSelectedImage = false;
    notifyListeners();
  }
}
