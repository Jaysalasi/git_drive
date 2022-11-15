import 'package:flutter/material.dart';
import 'package:git_drive/ui/remote_view.dart';

class SearchField extends StatefulWidget {
  const SearchField({super.key});

  @override
  State<SearchField> createState() => SearchFieldState();
}

class SearchFieldState extends State<SearchField>
    with SingleTickerProviderStateMixin<SearchField> {
  late AnimationController controller;
  late Animation<double> animation;
  TextEditingController searchFieldController = TextEditingController();

  bool isEmpty() => searchFieldController.text.isEmpty;

  void show() {
    searchMode = true;
    controller.forward();
  }

  void hide() {
    searchMode = false;
    controller.reverse();
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    animation = Tween<double>(begin: 0, end: 1).animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          if (animation.value == 0.0) {
            return const SizedBox();
          }
          return FadeTransition(
            opacity: animation,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 250,
                  height: 60,
                  child: TextField(
                    controller: searchFieldController,
                    style: const TextStyle(
                      fontFamily: "Itim",
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.cyan, width: 3)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.cyan, width: 2)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.amber, width: 4)),
                      hintText: "type something here ...",
                      hintStyle: const TextStyle(
                        fontFamily: "Itim",
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: IconButton(
                    onPressed: () {
                      hide();
                      fileControlPanelKey.currentState?.rebuild();
                    },
                    icon: const Icon(
                      Icons.clear_all_rounded,
                      color: Colors.grey,
                    ),
                    splashRadius: 20,
                  ),
                ),
              ],
            ),
          );
        });
  }
}
