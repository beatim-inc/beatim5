import 'package:geolocator/geolocator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

class speedMeterLogManager {

  speedMeterLogManager(this.userID,this.sessionID);

  final String userID;
  final String sessionID;
  dynamic currentPosition = Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
  dynamic prePosition = Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
  double runningDistance = 0; // m
  double currentSpeed = 0; //  m/s
  List<Map> speedLog = [];
  double lowpassFilteredSpeed=0;
  double lowpassFilteredSpeedPre=0;
  double gain = 0.79915; //サンプリング周波数1,カットオフ周波数0.04wqとした


  void getSpeed()async{
    if(speedLog.length < 1800){
      prePosition = currentPosition;
      currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best
      );
      runningDistance = Geolocator.distanceBetween(
          prePosition.latitude, prePosition.longitude, currentPosition.latitude, currentPosition.longitude
      );
      currentSpeed = runningDistance;
      lowpassFilteredSpeedPre = lowpassFilteredSpeed;
      lowpassFilteredSpeed = gain*lowpassFilteredSpeedPre + (1-gain)*currentSpeed;
      speedLog.add({"time":DateTime.now().toString(),"speed":currentSpeed,"lowpassFilteredSpeed":lowpassFilteredSpeed});
      // print("${currentPosition.latitude},${currentPosition.longitude}");
      // print(currentSpeed);
    }else{
      // print("時間が経過したため速度計測を終了しました");
    }
  }

  void sendSpeedLog()async{
    final Map allSpeedLog = {"usedID":userID,"sessionID":sessionID,"speedlog":speedLog};
    final appDocDir = await getApplicationDocumentsDirectory();
    final logfile =await File("${appDocDir.path}/speedlog${sessionID}.json").create();
    final jsonText = jsonEncode(allSpeedLog);
    await logfile.writeAsString(jsonText);

    // Create the file metadata
    final metadata = SettableMetadata(contentType: "speedlog/json");

    // Create a reference to the Firebase Storage bucket
    final storageRef = FirebaseStorage.instance.ref();

    // Upload file and metadata to the path 'images/mountains.jpg'
    final uploadTask = storageRef
        .child("GpsLog/${sessionID}.json")
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