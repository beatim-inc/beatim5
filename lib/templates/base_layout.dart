import 'package:flutter/material.dart';

abstract class BaseLayout extends StatelessWidget {
  // それぞれの継承クラスが上書きするべきメソッド
  String get title;
  String get explanation;
  Widget mainContent(BuildContext context);
  String get buttonlabel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top:30),
            child: Container(
              width: 352,
              height: 52,
                child: Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:14),
            child: Container(
              width: 280,
              height: 83,
                child: Center(
                    child: Text(
                      explanation,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ),
            ),
          ),
          Container(
            height: 400,
              child: mainContent(context)),
          Padding(
            padding: const EdgeInsets.only(top:10.0),
            child: SizedBox(
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
            ),
          )
        ],
      ),
    );
  }
}