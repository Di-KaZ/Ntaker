import 'package:flutter/material.dart';

class NewNoteButton extends StatelessWidget {
  final void Function() onPressed;
  const NewNoteButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50), color: Colors.black),
        child: IconButton(
            iconSize: 40,
            onPressed: onPressed,
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            )));
  }
}
