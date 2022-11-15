// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:git_drive/io/git_drive_manager.dart';
import 'package:git_drive/io/local_upload_manager.dart';
import 'package:git_drive/io/resource_manager.dart';
import 'package:lottie/lottie.dart';
import 'package:text_scroll/text_scroll.dart';

class FileUploadTile extends StatelessWidget {
  final String path;
  bool uploaded = false;
  bool active;

  FileUploadTile({super.key, required this.path, this.active = true}) {
    uploaded = GitDriveManager.isFilePresentOnRemote(path);
    if (uploaded) {
      Future.delayed(const Duration(seconds: 2), () {
        LocalUploadManager.remove(path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String name = path.substring(path.lastIndexOf(Platform.pathSeparator) + 1);
    File file = File(path);
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        width: MediaQuery.of(context).size.width,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Image(
              image: getImage(path),
              width: 32,
              height: 32,
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 200,
                  child: TextScroll(
                    name,
                    style: TextStyle(
                      fontFamily: "Itim",
                      fontSize: 16,
                      color: Colors.grey.shade800,
                    ),
                    velocity: const Velocity(pixelsPerSecond: Offset(5, 0)),
                  ),
                ),
                FutureBuilder(
                  future: file.stat(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Icon(
                        Icons.bar_chart,
                        color: Colors.grey,
                      );
                    }
                    return Text(
                      formatBytes(snapshot.data?.size as int),
                      style: const TextStyle(
                        fontFamily: "Itim",
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    );
                  },
                )
              ],
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (uploaded || !active)
                    const Image(
                      image: completedImage,
                      width: 32,
                      height: 32,
                    ),
                  if (!uploaded && active)
                    FutureBuilder(
                        future: GitDriveManager.upload(path),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Lottie.asset(
                                'assets/circular-loading-animation.json',
                                width: 50);
                          } else if (snapshot.hasError) {
                            return const Image(
                              image: errorImage,
                              width: 32,
                              height: 32,
                            );
                          }
                          uploaded = true;
                          Future.delayed(const Duration(seconds: 4), () {
                            LocalUploadManager.remove(path);
                          });
                          return const Image(
                            image: completedImage,
                            width: 32,
                            height: 32,
                          );
                        }),
                  const SizedBox(width: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
