import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:git_drive/io/app_data_manager.dart';
import 'package:git_drive/io/resource_manager.dart';
import 'package:git_drive/startup.dart';
import 'package:git_drive/ui/remote_view.dart';
import 'package:git_drive/widgets/remote_file_tile.dart';

GlobalKey<ContentPaneState> contentPaneKey = GlobalKey();

final ReceivePort _port = ReceivePort();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initAppResources();
  await FlutterDownloader.initialize(debug: false, ignoreSsl: false);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          backgroundColor: backgroundColor,
          body: ContentPane(),
        ),
      ),
    );
  }
}

class ContentPane extends StatefulWidget {
  const ContentPane({super.key});

  @override
  State<ContentPane> createState() => ContentPaneState();
}

class ContentPaneState extends State<ContentPane> {
  rebuild() => setState(() {});

  static void manageDownload(id, status, progress) {
    if (status == DownloadTaskStatus.complete) {
      downloadQueue.putIfAbsent(id, () => false);
    } else if (status == DownloadTaskStatus.failed) {
      downloadQueue.putIfAbsent(id, () => false);
    }
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: backgroundColor,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarColor: backgroundColor,
        statusBarIconBrightness: Brightness.dark,
      ));
    });
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {});
    FlutterDownloader.registerCallback(manageDownload);
    super.initState();
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Startup.getInitialView();
  }
}
