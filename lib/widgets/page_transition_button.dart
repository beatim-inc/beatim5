import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';

class PageTransitionButton extends StatelessWidget {

  final String buttonlabel;
  final onPressed;

  const PageTransitionButton(this.buttonlabel,this.onPressed,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaler = ScreenScaler()..init(context);
    return SizedBox(
      width: 224,
      height: 58,
      child: ElevatedButton(
        onPressed: onPressed,

        child:
        Text(
          buttonlabel,
          style: TextStyle(
              fontSize: scaler.getTextSize(15),
          ),
        ),
      ),
    );
  }
}