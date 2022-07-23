import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class NewNoteButton extends StatelessWidget {
  final void Function() onPressed;
  const NewNoteButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50), color: Colors.black),
        child: IconButton(
            onPressed: onPressed,
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            )));
  }
}
