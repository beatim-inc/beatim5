import 'package:geolocator/geolocator.dart';

class speedMeter {

  dynamic currentPosition = Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
  dynamic prePosition = Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
  double runningDistance = 0; // m
  double currentSpeed = 0; //  m/s

  void getSpeed()async{
    prePosition = currentPosition;
    currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    runningDistance = Geolocator.distanceBetween(
        prePosition.latitude, prePosition.longitude, currentPosition.latitude, currentPosition.longitude);
    currentSpeed = runningDistance;
    print("${currentPosition.latitude},${currentPosition.longitude}");
    print(currentSpeed);
  }
}