import 'package:flutter/material.dart';
import 'package:git_drive/io/resource_manager.dart';
import 'package:git_drive/ui/remote_view.dart';
import 'package:git_drive/ui/upload_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: PageView(
          controller: PageController(initialPage: 0, keepPage: true),
          children: const [
            RemoteView(),
            UploadView(),
          ],
        ),
      ),
    );
  }
}
