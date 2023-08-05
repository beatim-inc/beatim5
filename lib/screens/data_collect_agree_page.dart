import 'package:beatim5/screens/earphones_recommend_page.dart';
import 'package:beatim5/templates/base_layout.dart';
import 'package:beatim5/widgets/page_transition_button.dart';
import 'package:flutter/material.dart';

class DataCollectAgreePage extends BaseLayout {
  @override
  String get title => 'About your running';
  String get explanation => 'Collect log\nCan you agree the privacy policy?';


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
    return PageTransitionButton('Agree');
  }
}