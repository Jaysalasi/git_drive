import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:git_drive/io/github_authentication.dart';
import 'package:git_drive/io/resource_manager.dart';
import 'package:git_drive/ui/file_control_panel.dart';
import 'package:git_drive/ui/remote_view.dart';
import 'package:github/github.dart';

import '../widgets/remote_file_tile.dart';

List<dynamic> remoteFiles = [];

class GitDriveManager {
  static bool isFilePresentOnRemote(String path) {
    String name = path.substring(path.lastIndexOf(Platform.pathSeparator) + 1);
    for (dynamic content in remoteFiles) {
      if (content['name'] == name) {
        return true;
      }
    }
    return false;
  }

  static Future<bool> initializeWorkingRepo() async {
    Repository repo = await getWorkingRepo();
    try {
      assert(repo.name.isNotEmpty);
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }

  static Future<Repository> getWorkingRepo() async {
    GitHub gitHub = GitHubAuthentication.getGitHubInstance();
    try {
      Repository repo = await gitHub.repositories.getRepository(RepositorySlug(
          (await GitHubAuthentication.getCurrentUser()).login as String,
          'my-git-drive'));
      return repo;
    } catch (e) {
      Repository repo =
          await gitHub.repositories.createRepository(CreateRepository(
        "my-git-drive",
        description: "My Git Drive File Store",
        hasWiki: false,
        autoInit: true,
      ));
      return repo;
    }
  }

  static Future<bool> upload(String localPath) async {
    GitHub gitHub = GitHubAuthentication.getGitHubInstance();
    String fileName =
        localPath.substring(localPath.lastIndexOf(Platform.pathSeparator) + 1);
    try {
      await gitHub.repositories.createFile(
        RepositorySlug(
            await GitHubAuthentication.getCurrentUserName(), 'my-git-drive'),
        CreateFile(
            path: "${getGroupName(localPath)}/$fileName",
            branch: 'main',
            committer: CommitUser(
                await GitHubAuthentication.getCurrentUserName(),
                await GitHubAuthentication.getCurrentUserEmail()),
            content: base64.encode(await File(localPath).readAsBytes()),
            message: 'Added $fileName'),
      );
      return Future.value(true);
    } catch (e) {
      debugPrint(e.toString());
      return Future.value(false);
    }
  }

  static Future<bool> delete(dynamic content) async {
    GitHub gitHub = GitHubAuthentication.getGitHubInstance();
    String fileName = content['name'];
    try {
      await gitHub.repositories.deleteFile(
          RepositorySlug(
              await GitHubAuthentication.getCurrentUserName(), 'my-git-drive'),
          content['path'],
          "Delete $fileName",
          content['sha'],
          'main');
      remoteTileListKey.currentState?.removeItem(remoteFiles.indexOf(content),
          (context, animation) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.linear),
          child: RemoteFileTile(content: content),
        );
      });
      remoteFiles.remove(content);
      if (remoteFiles.isEmpty) {
        fileControlPanelKey.currentState?.rebuild();
      }
      return Future.value(true);
    } catch (e) {
      debugPrint(e.toString());
      return Future.value(false);
    }
  }

  static String getGroupName(String path) {
    ImageProvider image = getImage(path);
    if (image == pictureImage) {
      return 'images';
    } else if (image == videoImage) {
      return 'videos';
    } else if (image == audioImage) {
      return 'audios';
    }
    return 'documents';
  }

  static Future<void> reloadRepoContents() async {
    remoteFiles = await getRepoContents();
  }

  static Future<List<dynamic>> getRepoContents() async {
    List<dynamic> images = await getFileGroup('images/');
    List<dynamic> videos = await getFileGroup('videos/');
    List<dynamic> documents = await getFileGroup('documents/');
    return images
      ..addAll(videos)
      ..addAll(documents);
  }

  static Future<List<dynamic>> getFileGroup(String group) async {
    GitHub gitHub = GitHubAuthentication.getGitHubInstance();
    List<dynamic> contents = [];
    try {
      String request =
          '/repos/${await GitHubAuthentication.getCurrentUserName()}/my-git-drive/contents/$group';
      dynamic response = await gitHub.getJSON(request);
      if (response is List) {
        contents.addAll(response);
      } else if (response['message'] != 'Not Found') {
        contents.add(response);
      }
    } catch (e) {
      debugPrint('GitDriveManager: $group group is empty.');
    }
    return contents;
  }
}
