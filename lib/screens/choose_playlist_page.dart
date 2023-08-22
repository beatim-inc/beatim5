import 'package:beatim5/models/music_data.dart';
import 'package:beatim5/providers/musicfile_path.dart';
import 'package:beatim5/screens/shake_page.dart';
import 'package:beatim5/widgets/page_transition_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:beatim5/models/download_status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:beatim5/models/download_status.dart';

int selectedPlaylist = -1;

class ChoosePlaylistPage extends StatefulWidget {
  const ChoosePlaylistPage({Key? key}) : super(key: key);

  @override
  State<ChoosePlaylistPage> createState() => _ChoosePlaylistPageState();
}

class _ChoosePlaylistPageState extends State<ChoosePlaylistPage> {
//  int selectedPlaylistIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 30),
            child: SizedBox(
              width: 352,
              height: 52,
              child: Center(
                child: Text(
                  'プレイリストの選択',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 14),
            child: SizedBox(
              width: 280,
              height: 83,
              child: Center(
                child: Text(
                  '走りに利用するプレイリストをダウンロードしてください',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Container(
              alignment: Alignment.center,
              height: 400,
              child: FutureBuilder<String>(
                  future: fetchMusicInfoAndMusicPlayListsFromFireStore(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      debugPrint('loading');
                      return const Text('音楽リストを取得中です...');
                    } else if (snapshot.hasError) {
                      debugPrint('error');
                      return const Text('音楽リストの取得中にエラーが発生しました');
                    } else {
                      debugPrint('completed');
                      return ListView.builder(
                          itemCount: PreparedPlaylist.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      'images/playlist.svg',
                                      semanticsLabel: 'Music Playlist',
                                      width: 80,
                                      height: 80,
                                    ),
                                    const SizedBox(width: 10),
                                    SizedBox(
                                      width: 200,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            PreparedPlaylist[index]['Title'],
                                            style: const TextStyle(
                                              fontSize: 24,
                                            ),
                                          ),
                                          Text(PreparedPlaylist[index]['Subtitle']),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      height: 50,
                                      width: 50,
                                      color: Colors.orange,
                                      child: ElevatedButton(
                                        onPressed:(){
                                          selectedPlaylist = index;
                                        },
                                        child: SvgPicture.asset(
                                          'images/download.svg',
                                            semanticsLabel: 'privacy policy',
                                          width: 30,
                                          height: 30,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          });
                    }
                  })),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: PageTransitionButton(
                '次に進む',
                (){
                    if(selectedPlaylist != -1) {
                      int i;
                      for (i = 0; i < musics.length; i++) {
                        if (musics[i]['displayName'] == PreparedPlaylist[selectedPlaylist]['music1']) {
                          RunningPlaylist.add(musics[i]);
                        }
                      }
                      print(RunningPlaylist);
                      downloadMusicFromFirebase(RunningPlaylist[0]['fileName']);
                      Navigator.push<void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                          const ShakePage(),
                        ),
                      );
                    }else{
                      null;
                    }
                  }
                ),
          )
        ],
      ),
    );
  }
}

void downloadMusicFromFirebase(String filenameOfPlaylist) async {
  final storageRef = FirebaseStorage.instance.ref(filenameOfPlaylist);

  final appDocDir = await getApplicationDocumentsDirectory();
  final filePath = "${appDocDir.path}/${filenameOfPlaylist}";
  musicFilePath = appDocDir.path;
  print(musicFilePath);
  filenameOfPlaylist=filePath;
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

Future<String> fetchMusicInfoAndMusicPlayListsFromFireStore() async {
  var db1 = FirebaseFirestore.instance;
  db1.collection("MusicInfo").get().then(
    (querySnapshot) {
      print("Successfully completed");
      for (var docSnapshot in querySnapshot.docs) {
        print('${docSnapshot.id} => ${docSnapshot.data()}');
        musics.add(docSnapshot.data());
      }
      print(musics);
    },
    onError: (e) => print("Error completing: $e"),
  );
  var db2 = FirebaseFirestore.instance;
  await db2.collection("MusicPlaylists").get().then(
    (querySnapshot) {
      print("Successfully completed");
      for (var docSnapshot in querySnapshot.docs) {
        print('${docSnapshot.id} => ${docSnapshot.data()}');
        PreparedPlaylist.add(docSnapshot.data());
      }
      print(PreparedPlaylist);
    },
    onError: (e) => print("Error completing: $e"),
  );
  return "loading playlists";
}
