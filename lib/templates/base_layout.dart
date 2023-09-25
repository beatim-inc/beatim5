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
        toolbarHeight: 0.0, // カスタムの高さを指定
        // leading: IconButton(
        //   icon: SvgPicture.asset(
        //     'images/home.svg',
        //     semanticsLabel: 'Go to Top page',
        //     width: 20,
        //     height: 20,
        //   ),
        //   onPressed: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => WelcomePage()),
        //     );
        //   },
        // ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50),
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
          SizedBox(height: 300, child: mainContent(context)),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: buttomContent(context),
          )
        ],
      ),
    );
  }
}
