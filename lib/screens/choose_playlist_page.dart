import 'package:beatim5/models/music_data.dart';
import 'package:beatim5/screens/shake_page.dart';
import 'package:beatim5/widgets/header.dart';
import 'package:beatim5/widgets/page_transition_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:beatim5/models/download_status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:beatim5/models/download_status.dart';

import '../widgets/download_button.dart';

List downloadStatus = [
  DownloadStatus.notDownloaded,
  DownloadStatus.notDownloaded
];

class ChoosePlaylistPage extends StatefulWidget {
  const ChoosePlaylistPage({Key? key}) : super(key: key);

  @override
  State<ChoosePlaylistPage> createState() => _ChoosePlaylistPageState();
}

class _ChoosePlaylistPageState extends State<ChoosePlaylistPage> {
  // int selectedPlaylistIndex = -1;

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
                          itemCount: MusicPlaylist.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Radio(
                                    //   value: index,
                                    //   groupValue: selectedPlaylistIndex,
                                    //   onChanged: (int? value) {
                                    //     setState(() {
                                    //       selectedPlaylistIndex = value!;
                                    //     });
                                    //   },
                                    // ),
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
                                            "Title $index",
                                            style: const TextStyle(
                                              fontSize: 24,
                                            ),
                                          ),
                                          const Text("Subtitle"),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    DownloadButton(DownloadStatus.notDownloaded,
                                        () {
                                      downloadMusicFromFirebase(index);
                                    }, null),
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
                downloadStatus.contains(DownloadStatus.downloaded)
                    ? () {
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const ShakePage(),
                          ),
                        );
                      }
                    //  のちにnullに変更
                    : () {
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const ShakePage(),
                          ),
                        );
                      }),
          )
        ],
      ),
    );
  }
}

void downloadMusicFromFirebase(int playlistNumber) async {
  final storageRef = FirebaseStorage.instance.ref('128_long_BPM124.mp3');

  final appDocDir = await getApplicationDocumentsDirectory();
  final filePath = "${appDocDir.path}/128_long_BPM124.mp3";
  print(filePath);
  musics[0] = filePath;
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
        downloadStatus[playlistNumber] = DownloadStatus.downloaded;
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
      }
    },
    onError: (e) => print("Error completing: $e"),
  );
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
