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
  final double playbackBpm;

  RunPage({required this.playbackBpm});

  @override
  _RunPageState createState() => _RunPageState(playbackBpm: playbackBpm);
}

class _RunPageState extends State<RunPage> {
  final double playbackBpm;
  AudioPlayer player = AudioPlayer();

  speedMeterLogManager? speedMeterLog;

  _RunPageState({required this.playbackBpm});

  void generateMusicPlaylist() {
    final playList = ConcatenatingAudioSource(
      useLazyPreparation: true,
      children: List.generate(
          1,
          (index) => AudioSource.file(
              '${musicFilePath}/${MusicPlaylist[0].fileName}')),
    );
    player.setAudioSource(playList,
        initialIndex: 0, initialPosition: Duration.zero);
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
    player.setSpeed(playbackBpm / MusicPlaylist[0].bpm);
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        speedMeterLog?.getSpeed();
      });
    });
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
                height: 50,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 30),
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
                  padding: EdgeInsets.only(top: 14),
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
                height: 20,
              ),
              SvgPicture.asset(
                'images/exercise.svg',
                semanticsLabel: 'Running',
                width: 200,
                height: 200,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                '最適なBPM',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                '${widget.playbackBpm.round()}',
                style: Theme.of(context).textTheme.headlineLarge,
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
                  player.stop();
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
                  player.stop();
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
