import 'package:beatim5/screens/data_collect_agree_page.dart';
import 'package:beatim5/screens/earphones_recommend_page.dart';
import 'package:beatim5/templates/base_layout.dart';
import 'package:beatim5/widgets/page_transition_button.dart';
import 'package:flutter/material.dart';

class WelcomePage extends BaseLayout {
  @override
  String get title => 'Beatim Runner';

  String get explanation => 'ベータ版';

  @override
  Widget mainContent(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Image.asset(
          'images/logo.png',
          width: 300,
          height: 300,
        ),
      ),
    );
  }

  @override
  Widget buttomContent(BuildContext context) {
    return PageTransitionButton(
      '始める',
      () {
        Navigator.push<void>(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => DataCollectAgreePage(),
            ));
      },
    );
  }
}
