import 'package:beatim5/screens/earphones_recommend_page.dart';
import 'package:beatim5/templates/base_layout.dart';
import 'package:beatim5/widgets/page_transition_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DataCollectAgreePage extends BaseLayout {
  @override
  String get title => 'データ収集について';

  String get explanation => '本アプリは走行データなどを取得します。プライバシーポリシーに同意していただく必要があります。';

  @override
  Widget mainContent(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: SvgPicture.asset(
          'images/privacy.svg',
          semanticsLabel: 'privacy policy',
          width: 200,
          height: 200,
        ),
      ),
    );
  }

  @override
  Widget buttomContent(BuildContext context) {
    return PageTransitionButton('同意する', () {
      Navigator.push<void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => EarphoneRecommendPage(),
        ),
      );
    });
  }
}
