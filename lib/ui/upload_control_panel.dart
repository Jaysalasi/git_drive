import 'package:flutter/material.dart';
import 'package:git_drive/io/local_upload_manager.dart';
import 'package:git_drive/widgets/file_upload_tile.dart';
import 'package:lottie/lottie.dart';

import '../io/resource_manager.dart';

GlobalKey<AnimatedListState> uploadTileListKey = GlobalKey();

class UploadControlPanel extends StatefulWidget {
  const UploadControlPanel({super.key});

  @override
  State<UploadControlPanel> createState() => UploadControlPanelState();
}

class UploadControlPanelState extends State<UploadControlPanel> {
  void rebuild() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFA3B1C6).withOpacity(0.5),
                blurRadius: 20,
                offset: const Offset(20, 20),
              ),
              const BoxShadow(
                color: backgroundColor,
                blurRadius: 20,
                offset: Offset(-20, -20),
              ),
            ],
          ),
          child: uploadQueue.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset('assets/atom-animation.json'),
                    const Text(
                      "Nothing to Upload!",
                      style: TextStyle(
                        fontFamily: "Itim",
                        fontSize: 20,
                      ),
                    ),
                    const Flexible(
                      child: Text(
                        "Click that button at the bottom to select some files",
                        style: TextStyle(
                          fontFamily: "Itim",
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.all(8),
                  child: AnimatedList(
                    key: uploadTileListKey,
                    initialItemCount: uploadQueue.length,
                    itemBuilder: (context, index, animation) {
                      return FadeTransition(
                        opacity: CurvedAnimation(
                            parent: animation, curve: Curves.elasticInOut),
                        child:
                            FileUploadTile(path: uploadQueue.elementAt(index)),
                      );
                    },
                  ),
                ),
        ),
      ),
    );
  }
}
