import 'package:beatim5/models/musicdata.dart';
import 'package:beatim5/screens/choose_playlist_page.dart';
import 'package:beatim5/templates/base_layout.dart';
import 'package:beatim5/widgets/page_transition_button.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:beatim5/models/musicdata.dart';

class EarphoneRecommendPage extends BaseLayout {
  @override
  String get title => 'Use Earphones';
  String get explanation => 'For the best experience, we suggest using earphones while using this app.';


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
        'OK',
      (){
        DLMusicInfoFromFireStore();
        DLMusicPlayListsFromFireStore();
        debugPrint(playlistName[0]);
        debugPrint(playlistExplanation[0]);
        Navigator.push<void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => ChoosePlaylistPage(),
          ),
        );
      }

    );
  }
}

int DLMusicInfoFromFireStore(){
  var db1 = FirebaseFirestore.instance;
  db1.collection("MusicInfo").get().then(
        (querySnapshot) {
      print("Successfully completed");
      for (var docSnapshot in querySnapshot.docs) {
        print('${docSnapshot.id} => ${docSnapshot.data()}');
      }
    },
    onError: (e) => print("Error completing: $e"),
  );
  return 0;
}

int DLMusicPlayListsFromFireStore() {
  var db2 = FirebaseFirestore.instance;
  List<List<String>> playlistDisplayContents = [];
  db2.collection("MusicPlaylists").get().then(
        (querySnapshot) {
      print("Successfully completed");
      for (var docSnapshot in querySnapshot.docs) {
        print('${docSnapshot.id} => ${docSnapshot.data()}');
        playlistName.add(docSnapshot.id);
        playlistExplanation.add('${docSnapshot.data()}');
      }
    },
    onError: (e) => print("Error completing: $e"),
  );
  return 0;
}