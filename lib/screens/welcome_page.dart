import 'package:beatim5/templates/base_layout.dart';
import 'package:flutter/material.dart';

class WelcomePage extends BaseLayout {
  @override
  String get title => 'Beatim Runner';
  String get explanation => 'Welcome';
  String get buttonlabel => 'Get Started';


  @override
  Widget mainContent(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Image.asset('images/logo.png'),
      ),
    );
  }
}