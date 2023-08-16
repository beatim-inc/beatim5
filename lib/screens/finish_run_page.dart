import 'package:beatim5/templates/base_layout.dart';
import 'package:beatim5/widgets/page_transition_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FinishRunPage extends BaseLayout {
  @override
  String get title => 'お疲れ様でした！';
  String get explanation => 'リズムは合っていましたか？アンケートへのご協力お願いします。';

  @override
  Widget mainContent(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: SvgPicture.asset(
          'images/thumbs-up.svg',
          semanticsLabel: 'Shake Smartphone',
          width: 200,
          height: 200,
        ),
      ),
    );
  }

  @override
  Widget buttomContent(BuildContext context) {
    return const PageTransitionButton(
        '回答する',
      null
    );
  }
}