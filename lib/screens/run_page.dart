import 'package:beatim5/models/speed_meter_log_manager.dart';
import 'package:beatim5/providers/musicfile_path.dart';
import 'package:beatim5/screens/finish_run_page.dart';
import 'package:beatim5/screens/shake_page.dart';
import 'package:beatim5/widgets/page_transition_button.dart';
import 'package:beatim5/models/music_metadata.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';

import '../functions/get_goal_speed.dart';
import '../functions/get_or_generate_user_id.dart';

class RunPage extends StatefulWidget {
  double playbackBpm;

  RunPage({required this.playbackBpm});

  @override
  _RunPageState createState() => _RunPageState(playbackBpm: playbackBpm);
}

class _RunPageState extends State<RunPage> {
  double playbackBpm;

  _RunPageState({required this.playbackBpm});

  AudioPlayer player = AudioPlayer();
  speedMeterLogManager? speedMeterLog;

  double? goalSpeed;

  double changeSpeedHurdle = 0.1;
  double changeHighSpeedHurdle = 0.2;

  bool isPaceControllActive = true;

  _initializeGoalSpeed() async {
    goalSpeed = await getGoalSpeed();
    setState(() {});
  }

  String speedMessage = '頑張って！';

  void generateMusicPlaylist() {
    // ランダム再生を可能にする
    musicPlaylist.shuffle();

    final musicPlayQueue = ConcatenatingAudioSource(
      useLazyPreparation: true,
      children: List.generate(
          musicPlaylist.length,
          (index) => AudioSource.file(
              '${musicFilePath}/${musicPlaylist[index].fileName}')),
    );
    player.setAudioSource(musicPlayQueue,
        initialIndex: 0, initialPosition: Duration.zero);
    player.setLoopMode(LoopMode.all);
  }

  void adjustSpeed() {
    player.setSpeed(playbackBpm / musicPlaylist[player.currentIndex ?? 0].bpm);
  }

  @override
  void initState() {
    super.initState();

    _initializeGoalSpeed();

    getOrGenerateUserId().then((userId) {
      //ログの生成
      speedMeterLog = speedMeterLogManager(userId, DateTime.now().toString());
    });

    generateMusicPlaylist();
    player.play();
    adjustSpeed();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        speedMeterLog?.getSpeed();
      });
    });
    Timer.periodic(const Duration(seconds: 10), (timer) {
      setState(() {
        if(isPaceControllActive){
          if(((goalSpeed! -changeHighSpeedHurdle) < (speedMeterLog?.lowpassFilteredSpeed ?? goalSpeed)!)
          && ((speedMeterLog?.lowpassFilteredSpeed ?? goalSpeed)! < (goalSpeed! - changeSpeedHurdle))
          ){
            playbackBpm += 1;
            adjustSpeed();
            setState(() {
              speedMessage = 'ペースをちょっと速くしています！';
            });
          }else if(((goalSpeed! -changeSpeedHurdle) < (speedMeterLog?.lowpassFilteredSpeed ?? goalSpeed)!)
          && ((speedMeterLog?.lowpassFilteredSpeed ?? goalSpeed)! < (goalSpeed! - changeHighSpeedHurdle))){
            playbackBpm -= 1;
            adjustSpeed();
            setState(() {
              speedMessage = 'ペースをちょっと遅くしています！';
            });
          } else{
            adjustSpeed();
            setState(() {
              speedMessage = 'ペースいい感じ!';
            });
          }
        }else{
          setState(() {
            speedMessage = 'BPM自動調整機能がOFFです';
          });
        }

      });
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 0.0, 
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 100,
              ),
              const Text(
                '今のBPM',
                style: TextStyle(fontSize: 30),
              ),
              Text(
                '${playbackBpm.round()}',
                style: const TextStyle(
                  fontSize: 120,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                speedMessage,
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                "平均ストライド:${((speedMeterLog?.currentSpeed ?? 0) / (playbackBpm/60)).toStringAsFixed(1)}m",
                style: const TextStyle(fontSize: 20)
              ),
              StreamBuilder(
                  stream: player.currentIndexStream,
                  builder:
                      (BuildContext context, AsyncSnapshot<int?> snapshot) {
                    adjustSpeed();
                    return const SizedBox(
                      height: 10,
                    );
                  }),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: SizedBox(
                  width: 250,
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            player.seekToPrevious();
                          });
                        },
                        icon: Icon(Icons.fast_rewind),
                        iconSize: 60.0,
                      ),
                      StreamBuilder<PlayerState>(
                        stream: player.playerStateStream,
                        builder: (context, snapshot) {
                          final playerState = snapshot.data;
                          final playing = playerState?.playing;
                          if (playing != true) {
                            return IconButton(
                              icon: const Icon(Icons.play_arrow),
                              iconSize: 64.0,
                              onPressed: () {
                                setState(() {
                                  player.play();
                                });
                              },
                              color: Colors.black,
                            );
                          } else {
                            return IconButton(
                              icon: const Icon(Icons.pause),
                              iconSize: 64.0,
                              onPressed: () {
                                setState(() {
                                  player.pause();
                                });
                              },
                              color: Colors.black,
                            );
                          }
                        },
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            player.seekToNext();
                          });
                        },
                        icon: Icon(Icons.fast_forward),
                        iconSize: 60.0,
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('BPM自動調整機能'),
                    Switch(
                        value: isPaceControllActive,
                        onChanged: (value){
                          setState(() {
                            isPaceControllActive != isPaceControllActive;
                            isPaceControllActive = value;
                          });
                        }
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: PageTransitionButton('BPMを再設定', () {
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
