import 'package:beatim5/templates/base_layout.dart';
import 'package:beatim5/widgets/music_controll_button.dart';
import 'package:beatim5/widgets/page_transition_button.dart';
import 'package:flutter/material.dart';

class RunPage extends BaseLayout {
  @override
  String get title => 'Running !';
  String get explanation => 'Start running!\nGrip your smartphone and start swinging your arm\nMusic automatically starts.';


  @override
  Widget mainContent(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(70.0,20.0,70.0,0.0),
            child: Image.asset('images/logo.png'),
          ),
          MusicControllButton(),
        ],
      ),
    );
  }

  @override
  Widget buttomContent(BuildContext context) {
    return Column(
      children: [
        PageTransitionButton('Finish Running'),
        SizedBox(height: 10,),
        PageTransitionButton('Switch walking')
      ],
    );
  }
}