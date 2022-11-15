import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:git_drive/io/git_drive_manager.dart';
import 'package:git_drive/io/resource_manager.dart';
import 'package:text_scroll/text_scroll.dart';

import '../ui/remote_view.dart';

Map<String?, bool> downloadQueue = {};

class RemoteFileTile extends StatefulWidget {
  final dynamic content;

  const RemoteFileTile({super.key, required this.content});

  @override
  State<RemoteFileTile> createState() => _RemoteFileTileState();
}

class _RemoteFileTileState extends State<RemoteFileTile> {
  var taskId = "none";

  @override
  void initState() {
    super.initState();
  }

  showCopiedLinkToast() {
    FToast fToast = FToast();
    fToast.init(context);
    fToast.showToast(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.copy_rounded,
                color: Colors.white,
              ),
              Text(
                "Copied to Clipboard!",
                style: TextStyle(
                    fontFamily: "Itim", fontSize: 14, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }

  startDownload() async {
    taskId = await FlutterDownloader.enqueue(
      url: widget.content['download_url'],
      headers: {}, // optional: header send with url (auth token etc)
      savedDir: '/storage/emulated/0/Download',
      showNotification:
          true, // show download progress in status bar (for Android)
      openFileFromNotification:
          true, // click on notification to open downloaded file (for Android)
    ) as String;
    downloadQueue.putIfAbsent(taskId, () => true);
  }

  showToast(icon, text, color) {
    FToast fToast = FToast();
    fToast.init(context);
    fToast.showToast(
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon,
              Flexible(
                child: Text(
                  text,
                  style: const TextStyle(
                      fontFamily: "Itim", fontSize: 14, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    String name = widget.content['name'];
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(image: getImage(name), width: 32, height: 32),
                ],
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 137,
                    child: TextScroll(
                      name,
                      style: const TextStyle(
                        fontFamily: "Itim",
                        fontSize: 14,
                      ),
                      velocity: const Velocity(pixelsPerSecond: Offset(5, 0)),
                    ),
                  ),
                  Text(
                    formatBytes(widget.content['size']),
                    style: const TextStyle(
                      fontFamily: "Itim",
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Material(
                  color: Colors.grey.shade200.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () async {
                            await Clipboard.setData(ClipboardData(
                                text: widget.content['download_url']));
                            showCopiedLinkToast();
                          },
                          icon: const Image(
                              image: linkImage, width: 18, height: 18),
                          splashRadius: 20,
                          tooltip: "Copy Download Link",
                        ),
                        IconButton(
                          onPressed: () async {
                            var downloading = downloadQueue[taskId] ?? false;
                            if (!downloading) {
                              await startDownload();
                            } else {
                              showToast(
                                  const Icon(Icons.done, color: Colors.white),
                                  "Already Downloaded!",
                                  Colors.green);
                            }
                          },
                          icon: const Image(
                              image: downloadImage, width: 18, height: 18),
                          splashRadius: 20,
                          tooltip: "Download File",
                        ),
                        IconButton(
                          onPressed: () async {
                            showToast(
                                const Icon(Icons.auto_delete_rounded,
                                    color: Colors.white),
                                "Deleting $name",
                                Colors.amber.shade700);
                            await GitDriveManager.delete(widget.content);
                            if (remoteFiles.isNotEmpty) {
                              showToast(
                                  const Icon(Icons.delete, color: Colors.white),
                                  "Deleted $name",
                                  Colors.red);
                            }
                          },
                          icon: const Image(
                              image: deleteImage, width: 18, height: 18),
                          splashRadius: 20,
                          tooltip: "Delete File",
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
