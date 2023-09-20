import 'package:beatim5/screens/welcome_page.dart';
import 'package:beatim5/templates/base_layout.dart';
import 'package:beatim5/widgets/page_transition_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../functions/get_or_generate_user_id.dart';

class FinishRunPage extends StatelessWidget {
  const FinishRunPage({Key? key}) : super(key: key);

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
          const Padding(
            padding: EdgeInsets.only(top: 30),
            child: SizedBox(
              width: 352,
              // explanation SizedBox の Width が 83　なので 52, 135
              height: 135,
              child: Center(
                child: Text(
                  'お疲れ様でした！',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 14),
            child:SizedBox(
              width: 280,
              height: 83,
              child: Center(
                child: Text(
                  'リズムは合っていましたか？アンケートへのご協力お願いします。',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ),
          SizedBox(height: 300, child:Padding(
            padding: const EdgeInsets.all(40.0),
            child: SvgPicture.asset(
              'images/thumbs-up.svg',
              semanticsLabel: 'Shake Smartphone',
              width: 200,
              height: 200,
            ),
          ),),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child:Column(
              children: [
                PageTransitionButton(
                  '回答する',
                      () {
                    getOrGenerateUserId().then((userId) {
                      final url = Uri.parse('https://docs.google.com/forms/d/e/1FAIpQLScvgQVnoyl9ko-K-U7SDx2eN7Pi_HQaDypuy10stb3TqpRCig/viewform?usp=pp_url&entry.530414108=$userId');
                      launchUrl(url);
                    });
                  },
                ),
                PageTransitionButton(
                  '最初の画面へ',
                      (){
                    Navigator.push<void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => WelcomePage(),
                        ));
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );;
  }
}