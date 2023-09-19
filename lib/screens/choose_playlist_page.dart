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

int selectedPlaylist = -1;

class ChoosePlaylistPage extends StatefulWidget {
  const ChoosePlaylistPage({Key? key}) : super(key: key);

  @override
  State<ChoosePlaylistPage> createState() => _ChoosePlaylistPageState();
}

class _ChoosePlaylistPageState extends State<ChoosePlaylistPage> {
  Color pageTransitionButtonColor = Colors.grey;
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
                  '再生楽曲の選択',
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
                  '走りに利用する音楽をダウンロードしてください',
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
                          itemCount: MusicPlaylistMetadataCollection.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Radio(value: index,
                                        groupValue: selectedPlaylist,
                                        onChanged: (value) {
                                          setState(() {
                                            if (value == null) {
                                              selectedPlaylist = -1;
                                              pageTransitionButtonColor = Colors.grey;
                                            } else {
                                              selectedPlaylist = value;
                                              pageTransitionButtonColor = Colors.orange;
                                            }
                                          });
                                        }),
                                    SizedBox(
                                      width: 200,
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            MusicPlaylistMetadataCollection[index].title,
                                            style: const TextStyle(
                                              fontSize: 24,
                                            ),
                                          ),
                                          Text(MusicPlaylistMetadataCollection[index].subTitle),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    SvgPicture.asset(
                                      'images/playlist.svg',
                                      semanticsLabel: 'Music Playlist',
                                      width: 80,
                                      height: 80,
                                    ),
                                    const SizedBox(width: 10),
                                  ],
                                ),
                              ],
                            );
                          });
                    }
                  })),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: SizedBox(
              height: 58,
              width:224,
              child: ElevatedButton(
                  child: Text('ダウンロード',style: TextStyle(fontSize: 24),),
                  style: ElevatedButton.styleFrom(backgroundColor: pageTransitionButtonColor),
                  onPressed: ()async{
                      if(selectedPlaylist != -1) {
                        generateMusicPlaylist();
                        print(MusicPlaylist);
                        int i;
                        for(i=0; i < MusicPlaylist.length; i++){
                          await downloadMusicFromFirebase(MusicPlaylist[i].fileName);
                        }
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
            ),
          )
        ],
      ),
    );
  }
}

void generateMusicPlaylist(){
  int i;
  for (i = 0; i < MusicPlaylistMetadataCollection[selectedPlaylist].music.length; i++) {
    int j;
    for (j = 0; j<MusicMetadataCollection.length; j++){
      if (MusicPlaylistMetadataCollection[selectedPlaylist].music[i] == MusicMetadataCollection[j].displayName) {
        MusicPlaylist.add(MusicMetadataCollection[j]);
      }
    }
  }
}

Future<void> downloadMusicFromFirebase(String filenameOfPlaylist) async {
  final storageRef = FirebaseStorage.instance.ref(filenameOfPlaylist);

  final appDocDir = await getApplicationDocumentsDirectory();
  final filePath = "${appDocDir.path}/${filenameOfPlaylist}";
  musicFilePath = appDocDir.path;
  //print(musicFilePath);
  filenameOfPlaylist=filePath;
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

Future<String> fetchMusicInfoAndMusicPlayListsFromFireStore() async {
  if(MusicPlaylistMetadataCollection.length ==0) {
    var db1 = FirebaseFirestore.instance;
    db1.collection("MusicInfo").get().then(
          (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          //print('${docSnapshot.id} => ${docSnapshot.data()}');
          Map musicData = docSnapshot.data();
          MusicMetadataCollection.add(MusicMetadata(musicData['bpm'], musicData['displayName'], musicData['fileName']));
        }
        //print(MusicMetadataCollection);
      },
      onError: (e) => print("Error completing: $e"),
    );
    var db2 = FirebaseFirestore.instance;
    await db2.collection("MusicPlaylists").get().then(
          (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          //print('${docSnapshot.id} => ${docSnapshot.data()}');
          Map data = docSnapshot.data();
          MusicPlaylistMetadataCollection.add(MusicPlaylistMetadata(
              data['Title'], data['Subtitle'], List.generate(data.length-2, (index) => data['music${index+1}'])));
        }
        //print(MusicPlaylistMetadataCollection);
      },
      onError: (e) => print("Error completing: $e"),
    );
  }
  return "loading playlists";
}
