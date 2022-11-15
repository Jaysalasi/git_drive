import 'package:flutter/material.dart';
import 'package:git_drive/ui/upload_view.dart';
import 'package:git_drive/widgets/file_upload_tile.dart';

import '../ui/upload_control_panel.dart';

List<String> uploadQueue = [];

class LocalUploadManager {
  static void addToQueue(List<String> paths) {
    for (var path in paths) {
      if (!pathInQueue(path)) {
        uploadQueue.add(path);
        uploadTileListKey.currentState?.insertItem(uploadQueue.length - 1,
            duration: const Duration(milliseconds: 500));
        uploadControlPanelKey.currentState?.rebuild();
      }
    }
  }

  static void remove(String path) {
    if (pathInQueue(path)) {
      uploadTileListKey.currentState?.removeItem(uploadQueue.indexOf(path),
          (context, animation) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.linear),
          child: FileUploadTile(path: path, active: false),
        );
      });
      uploadQueue.remove(path);
      uploadControlPanelKey.currentState?.rebuild();
    }
  }

  static bool pathInQueue(String path) {
    return uploadQueue.contains(path);
  }
}
