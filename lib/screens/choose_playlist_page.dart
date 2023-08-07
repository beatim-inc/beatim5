import 'package:beatim5/models/musicdata.dart';
import 'package:beatim5/screens/download_page.dart';
import 'package:beatim5/templates/base_layout.dart';
import 'package:beatim5/widgets/header.dart';
import 'package:beatim5/widgets/page_transition_button.dart';
import 'package:flutter/material.dart';
import 'package:beatim5/models/musicdata.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ChoosePlaylistPage extends BaseLayout {

  @override
  String get title => 'Choose a playlist';
  String get explanation => 'At this time, only the song pack below is available for use as we continue development. Thank you for your understanding.';


  @override
  Widget mainContent(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        header('images/logo.png', playlistName[0], '2.8MB', playlistExplanation[0]),
        header('images/logo.png', playlistName[1], '2.8MB', playlistExplanation[1]),
      ],
    );
  }

  @override
  Widget buttomContent(BuildContext context){
    return PageTransitionButton(
        'Download',
      (){
        DLMusicFromCloudStrage();
        Navigator.push<void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => DownloadPage(),
          ),
        );
      }
    );
  }
}

void DLMusicFromCloudStrage() async{
  final storageRef = FirebaseStorage.instance.ref('128_long_BPM124.mp3');

  final appDocDir = await getApplicationDocumentsDirectory();
  final filePath = "${appDocDir.path}/128_long_BPM124.mp3";
  print(filePath);
  final file = File(filePath);
  debugPrint('$file');

  final downloadTask = storageRef.writeToFile(file);
  downloadTask.snapshotEvents.listen((taskSnapshot) {
    switch (taskSnapshot.state) {
      case TaskState.running:
      debugPrint('running');
        break;
      case TaskState.paused:
      debugPrint('paused');
        break;
      case TaskState.success:
      debugPrint('success');
        break;
      case TaskState.canceled:
      debugPrint('canceled');
        break;
      case TaskState.error:
      debugPrint('error');
        break;
    }
  });
}