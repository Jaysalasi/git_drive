// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:git_drive/io/git_drive_manager.dart';
import 'package:git_drive/ui/info_screen.dart';
import 'package:git_drive/ui/login_screen.dart';

import '../io/app_data_manager.dart';
import '../io/resource_manager.dart';
import '../widgets/neumorphic_button.dart';
import '../widgets/search_field.dart';
import 'file_control_panel.dart';

GlobalKey<FileControlPanelState> fileControlPanelKey = GlobalKey();
GlobalKey<FilterButtonState> filterButtonKey = GlobalKey();
GlobalKey<SearchFieldState> searchFieldKey = GlobalKey();

var filter = "none";
var searchMode = false;

class RemoteView extends StatelessWidget {
  const RemoteView({super.key});

  showToast(icon, text, color, context) {
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
              Text(
                text,
                style: const TextStyle(
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Hero(
                      tag: 'app-icon',
                      child: Image(
                        image: appIcon,
                        width: 55,
                        height: 55,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Git Drive",
                              style: TextStyle(
                                fontFamily: 'Itim',
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(
                              width: 30,
                              height: 30,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const InfoScreen()));
                                },
                                icon: const Icon(
                                  Icons.info_outline_rounded,
                                  size: 16,
                                ),
                                splashRadius: 20,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "\"The opensource dropbox\"",
                          style: TextStyle(
                            fontFamily: 'Itim',
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const SizedBox(width: 20),
                          NeumorphicButton(
                              onPressed: () async {
                                await prefs.setBool('logged-in', false);
                                await prefs.setString('token', '');
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SafeArea(
                                            child: Scaffold(
                                                body: LoginScreen()))));
                              },
                              size: 40,
                              radius: 10,
                              borderColor: Colors.white,
                              gradient: LinearGradient(colors: [
                                Colors.grey.shade200,
                                Colors.grey.shade50
                              ]),
                              child: const Icon(
                                Icons.logout,
                              )),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
                child: Row(
                  children: [
                    Text(
                      "Your Files on GitHub",
                      style: TextStyle(
                          fontFamily: "Itim",
                          fontSize: 28,
                          color: Colors.grey.shade700),
                    ),
                    const SizedBox(width: 5),
                    FilterButton(key: filterButtonKey),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Material(
                        color: Colors.transparent,
                        child: IconButton(
                          onPressed: () async {
                            showToast(
                                const Icon(Icons.refresh, color: Colors.white),
                                "Refreshing View",
                                Colors.blue,
                                context);
                            await GitDriveManager.reloadRepoContents();
                            fileControlPanelKey.currentState?.rebuild();
                            showToast(
                                const Icon(Icons.done_all_outlined,
                                    color: Colors.white),
                                "Refreshed!",
                                Colors.blue,
                                context);
                          },
                          icon: const Icon(
                            Icons.refresh,
                            color: Colors.blue,
                          ),
                          color: Colors.cyan,
                          tooltip: 'Reload View',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 0, bottom: 20, left: 20, right: 20),
                  child: FileControlPanel(key: fileControlPanelKey),
                ),
              ),
            ],
          ),
        ),
        if (remoteFiles.isNotEmpty)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: NeumorphicButton(
                onPressed: () {
                  bool emptyField =
                      searchFieldKey.currentState?.isEmpty() as bool;
                  if (!emptyField && searchMode) {
                    fileControlPanelKey.currentState?.rebuild();
                    return;
                  }
                  if (searchMode) {
                    searchFieldKey.currentState?.hide();
                  } else {
                    searchFieldKey.currentState?.show();
                  }
                  fileControlPanelKey.currentState?.rebuild();
                },
                size: 40,
                radius: 10,
                borderColor: Colors.white,
                gradient: LinearGradient(
                    colors: [Colors.purple.shade300, Colors.blue]),
                child: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: SearchField(key: searchFieldKey),
          ),
        ),
      ],
    );
  }
}

class FilterButton extends StatefulWidget {
  const FilterButton({super.key});

  @override
  State<FilterButton> createState() => FilterButtonState();
}

