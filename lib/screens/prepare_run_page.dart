import 'package:beatim5/screens/shake_page.dart';
import 'package:beatim5/templates/base_layout.dart';
import 'package:beatim5/widgets/page_transition_button.dart';
import 'package:flutter/material.dart';

class PrepareRunPage extends BaseLayout {
  @override
  String get title => '準備OK?';
  String get explanation => 'スマホを手に持って準備しましょう\n下のボタンを押したらランニング開始です!';

  @override
  Widget mainContent(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
      ),
    );
  }

  @override
  Widget buttomContent(BuildContext context) {
    return PageTransitionButton(
        'START!',
            (){
          Navigator.push<void>(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const ShakePage(),
            ),
          );
        }

    );
  }
}