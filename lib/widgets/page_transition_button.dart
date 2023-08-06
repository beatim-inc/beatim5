import 'package:flutter/material.dart';

class PageTransitionButton extends StatelessWidget {

  final String buttonlabel;

  const PageTransitionButton(this.buttonlabel,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 224,
      height: 58,
      child: ElevatedButton(
        onPressed:(){} ,
        child:
        Text(
          buttonlabel,
          style: TextStyle(
              fontSize: 24
          ),
        ),
      ),
    );
  }
}