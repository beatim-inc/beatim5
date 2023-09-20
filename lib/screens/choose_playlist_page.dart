import 'package:beatim5/models/MusicMetadata.dart';
import 'package:beatim5/models/MusicPlaylistMetadata.dart';
import 'package:beatim5/providers/musicfile_path.dart';
import 'package:beatim5/screens/shake_page.dart';
import 'package:beatim5/widgets/page_transition_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ChoosePlaylistPage extends StatefulWidget {
  const ChoosePlaylistPage({Key? key}) : super(key: key);

  @override
  State<ChoosePlaylistPage> createState() => _ChoosePlaylistPageState();
}

class _ChoosePlaylistPageState extends State<ChoosePlaylistPage> {
  Color pageTransitionButtonColor = Colors.grey;
  List<MusicPlaylistMetadata> musicPlaylistMetadataCollection = [];

  bool isLoadingMusicData = true;
  int currentCarouselIndex = 0;

  @override
  void initState() {
    super.initState();
    updateMusicInfoAndMusicPlayListsFromFireStore(
            musicPlaylistMetadataCollection)
        .then((result) {
      setState(() {
        isLoadingMusicData = false;
      });
    });
  }

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
                  '再生する楽曲の選択',
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
                  'お好きな音楽プレイリストを選択しましょう！',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          isLoadingMusicData
              ? const SizedBox(
                  height: 400,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : SizedBox(
                  height: 400,
                  child: CarouselSlider.builder(
                    itemCount: musicPlaylistMetadataCollection.length,
                    itemBuilder: (context, index, realIdx) {
                      final musicPlaylistMetadata =
                          musicPlaylistMetadataCollection[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: ListTile(
                            title: Text(musicPlaylistMetadata.title),
                            subtitle: Text(musicPlaylistMetadata.subTitle)),
                      );
                    },
                    options: CarouselOptions(
                      height: 350.0,
                      initialPage: 0,
                      enlargeCenterPage: true,
                      onPageChanged: (index, reason) {
                        setState(() {
                          currentCarouselIndex = index;
                        });
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: SizedBox(
              height: 58,
              width: 224,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: pageTransitionButtonColor),
                  onPressed: () async {
                    if (currentCarouselIndex != -1) {
                      generateMusicPlaylist(
                          musicPlaylistMetadataCollection, currentCarouselIndex);
                      int i;
                      for (i = 0; i < MusicPlaylist.length; i++) {
                        await downloadMusicFromFirebase(
                            MusicPlaylist[i].fileName);
                      }
                      Navigator.push<void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => const ShakePage(),
                        ),
                      );
                    } else {
                      null;
                    }
                  },
                  child: const Text(
                    'ダウンロード',
                    style: TextStyle(fontSize: 24),
                  )),
            ),
          )
        ],
      ),
    );
  }
}

void generateMusicPlaylist(musicPlaylistMetadataCollection, _currentIndex) {
  int i;
  for (i = 0;
      i < musicPlaylistMetadataCollection[_currentIndex].music.length;
      i++) {
    int j;
    for (j = 0; j < MusicMetadataCollection.length; j++) {
      if (musicPlaylistMetadataCollection[_currentIndex].music[i] ==
          MusicMetadataCollection[j].displayName) {
        MusicPlaylist.add(MusicMetadataCollection[j]);
      }
    }
  }
}

Future<void> downloadMusicFromFirebase(String filenameOfPlaylist) async {
  final storageRef = FirebaseStorage.instance.ref(filenameOfPlaylist);

  final appDocDir = await getApplicationDocumentsDirectory();
  final filePath = "${appDocDir.path}/$filenameOfPlaylist";
  musicFilePath = appDocDir.path;
  //print(musicFilePath);
  filenameOfPlaylist = filePath;
  final file = File(filePath);
  //debugPrint('$file');

  final downloadTask = storageRef.writeToFile(file);
  downloadTask.snapshotEvents.listen((taskSnapshot) {
    switch (taskSnapshot.state) {
      case TaskState.running:
        debugPrint('downloading');
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
  return;
}

Future<String> updateMusicInfoAndMusicPlayListsFromFireStore(
    musicPlaylistMetadataCollection) async {
  // musicPlaylistMetadataCollectionにFireStoreからダウンロードした情報を追加します
  // 副作用があるため将来的には musicPlaylistMetadataCollection の引数は削除したい

  if (musicPlaylistMetadataCollection.isEmpty) {
    var db1 = FirebaseFirestore.instance;
    db1.collection("MusicInfo").get().then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          //print('${docSnapshot.id} => ${docSnapshot.data()}');
          Map musicData = docSnapshot.data();
          MusicMetadataCollection.add(MusicMetadata(musicData['bpm'],
              musicData['displayName'], musicData['fileName']));
        }
        //print(MusicMetadataCollection);
      },
      onError: (e) => print("Error completing: $e"),
    );
    var db2 = FirebaseFirestore.instance;
    await db2.collection("MusicPlaylists").get().then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          //print('${docSnapshot.id} => ${docSnapshot.data()}');
          Map data = docSnapshot.data();
          musicPlaylistMetadataCollection.add(MusicPlaylistMetadata(
              data['Title'],
              data['Subtitle'],
              List.generate(
                  data.length - 2, (index) => data['music${index + 1}'])));
        }
        //print(MusicPlaylistMetadataCollection);
      },
      onError: (e) => print("Error completing: $e"),
    );
  }
  return "loading playlists";
}
