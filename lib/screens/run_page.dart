import 'package:beatim5/screens/choose_playlist_page.dart';
import 'package:beatim5/screens/finish_run_page.dart';
import 'package:beatim5/templates/base_layout.dart';
import 'package:beatim5/widgets/music_controll_button.dart';
import 'package:beatim5/widgets/page_transition_button.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:beatim5/models/musicdata.dart';

class RunPage extends StatefulWidget {
  final double playbackBpm;

  RunPage({required this.playbackBpm});

  @override
  _RunPageState createState() => _RunPageState(playbackBpm: playbackBpm);
}

class _RunPageState extends State<RunPage> {
  final double playbackBpm;
  _RunPageState({required this.playbackBpm});

  @override
  void initState(){
    AudioPlayer player = AudioPlayer();
    final playList = ConcatenatingAudioSource(
      useLazyPreparation: true,
      children:
      List.generate(
          musics.length, (index) =>AudioSource.file(musics[index])),
    );
    player.setAudioSource(playList, initialIndex: 0, initialPosition: Duration.zero);
    player.play();
    player.setSpeed(playbackBpm/124);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Run Page'),
      ),
      body: Center(
        child: Text(
          'BPM: ${widget.playbackBpm}',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}


// class RunPage extends BaseLayout {
//
//   @override
//   String get title => 'Running !';
//   @override
//   String get explanation => 'Start running!\nGrip your smartphone and start swinging your arm\nMusic automatically starts.';
//
//   @override
//   Widget mainContent(BuildContext context) {
//     return Center(
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.fromLTRB(70.0,20.0,70.0,0.0),
//             child: Image.asset('images/logo.png'),
//           ),
//           const MusicControllButton(),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget buttomContent(BuildContext context) {
//     return Column(
//       children: [
//         PageTransitionButton(
//             'Finish Running',
//           Navigator.push<void>(
//             context,
//             MaterialPageRoute<void>(
//               builder: (BuildContext context) => FinishRunPage(),
//             ),
//           ),
//         ),
//         const SizedBox(height: 10,),
//         PageTransitionButton(
//             'Switch walking',
//             () {
//               Navigator.push<void>(
//                 context,
//                 MaterialPageRoute<void>(
//                   builder: (BuildContext context) => ChoosePlaylistPage(),
//                 ),
//               );
//             }
//         )
//       ],
//     );
//   }
// }