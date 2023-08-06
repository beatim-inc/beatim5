import 'package:beatim5/templates/base_layout.dart';
import 'package:beatim5/widgets/page_transition_button.dart';
import 'package:flutter/material.dart';

class DownloadPage extends BaseLayout {
  @override
  String get title => 'Downloading...';
  String get explanation => 'That’s all for preparations\nAre you ready for running?';


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
  Widget buttomContent(BuildContext context){
    return PageTransitionButton('Start Running!');
  }

}