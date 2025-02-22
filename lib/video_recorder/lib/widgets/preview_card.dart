import 'dart:io';
import 'dart:math';

import 'package:camerawesome/camerawesome_plugin.dart';
// import 'package:camerawesome/models/orientations.dart';
import 'package:flutter/material.dart';

import '../utils/orientation_utils.dart';

class PreviewCardWidget extends StatelessWidget {
  final String lastPhotoPath;
  final Animation<Offset> previewAnimation;
  final ValueNotifier<CameraOrientations> orientation;

  const PreviewCardWidget({
    super.key,
    required this.lastPhotoPath,
    required this.previewAnimation,
    required this.orientation,
  });

  @override
  Widget build(BuildContext context) {
    Alignment alignment;
    bool mirror;
    switch (orientation.value) {
      case CameraOrientations.portrait_up:
      case CameraOrientations.portrait_down:
        alignment = orientation.value == CameraOrientations.portrait_up
            ? Alignment.bottomLeft
            : Alignment.topLeft;
        mirror = orientation.value == CameraOrientations.portrait_down;
        break;
      case CameraOrientations.landscape_left:
      case CameraOrientations.landscape_right:
        alignment = Alignment.topLeft;
        mirror = orientation.value == CameraOrientations.landscape_left;
        break;
    }

    return Align(
      alignment: alignment,
      child: Padding(
        padding: OrientationUtils.isOnPortraitMode(orientation.value)
            ? const EdgeInsets.symmetric(horizontal: 35.0, vertical: 140)
            : const EdgeInsets.symmetric(vertical: 65.0),
        child: Transform.rotate(
          angle: OrientationUtils.convertOrientationToRadian(
            orientation.value,
          ),
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(mirror ? pi : 0.0),
            child: Dismissible(
              onDismissed: (direction) {},
              key: UniqueKey(),
              child: SlideTransition(
                position: previewAnimation,
                child: _buildPreviewPicture(reverseImage: mirror),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewPicture({bool reverseImage = false}) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            offset: Offset(2, 2),
            blurRadius: 25,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(13.0),
          child: lastPhotoPath != null
              ? Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(reverseImage ? pi : 0.0),
                  child: Image.file(
                    File(lastPhotoPath),
                    width: OrientationUtils.isOnPortraitMode(orientation.value)
                        ? 128
                        : 256,
                  ),
                )
              : Container(
                  width: OrientationUtils.isOnPortraitMode(orientation.value)
                      ? 128
                      : 256,
                  height: 228,
                  decoration: const BoxDecoration(
                    color: Colors.black38,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.photo,
                      color: Colors.white,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
