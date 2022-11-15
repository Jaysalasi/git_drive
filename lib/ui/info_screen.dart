import 'package:flutter/material.dart';
import 'package:git_drive/io/resource_manager.dart';
import 'package:git_drive/widgets/neumorphic_button.dart';
import 'package:url_launcher/url_launcher_string.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(
                    image: appIcon,
                    width: 270,
                    height: 285,
                  ),
                  const Text(
                    "Git Drive",
                    style: TextStyle(fontFamily: "Itim", fontSize: 38),
                  ),
                  Text(
                    "\"The opensource dropbox\"",
                    style: TextStyle(
                      fontFamily: 'Itim',
                      fontSize: 24,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const Text(
                    "version $version",
                    style: TextStyle(
                        fontFamily: "Itim",
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  NeumorphicButton(
                    onPressed: () async {
                      String url = "https://github.com/omegaui/git_drive";
                      if (await canLaunchUrlString(url)) {
                        launchUrlString(url);
                      }
                    },
                    size: 80,
                    radius: 20,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Image(
                        image: githubImage,
                        width: 48,
                        height: 48,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Written with ❤️ by ",
                      style: TextStyle(
                        fontFamily: "Itim",
                        color: Colors.grey.shade800,
                        fontSize: 24,
                      ),
                    ),
                    ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (bounds) => const LinearGradient(
                              colors: [Colors.red, Colors.blue, Colors.cyan])
                          .createShader(bounds),
                      child: const Text(
                        "@omegaui",
                        style: TextStyle(
                          fontFamily: "Itim",
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 3,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (bounds) => LinearGradient(colors: [
                        Colors.blue.shade700,
                        Colors.blue,
                        Colors.purple.shade700
                      ]).createShader(bounds),
                      child: const Text(
                        "github.com/omegaui/git-drive",
                        style: TextStyle(
                          fontFamily: "Itim",
                          color: Colors.white,
                          fontSize: 16,
                        ),
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
  }
}
