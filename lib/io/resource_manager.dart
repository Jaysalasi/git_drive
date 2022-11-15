import 'dart:math';

import 'package:flutter/material.dart';

const version = '1.0';
const backgroundColor = Color(0xFFEFF0F3);
const appIcon = AssetImage('assets/git-drive.png');
const documentImage = AssetImage('assets/document-icon.png');
const pictureImage = AssetImage('assets/picture-icon.png');
const videoImage = AssetImage('assets/video-icon.png');
const audioImage = AssetImage('assets/audio-icon.png');
const errorImage = AssetImage('assets/error-icon.png');
const completedImage = AssetImage('assets/completed-icon.png');
const linkImage = AssetImage('assets/link-icon.png');
const downloadImage = AssetImage('assets/download-icon.png');
const deleteImage = AssetImage('assets/delete-icon.png');
const githubImage = AssetImage('assets/github.png');

ImageProvider getImage(String path) {
  String ext = path.substring(path.lastIndexOf('.') + 1);
  if (['jpg', 'png', 'jpeg', 'gif', 'bmp', 'svg'].contains(ext)) {
    return pictureImage;
  } else if (['mp4', 'mkv', 'webm'].contains(ext)) {
    return videoImage;
  } else if (['mp3', 'm4a', 'wav'].contains(ext)) {
    return audioImage;
  }
  return documentImage;
}

String formatBytes(int bytes) {
  if (bytes <= 0) {
    return "0 B";
  }
  const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
  var i = (log(bytes) / log(1024)).floor();
  return '${(bytes / pow(1024, i)).toStringAsFixed(0)} ${suffixes[i]}';
}
