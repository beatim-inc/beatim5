import 'package:beatim5/templates/base_layout.dart';
import 'package:beatim5/widgets/counter_display.dart';
import 'package:flutter/material.dart';

class ShakePage extends BaseLayout {
  @override
  String get title => 'Shake your arms!';
  String get explanation => 'Start running\nGrip your smartphone and start swinging your arm\nMusic automatically starts.';

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
    return CounterDisplay(
      10, //counter
      20, //max_count
    );
  }

}