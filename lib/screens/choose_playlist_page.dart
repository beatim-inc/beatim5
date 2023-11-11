import 'package:beatim5/models/music_metadata.dart';
import 'package:beatim5/models/music_playlist_metadata.dart';
import 'package:beatim5/providers/musicfile_path.dart';
import 'package:beatim5/screens/shake_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  List<MusicPlaylistMetadata> musicPlaylistMetadataCollection = [];
  List<MusicMetadata> musicMetadataCollection = [];

  bool isLoadingMusicData = true;
  int currentCarouselIndex = 0;

  Future<void> _downloadAndNavigate(BuildContext context) async {
    // ダウンロード処理
    await generateMusicPlaylist(musicPlaylistMetadataCollection,
        musicMetadataCollection, currentCarouselIndex);
    // ダウンロードが完了したら画面遷移
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ShakePage(),
      ),
    );
  }

    @override
    void initState() {
      super.initState();
      initializeMusicMetadataCollectionAndMusicPlaylistMetadataCollection(
          musicPlaylistMetadataCollection, musicMetadataCollection)
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
          toolbarHeight: 0.0, // カスタムの高さを指定
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 50),
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
              height: 300,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
                : SizedBox(
              height: 300,
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
                    child: Padding(
                        padding:
                        const EdgeInsets.only(bottom: 30.0, top: 20.0),
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              musicPlaylistMetadata.title,
                              style: const TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                          subtitle: Text(
                            musicPlaylistMetadata.subTitle,
                            style: const TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        )),
                  );
                },
                options: CarouselOptions(
                  height: 300.0,
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
              padding: const EdgeInsets.only(top: 20.0),
              child: SizedBox(
                height: 58,
                width: 224,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(),
                    onPressed: (){_downloadAndNavigate(context);},
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

  Future<void> generateMusicPlaylist(musicPlaylistMetadataCollection,
      musicMetadataCollection, currentCarouselIndex) async {
    _addMusicPlaylistMetadataToMusicPlaylist(musicPlaylistMetadataCollection,
        musicMetadataCollection, currentCarouselIndex);
    int i;
    for (i = 0; i < musicPlaylist.length; i++) {
      await _downloadMusicFromFirebase(musicPlaylist[i].fileName);
    }
  }

  void _addMusicPlaylistMetadataToMusicPlaylist(musicPlaylistMetadataCollection,
      musicMetadataCollection, currentCarouselIndex) {
    int i;
    for (i = 0;
    i <
        musicPlaylistMetadataCollection[currentCarouselIndex]
            .musicName
            .length;
    i++) {
      int j;
      for (j = 0; j < musicMetadataCollection.length; j++) {
        if (musicPlaylistMetadataCollection[currentCarouselIndex]
            .musicName[i] ==
            musicMetadataCollection[j].displayName) {
          musicPlaylist.add(musicMetadataCollection[j]);
        }
      }
    }
  }

  Future<void> _downloadMusicFromFirebase(String filenameOfPlaylist) async {
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
        // debugPrint('downloading');
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

  Future<void>
  initializeMusicMetadataCollectionAndMusicPlaylistMetadataCollection(
      musicPlaylistMetadataCollection, musicMetadataCollection) async {
    await _initializeMusicInfoFromFireStore(musicMetadataCollection);
    await _initializeMusicPlayListsFromFireStore(
        musicPlaylistMetadataCollection);
  }

  Future<void> _initializeMusicInfoFromFireStore(
      musicMetadataCollection) async {
    // 音楽情報をFireStoreから取得し初期化する
    // ただし楽曲データそのものはダウンロードせず、あくまでMetadataのみをダウンロードする

    var db = FirebaseFirestore.instance;
    await db.collection("MusicInfo").get().then(
          (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          Map musicData = docSnapshot.data();
          musicMetadataCollection.add(MusicMetadata(
              musicData['bpm'], musicData['displayName'],
              musicData['fileName']));
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  Future<void> _initializeMusicPlayListsFromFireStore(
      musicPlaylistMetadataCollection) async {
    // プレイリスト情報をFireStoreから取得し初期化する
    // ただしプレイリストに含まれた楽曲データなどはダウンロードせず、あくまでMetadataのみをダウンロードする

    var db = FirebaseFirestore.instance;
    await db.collection("MusicPlaylists").get().then(
          (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          Map data = docSnapshot.data();
          musicPlaylistMetadataCollection.add(MusicPlaylistMetadata(
              data['Title'],
              data['Subtitle'],
              List.generate(
                  data.length - 2, (index) => data['music${index + 1}'])));
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
  }