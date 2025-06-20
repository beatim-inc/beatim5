import 'package:beatim5/screens/set_move_pace.dart';
import 'package:beatim5/templates/base_layout.dart';
import 'package:beatim5/widgets/page_transition_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EarphoneRecommendPage extends BaseLayout {
  @override
  String get title => 'イヤホンについて';
  String get explanation => '本アプリでは音楽を聴きます。体験価値の向上のためにイヤホンやヘッドホンの着用をお願いします。';


  @override
  Widget mainContent(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SvgPicture.asset(
          'images/headphone.svg',
          semanticsLabel: 'privacy policy',
          width: 200,
          height: 200,
        ),
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
            builder: (BuildContext context) => const SetMovePacePage(),
          ),
        );
      }

    );
  }
}
