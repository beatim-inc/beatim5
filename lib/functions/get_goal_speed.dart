import 'package:shared_preferences/shared_preferences.dart';

Future<double?> getGoalSpeed() async {
  double? movePace = await getMovePaceFromPreferences();

  if (movePace != null) {
    return convertMovePaceToSpeed(movePace);
  }
  return null;
}

Future<double?> getMovePaceFromPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getDouble('movePace');
}

double? convertMovePaceToSpeed(double movePace) {
  if (movePace == 0.0) {
    throw ArgumentError('movePace cannot be 0.0');
  }
  return 1000.0 / (60.0 * movePace);
}

double? convertSpeedToMovePace(double speed) {
  if (speed == 0.0) {
    throw ArgumentError('speed cannot be 0.0');
  }
  return 1000.0 / (60.0 * speed);
}