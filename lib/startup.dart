import 'package:flutter/material.dart';
import 'package:git_drive/io/app_data_manager.dart';
import 'package:git_drive/ui/home_screen.dart';
import 'package:git_drive/ui/login_screen.dart';

class Startup {
  static Widget getInitialView() {
    return isLoggedIn() ? const HomeScreen() : LoginScreen();
  }
}
