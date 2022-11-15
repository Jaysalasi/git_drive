import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:git_drive/io/git_drive_manager.dart';
import 'package:git_drive/io/github_authentication.dart';
import 'package:git_drive/ui/remote_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;

Future<void> initAppResources() async {
  prefs = await SharedPreferences.getInstance();
  if (isLoggedIn()) {
    GitHubAuthentication.authenticateAutomatically();
    Fluttertoast.showToast(
      backgroundColor: Colors.blue,
      fontSize: 14,
      textColor: Colors.white,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_LONG,
      msg: 'Please wait! ... Initializing',
    );
    await GitDriveManager.reloadRepoContents();
  }
}

bool isLoggedIn() {
  return prefs.getBool('logged-in') ?? false;
}

Future<List<String>> pickFiles() async {
  FilePickerResult? result = await FilePicker.platform
      .pickFiles(allowMultiple: true, dialogTitle: "Pick Files to Upload");
  if (result != null) {
    List<String> res = [];
    for (var path in result.paths) {
      res.add(path as String);
    }
    return res;
  }
  return [];
}
