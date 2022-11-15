import 'package:flutter/material.dart';
import 'package:git_drive/io/app_data_manager.dart';
import 'package:git_drive/io/local_upload_manager.dart';
import 'package:git_drive/io/resource_manager.dart';
import 'package:git_drive/ui/upload_control_panel.dart';

import '../widgets/neumorphic_button.dart';

GlobalKey<UploadControlPanelState> uploadControlPanelKey = GlobalKey();

class UploadView extends StatelessWidget {
  const UploadView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UploadControlPanel(key: uploadControlPanelKey),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: NeumorphicButton(
              onPressed: () async {
                List<String> paths = await pickFiles();
                LocalUploadManager.addToQueue(paths);
              },
              width: 140,
              height: 40,
              radius: 10,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.file_upload_rounded,
                    color: Colors.blue.shade700,
                  ),
                  const Text(
                    "Upload Files",
                    style: TextStyle(fontFamily: "Itim", fontSize: 16),
                  ),
                  Icon(
                    Icons.file_open_rounded,
                    color: Colors.amber.shade700,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
