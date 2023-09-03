import 'package:beatim5/templates/base_layout.dart';
import 'package:beatim5/widgets/page_transition_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../functions/get_or_generate_user_id.dart';

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
    return PageTransitionButton(
      '回答する',
      () {
        getOrGenerateUserId().then((userId) {
          final url = Uri.parse('https://docs.google.com/forms/d/e/1FAIpQLScvgQVnoyl9ko-K-U7SDx2eN7Pi_HQaDypuy10stb3TqpRCig/viewform?usp=pp_url&entry.530414108=$userId');
          launchUrl(url);
        });
      },
    );
  }
}
