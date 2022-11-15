import 'package:flutter/material.dart';
import 'package:git_drive/io/app_data_manager.dart';
import 'package:git_drive/io/git_drive_manager.dart';
import 'package:git_drive/io/github_authentication.dart';
import 'package:git_drive/io/resource_manager.dart';
import 'package:git_drive/ui/home_screen.dart';
import 'package:git_drive/ui/remote_view.dart';
import 'package:git_drive/widgets/neumorphic_button.dart';
import 'package:github/github.dart';

import '../widgets/message_box.dart';

GlobalKey<MessageBoxState> statusMessageBoxKey = GlobalKey();

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  TextEditingController tokenFieldController = TextEditingController();
  bool loggedIn = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 100),
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFA3B1C6).withOpacity(0.5),
                  blurRadius: 20,
                  offset: const Offset(20, 20),
                ),
                const BoxShadow(
                  color: Colors.white,
                  blurRadius: 20,
                  offset: Offset(-20, -20),
                ),
              ],
            ),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Hero(
                      tag: 'app-icon',
                      child: Image(
                        image: appIcon,
                        width: 220,
                        height: 220,
                      ),
                    ),
                    const Text(
                      "Git Drive",
                      style: TextStyle(
                        fontFamily: "Itim",
                        fontSize: 22,
                      ),
                    ),
                    Text(
                      "\"the opensource dropbox\"",
                      style: TextStyle(
                        fontFamily: "Itim",
                        fontSize: 16,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 100),
                    SizedBox(
                      height: 230,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: 250,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  MessageBox(
                                    key: statusMessageBoxKey,
                                    initialText:
                                        "Authenticate using your Token",
                                    textStyle: const TextStyle(
                                      fontFamily: "Itim",
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    width: 200,
                                    child: TextField(
                                      controller: tokenFieldController,
                                      obscureText: true,
                                      style: const TextStyle(
                                        fontFamily: "Itim",
                                        fontSize: 14,
                                      ),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                                color: Colors.cyan, width: 3)),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                                color: Colors.cyan, width: 2)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                                color: Colors.amber, width: 4)),
                                        hintText: "Paste your token here ...",
                                        hintStyle: const TextStyle(
                                          fontFamily: "Itim",
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const Flexible(
                                    child: Text(
                                      "\"Instantly upload your files using git and share them like never before\"",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: "Itim",
                                          fontSize: 13,
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Container(
                                width: 100,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(
                                  child: Text(
                                    "Login to GitHub",
                                    style: TextStyle(
                                        fontFamily: "Itim", fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    StatefulBuilder(builder: (context, setState) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: loggedIn
                            ? const Center(
                                key: Key('logged-in'),
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: MessageBox(
                                    initialText:
                                        "Setting up your GitHub Account for usage ...",
                                    textStyle: TextStyle(
                                        fontFamily: "Itim", fontSize: 14),
                                  ),
                                ),
                              )
                            : NeumorphicButton(
                                key: const Key('waiting-for-authentication'),
                                onPressed: () async {
                                  if (tokenFieldController.text.isEmpty) {
                                    statusMessageBoxKey.currentState
                                        ?.setMessage("Token cannot be empty!");
                                    return;
                                  }
                                  statusMessageBoxKey.currentState
                                      ?.setMessage("Authenticating 📢 ...");
                                  if (await GitHubAuthentication
                                      .loginWithGitHub(
                                          auth: Authentication.withToken(
                                              tokenFieldController.text))) {
                                    statusMessageBoxKey.currentState
                                        ?.setMessage(
                                            "Authentication Successful ✅");
                                    await prefs.setBool('logged-in', true);
                                    await prefs.setString(
                                        'token', tokenFieldController.text);
                                    setState(() {
                                      loggedIn = true;
                                    });
                                    Future.delayed(
                                      const Duration(seconds: 2),
                                      () async {
                                        statusMessageBoxKey.currentState
                                            ?.setMessage(
                                                "Initializing Working Repo Repository ...");
                                        if (await GitDriveManager
                                            .initializeWorkingRepo()) {
                                          statusMessageBoxKey.currentState
                                              ?.setMessage("All Set! 😉");
                                          Future.delayed(
                                              const Duration(seconds: 1), () {
                                            statusMessageBoxKey.currentState
                                                ?.setMessage("Launching 🚀");
                                            Future.delayed(
                                                const Duration(seconds: 1), () {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const HomeScreen()));
                                            });
                                          });
                                        }
                                      },
                                    );
                                  } else {
                                    statusMessageBoxKey.currentState
                                        ?.setMessage("Authentication Failed ❌");
                                  }
                                },
                                width: 120,
                                height: 40,
                                radius: 10,
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                    fontFamily: "Itim",
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                      );
                    })
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
