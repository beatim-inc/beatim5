import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

class logManager {

  logManager(this.userID,this.sessionID);

  final String userID;
  final String sessionID;

  List<Map>logDatas = [];
  late Map AllLogDatas = {"userID":userID,"sessionID":sessionID,"logDatas":logDatas};

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

  void writeLogToJson()async{
    final appDocDir = await getApplicationDocumentsDirectory();
    final logfile =await File("${appDocDir.path}/sensorlog${sessionID}.json").create();
    final jsonText = jsonEncode(AllLogDatas);
    await logfile.writeAsString(jsonText);

    // Create the file metadata
    final metadata = SettableMetadata(contentType: "log/json");

// Create a reference to the Firebase Storage bucket
    final storageRef = FirebaseStorage.instance.ref();

// Upload file and metadata to the path 'images/mountains.jpg'
    final uploadTask = storageRef
        .child("sensorlog${sessionID}.json")
        .putFile(logfile, metadata);

// Listen for state changes, errors, and completion of the upload.
    uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          final progress =
              100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          print("Upload is $progress% complete.");
          break;
        case TaskState.paused:
          print("Upload is paused.");
          break;
        case TaskState.canceled:
          print("Upload was canceled");
          break;
        case TaskState.error:
        // Handle unsuccessful uploads
          break;
        case TaskState.success:
        // Handle successful uploads on complete
        // ...
          break;
      }
    });
  }
}