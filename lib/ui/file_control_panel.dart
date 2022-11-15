import 'package:flutter/material.dart';
import 'package:git_drive/io/git_drive_manager.dart';
import 'package:git_drive/ui/remote_view.dart';
import 'package:git_drive/widgets/remote_file_tile.dart';
import 'package:lottie/lottie.dart';

import '../io/resource_manager.dart';

GlobalKey<AnimatedListState> remoteTileListKey = GlobalKey();

class FileControlPanel extends StatefulWidget {
  const FileControlPanel({super.key});

  @override
  State<FileControlPanel> createState() => FileControlPanelState();
}

class FileControlPanelState extends State<FileControlPanel> {
  void rebuild() => setState(() {});

  Widget _buildBody() {
    List<dynamic> filteredFiles = [];
    if (filter != 'none') {
      var allowedExtensions = [];
      if (filter == 'images') {
        allowedExtensions = ['jpg', 'png', 'jpeg', 'gif', 'bmp', 'svg'];
      } else if (filter == 'videos') {
        allowedExtensions = ['mp4', 'mkv', 'webm'];
      } else if (filter == 'audio') {
        allowedExtensions = ['mp3', 'm4a', 'wav'];
      } else {
        allowedExtensions = [
          'jpg',
          'png',
          'jpeg',
          'gif',
          'bmp',
          'svg',
          'mp4',
          'mkv',
          'webm',
          'mp3',
          'm4a',
          'wav'
        ];
      }
      for (var content in remoteFiles) {
        String name = content['name'];
        String ext = name.substring(name.lastIndexOf('.') + 1);
        if (filter == 'documents') {
          if (!allowedExtensions.contains(ext)) {
            filteredFiles.add(content);
          }
        } else {
          if (allowedExtensions.contains(ext)) {
            filteredFiles.add(content);
          }
        }
      }
      if (!searchMode) {
        return filteredFiles.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset('assets/search-empty-animation.json'),
                  const Text(
                    "Looks like we got lost in search!",
                    style: TextStyle(
                      fontFamily: "Itim",
                      fontSize: 20,
                    ),
                  ),
                  const Text(
                    "No File Found for current applied filter.",
                    style: TextStyle(
                      fontFamily: "Itim",
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Icon(
                    Icons.keyboard_double_arrow_right,
                    color: Colors.grey.shade700,
                  ),
                  const Text(
                    "Swipe right to start uploading.",
                    style: TextStyle(
                      fontFamily: "Itim",
                      fontSize: 18,
                    ),
                  ),
                ],
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnimatedList(
                  key: remoteTileListKey,
                  initialItemCount: filteredFiles.length,
                  itemBuilder: (context, index, animation) {
                    if (index >= filteredFiles.length) {
                      return const SizedBox();
                    }
                    return FadeTransition(
                      opacity: CurvedAnimation(
                          parent: animation, curve: Curves.bounceIn),
                      child: RemoteFileTile(
                          content: filteredFiles.elementAt(index)),
                    );
                  },
                ),
              );
      }
    }
    if (searchMode) {
      List<dynamic> searchResults = [];
      List<dynamic> searchArea = filter == 'none' ? remoteFiles : filteredFiles;
      for (var content in searchArea) {
        if (content['name'].contains(
            searchFieldKey.currentState?.searchFieldController.text)) {
          searchResults.add(content);
        }
      }
      return searchResults.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset('assets/search-empty-animation.json'),
                const Text(
                  "Looks like we got lost in search!",
                  style: TextStyle(
                    fontFamily: "Itim",
                    fontSize: 20,
                  ),
                ),
                const Text(
                  "No File Found for current applied filter in search mode.",
                  style: TextStyle(
                    fontFamily: "Itim",
                    fontSize: 18,
                  ),
                ),
              ],
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: AnimatedList(
                key: remoteTileListKey,
                initialItemCount: searchResults.length,
                itemBuilder: (context, index, animation) {
                  if (index >= searchResults.length) {
                    return const SizedBox();
                  }
                  return FadeTransition(
                    opacity: CurvedAnimation(
                        parent: animation, curve: Curves.bounceIn),
                    child:
                        RemoteFileTile(content: searchResults.elementAt(index)),
                  );
                },
              ),
            );
    }
    return remoteFiles.isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset('assets/cat-animation.json'),
              const Text(
                "Your Git Drive is empty!",
                style: TextStyle(
                  fontFamily: "Itim",
                  fontSize: 20,
                ),
              ),
              const Text(
                "Upload some files to list them here.",
                style: TextStyle(
                  fontFamily: "Itim",
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 20),
              Icon(
                Icons.keyboard_double_arrow_right,
                color: Colors.grey.shade700,
              ),
              const Text(
                "Swipe right to start uploading.",
                style: TextStyle(
                  fontFamily: "Itim",
                  fontSize: 18,
                ),
              ),
            ],
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: AnimatedList(
              key: remoteTileListKey,
              initialItemCount: remoteFiles.length,
              itemBuilder: (context, index, animation) {
                return FadeTransition(
                  opacity: CurvedAnimation(
                      parent: animation, curve: Curves.bounceIn),
                  child: RemoteFileTile(content: remoteFiles.elementAt(index)),
                );
              },
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
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
      child: _buildBody(),
    );
  }
}
