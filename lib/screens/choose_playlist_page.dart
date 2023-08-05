import 'package:beatim5/templates/base_layout.dart';
import 'package:beatim5/widgets/header.dart';
import 'package:flutter/material.dart';

class ChoosePlaylistPage extends BaseLayout {
  @override
  String get title => 'Choose a playlist';
  String get explanation => 'At this time, only the song pack below is available for use as we continue development. Thank you for your understanding.';
  String get buttonlabel => 'Download';


  @override
  Widget mainContent(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        header('images/logo.png', 'playlist2', '2.8MB', 'For Short Running'),
        header('images/logo.png', 'playlist2', '2.8MB', 'For Short Running'),
        header('images/logo.png', 'playlist2', '2.8MB', 'For Short Running'),
      ],
    );
  }
}