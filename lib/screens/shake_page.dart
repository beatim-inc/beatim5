import 'dart:async';
import 'dart:math';

import 'package:beatim5/screens/run_page.dart';
import 'package:beatim5/templates/base_layout.dart';
import 'package:beatim5/widgets/counter_display.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:sensors/sensors.dart';

class ShakePage extends StatefulWidget {
  const ShakePage({super.key});

  @override
  _ShakePageState createState() => _ShakePageState();
}

class _ShakePageState extends State<ShakePage> {
  double playbackBpm = 0.0;

  /* ステップセンシング関係の変数 - START */
  double gyrox = 0, gyroy = 0, gyroz = 0;
  List<double> gyro = [0, 0, 0];
  int dtMs = 10; // センシングのサンプリング間隔(ms)
  double cutoffFrequencyHz = 0.8; // カットオフ周波数(Hz)
  double tauSec = 1; // 時定数
  double gain = 0.5; // ローパスフィルターのゲイン. initState()で初期化する
  List<double> gyroFiltered = [0, 0, 0];
  List<double> preGyroMormalized = [0, 0, 1]; // 正規化した角速度ベクトル. ステップ取得時に更新
  double hurdolRadpersec = 2.5;
  final List<int> _intervals = List.filled(16, 0);
  int preStepTime = 0,
      intervalMin = 200,
      intervalMax = 750,
      nowTime = 0,
      counter = 0;
  /* ステップセンシング関係の変数 - END */

  /* ボタン関連の変数 - START */
  Timer? _buttonPressedTimer;
  /* ボタン関連の変数 - END */

  Timer? _timer;

  /* ステップセンシング関係の関数  - START */
  @override
  void initState() {
    super.initState();

    // 時定数とゲインの初期化
    tauSec = 1.0 / (2 * 3.1415926535 * cutoffFrequencyHz);
    gain = tauSec / (dtMs / 1000 + tauSec);

    gyroscopeEvents.listen(
      (GyroscopeEvent event) {
        """
      ジャイロセンサからデータがきたら変数(gyrox, gyroy, gyroz)にストックする
      """;
        setState(() {
          gyrox = event.x;
          gyroy = event.y;
          gyroz = event.z;
        });
      },
    );

    Timer.periodic(Duration(milliseconds: dtMs), (Timer timer) {
      """
      サンプリング間隔ごとに, ステップ検出, データ送信, データ保存を行う
      """;
      getStep();
      if (playbackBpm != 0.0) {
        timer.cancel();
      }
      // sendSensorData();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void getStep() {
    """
    1. 角速度の取得
    2. ローパスフィルターをかける
    3. ステップ検知の条件を満たす時, ステップ間隔を更新する
    4. カウンターが満たされたら, BPMの再設定を行う
    5. BPMに大きな変動があれば, プレイリストを再構築する
    """;

    //角速度ベクトルのノルム
    double getNorm(double x, double y, double z) {
      return pow((pow(x, 2) + pow(y, 2) + pow(z, 2)), 0.5).toDouble();
    }

    double gyroNorm = getNorm(gyrox, gyroy, gyroz);

    // 前回のステップからの角速度ベクトルの向きの変化量(0~2)を取得
    List<double> gyroNormalized = [
      gyrox / gyroNorm,
      gyroy / gyroNorm,
      gyroz / gyroNorm
    ];
    double directionChangeX = gyroNormalized[0] - preGyroMormalized[0];
    double directionChangeY = gyroNormalized[1] - preGyroMormalized[1];
    double directionChangeZ = gyroNormalized[2] - preGyroMormalized[2];
    double directionChange =
        getNorm(directionChangeX, directionChangeY, directionChangeZ);

    // 角速度ベクトルのノルムをストック
    gyro[2] = gyro[1];
    gyro[1] = gyro[0];
    gyro[0] = gyroNorm;

    // ローパスフィルターをかけた角速度
    gyroFiltered[2] = gyroFiltered[1];
    gyroFiltered[1] = gyroFiltered[0];
    gyroFiltered[0] = gain * gyroFiltered[1] + (1 - gain) * gyro[0];

    //ストップウォッチ動かしてからの時間
    nowTime = DateTime.now().millisecondsSinceEpoch;

    // 前回のステップからの経過時間が十分時間が経っていたらカウンターをリセット
    if (nowTime - preStepTime > intervalMax) {
      counter = 0;
    }

    /*
      ステップの条件：
      1.角速度の絶対値が一定より大きい
      2.極大値を取る
      3.前回のステップから回転方向が90°以上変わっている(正規ベクトルの変化は√2より大きくなる)
      4.前回のステップから一定時間以上経っている
    */
    if (gyroFiltered[1] > hurdolRadpersec &&
        gyroFiltered[1] > gyroFiltered[2] &&
        gyroFiltered[0] < gyroFiltered[1] &&
        directionChange > 1.41421356 &&
        nowTime - preStepTime > intervalMin) {
      HapticFeedback.heavyImpact();
      // 正規化した角速度ベクトルを更新
      for (int i = 0; i < 3; i++) {
        preGyroMormalized[i] = gyroNormalized[i];
      }
      // ステップ間隔を記録
      _intervals[counter] = nowTime - preStepTime;
      preStepTime = nowTime;
      counter++;

      // カウンターが溜まったらBPMを修正する
      if (counter == _intervals.length) {
        playbackBpm = calcBpmFromIntervals(_intervals);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RunPage(playbackBpm: playbackBpm),
          ),
        );

        counter = 0;
      }
    }
  }

  double calcBpmFromIntervals(List<int> intervals) {
    """
    ステップ間隔からBPMを算出する
    """;
    List<double> intervalPairs = List.filled(intervals.length ~/ 2, 0);
    for (int i = 0; i < intervalPairs.length; i++) {
      intervalPairs[i] = (intervals[i * 2] + intervals[i * 2 + 1]) / 2;
    }
    double aveInterval = (intervalPairs.reduce((a, b) => a + b) -
            intervalPairs.reduce(max) -
            intervalPairs.reduce(min)) /
        (intervalPairs.length - 2);
    double runningBPM = 60.0 / (aveInterval / 1000);
    return runningBPM;
  }

  // void reconnectWebsocket() {
  //   """
  //   再接続ボタンを押した際にWebSocketへの再接続する
  //   """;
  //   websocketChannel = IOWebSocketChannel.connect('ws://$websocketAddress:$websocketPort');
  // }
  //
  // void sendSensorData() {
  //   """
  //   websocketでセンサーデータを送信
  //   """;
  //   final data = {
  //     'gyro': gyro[1],
  //     'gyroFiltered': gyroFiltered[1],
  //     'gyrox': gyrox,
  //     'gyroy': gyroy,
  //     'gyroz': gyroz,
  //   };
  //   final jsonString = json.encode(data);
  //   websocketChannel?.sink.add(jsonString);
  // }
  //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'BPM ${playbackBpm.round()}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  '$counter / ${_intervals.length}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            )
          ],
        ),
      )
    );
  }
}

// class ShakePage extends BaseLayout {
//   @override
//   String get title => 'Shake your arms!';
//   String get explanation => 'Start running\nGrip your smartphone and start swinging your arm\nMusic automatically starts.';
//
//   @override
//   Widget mainContent(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(40.0),
//         child: Image.asset('images/logo.png'),
//       ),
//     );
//   }
//
//   @override
//   Widget buttomContent(BuildContext context){
//     return const CounterDisplay(
//       10, //counter
//       20, //max_count
//     );
//   }
// }
