import 'package:flutter/material.dart';

class PageTransitionButton extends StatelessWidget {

  final String buttonlabel;
  final onPressed;

  const PageTransitionButton(this.buttonlabel,this.onPressed,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 224,
      height: 58,
      child: ElevatedButton(
        onPressed: onPressed,

        child:
        Text(
          buttonlabel,
          style: const TextStyle(
              fontSize: 24,
          ),
        ),
      ),
    );
  }
}