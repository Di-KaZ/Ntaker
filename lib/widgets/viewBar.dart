import 'package:flutter/material.dart';

class ViewBar extends StatelessWidget {
  final List<String> options;
  final String selectedOption;
  final Function(String option) handleSelectOpetion;

  const ViewBar(
      {Key? key,
      required this.options,
      required this.selectedOption,
      required this.handleSelectOpetion})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(50, 20, 50, 20),
      decoration: const BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: options
            .map((opt) => Container(
                margin: const EdgeInsets.all(5),
                child: TextButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                            const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)))),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.fromLTRB(35, 15, 35, 15)),
                        backgroundColor: MaterialStateProperty.all(
                            selectedOption == opt
                                ? Colors.black
                                : Colors.transparent),
                        foregroundColor: MaterialStateProperty.all(
                            selectedOption == opt
                                ? Colors.white
                                : Colors.grey)),
                    onPressed: () => handleSelectOpetion(opt),
                    child: Text(opt))))
            .toList(),
      ),
    );
  }
}
