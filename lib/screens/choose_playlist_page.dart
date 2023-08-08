import 'package:beatim5/models/musicdata.dart';
import 'package:beatim5/screens/download_page.dart';
import 'package:beatim5/widgets/header.dart';
import 'package:beatim5/widgets/page_transition_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChoosePlaylistPage extends StatefulWidget {
  const ChoosePlaylistPage({Key? key}) : super(key: key);

  @override
  State<ChoosePlaylistPage> createState() => _ChoosePlaylistPageState();
}

class _ChoosePlaylistPageState extends State<ChoosePlaylistPage> {

  @override
  void initState(){
    super.initState();
    DLMusicInfoFromFireStore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top:30),
            child: Container(
              width: 352,
              height: 52,
              child: Center(
                child: Text(
                  'Choose a playlist',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:14),
            child: Container(
              width: 280,
              height: 83,
              child: Center(
                child: Text(
                  'At this time, only the song pack below is available for use as we continue development. Thank you for your understanding.',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Container(
              height: 400,
              child:
                  FutureBuilder<String>(
                    future:DLMusicPlayListsFromFireStore(),
                    builder: (context,snapshot){
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        debugPrint('loading');
                        return  header('images/logo.png', 'loading', '2.8MB', 'tmp');
                      } else if (snapshot.hasError) {
                        debugPrint('error');
                        return  header('images/logo.png', 'error', '2.8MB', 'tmp');
                      } else {
                        debugPrint('completed');
                        return  ListView.builder(
                          itemCount: MusicPlaylist.length,
                            itemBuilder: (BuildContext context,int index){
                            return header('images/logo.png', MusicPlaylist[index], '2.8MB', 'tmp');
                         }
                        );
                      }
                    }
                  )
          ),
          Padding(
              padding: const EdgeInsets.only(top:10.0),
              child: PageTransitionButton(
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
              ),
          )
        ],
      ),
    );;
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

void DLMusicInfoFromFireStore(){
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
  return;
}

Future<String> DLMusicPlayListsFromFireStore() async{
  var db2 = FirebaseFirestore.instance;
  await db2.collection("MusicPlaylists").get().then(
        (querySnapshot) {
      print("Successfully completed");
      for (var docSnapshot in querySnapshot.docs) {
        print('${docSnapshot.id} => ${docSnapshot.data()}');
        MusicPlaylist.add(docSnapshot.id);
      }
    },
    onError: (e) => print("Error completing: $e"),
  );
  return "loading playlists";
}