class FilterButtonState extends State<FilterButton> {
  rebuild() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: Material(
        color: Colors.transparent,
        child: IconButton(
          onPressed: () {
            showFilterDialog(context);
          },
          icon: Icon(
            Icons.filter_alt_sharp,
            color: getFilterColor(filter),
          ),
          color: Colors.cyan,
          tooltip: 'Apply Filter',
        ),
      ),
    );
  }
}

Icon getIfActive(filterName) {
  if (filter == filterName) {
    return const Icon(Icons.done_all_outlined, color: Colors.white);
  }
  return Icon(Icons.check_box_outline_blank,
      color: Colors.white.withOpacity(0.6));
}

Color getFilterColor(filterName) {
  if (filterName == 'none') {
    return Colors.grey;
  } else if (filterName == 'images') {
    return Colors.amber.shade900;
  } else if (filterName == 'videos') {
    return Colors.blue;
  } else if (filterName == 'audio') {
    return Colors.purple;
  }
  return Colors.green;
}

void showFilterDialog(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.grey.withOpacity(0.4),
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Center(
        child: SizedBox(
          width: 210,
          height: 350,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 210,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FilterChip(
                            label: const Text(
                              "None",
                              style: TextStyle(
                                  fontFamily: "Itim",
                                  fontSize: 14,
                                  color: Colors.white),
                            ),
                            backgroundColor: Colors.grey,
                            avatar: getIfActive('none'),
                            onSelected: (bool value) {
                              filter = "none";
                              filterButtonKey.currentState?.rebuild();
                              Navigator.pop(context);
                              fileControlPanelKey.currentState?.rebuild();
                            },
                          ),
                          FilterChip(
                            label: const Text(
                              "Only Images",
                              style: TextStyle(
                                  fontFamily: "Itim",
                                  fontSize: 14,
                                  color: Colors.white),
                            ),
                            backgroundColor: Colors.amber.shade900,
                            avatar: getIfActive('images'),
                            onSelected: (bool value) {
                              filter = "images";
                              filterButtonKey.currentState?.rebuild();
                              Navigator.pop(context);
                              fileControlPanelKey.currentState?.rebuild();
                            },
                          ),
                          FilterChip(
                            label: const Text(
                              "Only Videos",
                              style: TextStyle(
                                  fontFamily: "Itim",
                                  fontSize: 14,
                                  color: Colors.white),
                            ),
                            checkmarkColor: Colors.white,
                            backgroundColor: Colors.blue,
                            avatar: getIfActive('videos'),
                            onSelected: (bool value) {
                              filter = "videos";
                              filterButtonKey.currentState?.rebuild();
                              Navigator.pop(context);
                              fileControlPanelKey.currentState?.rebuild();
                            },
                          ),
                          FilterChip(
                            label: const Text(
                              "Only Audio",
                              style: TextStyle(
                                  fontFamily: "Itim",
                                  fontSize: 14,
                                  color: Colors.white),
                            ),
                            backgroundColor: Colors.purple,
                            avatar: getIfActive('audio'),
                            onSelected: (bool value) {
                              filter = "audio";
                              filterButtonKey.currentState?.rebuild();
                              Navigator.pop(context);
                              fileControlPanelKey.currentState?.rebuild();
                            },
                          ),
                          FilterChip(
                            label: const Text(
                              "Only Documents",
                              style: TextStyle(
                                  fontFamily: "Itim",
                                  fontSize: 14,
                                  color: Colors.white),
                            ),
                            backgroundColor: Colors.green,
                            avatar: getIfActive('documents'),
                            onSelected: (bool value) {
                              filter = "documents";
                              filterButtonKey.currentState?.rebuild();
                              Navigator.pop(context);
                              fileControlPanelKey.currentState?.rebuild();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Material(
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          "Select Filter",
                          style: TextStyle(
                              fontFamily: "Itim",
                              fontSize: 16,
                              color: Colors.grey.shade800),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      Tween<Offset> tween;
      if (anim.status == AnimationStatus.reverse) {
        tween = Tween(begin: const Offset(-1, 0), end: Offset.zero);
      } else {
        tween = Tween(begin: const Offset(1, 0), end: Offset.zero);
      }
      return SlideTransition(
        position: tween.animate(anim),
        child: FadeTransition(
          opacity: anim,
          child: child,
        ),
      );
    },
  );
}
