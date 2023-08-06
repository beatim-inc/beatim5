import 'package:beatim5/screens/choose_playlist_page.dart';
import 'package:beatim5/templates/base_layout.dart';
import 'package:beatim5/widgets/page_transition_button.dart';
import 'package:flutter/material.dart';

class EarphoneRecommendPage extends BaseLayout {
  @override
  String get title => 'Use Earphones';
  String get explanation => 'For the best experience, we suggest using earphones while using this app.';


  @override
  Widget mainContent(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Image.asset('images/logo.png'),
      ),
    );
  }

  @override
  Widget buttomContent(BuildContext context) {
    return PageTransitionButton(
        'OK',
      (){
        Navigator.push<void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => ChoosePlaylistPage(),
          ),
        );
      }

    );
  }
}