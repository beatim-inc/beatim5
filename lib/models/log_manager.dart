class logManager {

  logManager(this.userID,this.sessionID);

  final String userID;
  final String sessionID;

  List<Map>logDatas = [];

  void logTimeSeriesDatas(nowTime,gyroX,gyroY,gyroZ,gyro,gyroFiltered,acceleX,acceleY,acceleZ,isStepTime,playbackBpm){
    logDatas.add(
      {
      "time": nowTime,
      "gyroX": gyroX,
      "gyroY": gyroY,
      "gyroZ": gyroZ,
      "gyroNorm": gyro[1],
      "gyroFiltered": gyroFiltered[1],
      "acceleX": acceleX,
      "acceleY": acceleY,
      "acceleZ": acceleZ,
      "isStepTime": isStepTime,
      "playbackBpm": playbackBpm,
      }
    );
  }
  void printLogForDebug(){
    print(userID);
    print(sessionID);
    print(logDatas);
  }

}