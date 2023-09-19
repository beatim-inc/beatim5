import 'package:beatim5/models/speed_meter_log_manager.dart';
import 'package:beatim5/providers/musicfile_path.dart';
import 'package:beatim5/screens/finish_run_page.dart';
import 'package:beatim5/screens/shake_page.dart';
import 'package:beatim5/widgets/page_transition_button.dart';
import 'package:beatim5/models/MusicMetadata.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';

import '../functions/get_or_generate_user_id.dart';

class RunPage extends StatefulWidget {
  double playbackBpm;

  RunPage({required this.playbackBpm});

  @override
  _RunPageState createState() => _RunPageState(playbackBpm: playbackBpm);
}

class _RunPageState extends State<RunPage> {
  double playbackBpm;
  AudioPlayer player = AudioPlayer();

  speedMeterLogManager? speedMeterLog;

  _RunPageState({required this.playbackBpm});

  double goalSpeed = 1.7;

  void generateMusicPlaylist() {
    final playList = ConcatenatingAudioSource(
      useLazyPreparation: true,
      children: List.generate(
          MusicPlaylist.length,
          (index) => AudioSource.file(
              '${musicFilePath}/${MusicPlaylist[index].fileName}')),
    );
    player.setAudioSource(playList, initialIndex: 0, initialPosition: Duration.zero);
    player.setLoopMode(LoopMode.all);
  }

  void adjustSpeed(){
    player.setSpeed(playbackBpm / MusicPlaylist[player.currentIndex ?? 0].bpm);
  }

  @override
  void initState() {
    super.initState();

    getOrGenerateUserId().then((userId) {
      //ログの生成
      speedMeterLog = speedMeterLogManager(userId, DateTime.now().toString());
    });

    generateMusicPlaylist();
    player.play();
    adjustSpeed();
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        speedMeterLog?.getSpeed();
      });
    });
    Timer.periodic(Duration(seconds: 10),(timer){
      setState((){
          if((speedMeterLog?.lowpassFilteredSpeed ?? goalSpeed) < goalSpeed -0.2){
            playbackBpm ++;
            adjustSpeed();
          }else if((speedMeterLog?.lowpassFilteredSpeed ?? goalSpeed) > goalSpeed +0.2){
            playbackBpm --;
            adjustSpeed();
          }
      });
    });
  }

  @override
  void dispose(){
    player.dispose();
    super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: SizedBox(
                  width: 352,
                  // explanation SizedBox の Width が 83　なので 52, 135
                  height: 52,
                  child: Center(
                    child: Text(
                      "走りはどうですか？",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: SizedBox(
                    width: 280,
                    height: 83,
                    child: Center(
                      child: Text(
                        "音楽の再生速度を再度変更したい、ランニングを終了する際は以下のボタンを押してください",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )),
              const SizedBox(
                height: 10,
              ),
              SvgPicture.asset(
                'images/exercise.svg',
                semanticsLabel: 'Running',
                width: 200,
                height: 200,
              ),
              const SizedBox(
                height: 10,
              ),
              StreamBuilder(
                  stream: player.currentIndexStream,
                  builder: (BuildContext context, AsyncSnapshot<int?> snapshot){
                    adjustSpeed();
                    return Text('${(player.currentIndex?? 0)+1}曲目を再生中');
                  }
              ),
              Text(
                '最適なBPM',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  /*デバッグ用BPM微減ボタン　ここから*/
                  ElevatedButton(onPressed: (){
                    setState(() {
                      playbackBpm --;
                      adjustSpeed();
                    });
                  },child: Icon(Icons.remove)),
                  /*デバッグ用BPM微減ボタン　ここまで*/

                  Text(
                    '${playbackBpm.round()}',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),

                  /*デバッグ用BPM微増ボタン　ここから*/
                  ElevatedButton(onPressed: (){
                    setState(() {
                      playbackBpm ++;
                      adjustSpeed();
                    });
                  },child: Icon(Icons.add)),
                  /*デバッグ用BPM微増ボタン　ここまで*/

                ],
              ),

              /*GPSテスト用の速度表示部分　ここから */

              Text(
                speedMeterLog != null
                    ? '${speedMeterLog!.currentSpeed.toStringAsFixed(2)}m/s'
                    : 'Loading...',
              ),

              /*GPSテスト用の速度表示部分　ここまで */

              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: PageTransitionButton('再生速度を変更', () {
                  player.dispose();
                  Navigator.push<void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => const ShakePage(),
                    ),
                  );
                }),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: PageTransitionButton('ランニング終了', () {
                  player.dispose();
                  speedMeterLog?.sendSpeedLog();
                  Navigator.push<void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => FinishRunPage(),
                    ),
                  );
                }),
              )
            ],
          ),
        ));
  }
}
