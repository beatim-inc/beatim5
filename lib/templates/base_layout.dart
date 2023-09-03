import 'package:beatim5/screens/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

abstract class BaseLayout extends StatelessWidget {
  // それぞれの継承クラスが上書きするべきメソッド

  String get title;

  String get explanation;

  Widget mainContent(BuildContext context);

  Widget buttomContent(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: SvgPicture.asset(
            'images/home.svg',
            semanticsLabel: 'Go to Top page',
            width: 20,
            height: 20,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WelcomePage()),
            );
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: SizedBox(
              width: 352,
              // explanation SizedBox の Width が 83　なので 52, 135
              height: explanation != "" ? 52 : 135,
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
            padding: const EdgeInsets.only(top: 14),
            child: explanation != ""
                ? SizedBox(
                    width: 280,
                    height: 83,
                    child: Center(
                      child: Text(
                        explanation,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                : null,
          ),
          SizedBox(height: 400, child: mainContent(context)),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: buttomContent(context),
          )
        ],
      ),
    );
  }
}
