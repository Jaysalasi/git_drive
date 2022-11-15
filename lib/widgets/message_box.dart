import 'package:flutter/cupertino.dart';

class MessageBox extends StatefulWidget {
  final String initialText;
  final TextStyle textStyle;

  const MessageBox(
      {super.key, required this.initialText, required this.textStyle});

  @override
  State<MessageBox> createState() => MessageBoxState();
}

class MessageBoxState extends State<MessageBox> {
  String text = '';

  @override
  void initState() {
    text = widget.initialText;
    super.initState();
  }

  setMessage(String text) {
    setState(() {
      this.text = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: widget.textStyle,
    );
  }
}
