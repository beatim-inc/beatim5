import 'package:beatim5/templates/base_layout.dart';
import 'package:beatim5/widgets/page_transition_button.dart';
import 'package:flutter/material.dart';

class FinishRunPage extends BaseLayout {
  @override
  String get title => 'Good job on your run!';
  String get explanation => 'How was your run this time?\nFor a more satisfying running experience, we would appreciate your cooperation in completing this survey.';


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
        'Answer',
      null
    );
  }
}