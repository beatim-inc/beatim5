import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

Future<String> getOrGenerateUserId() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userId = prefs.getString('user_id');
  if (userId == null) {
    var uuid = Uuid();
    userId = uuid.v4();
    prefs.setString('user_id', userId);
    print("User ID generated: $userId");
  } else {
    print("User ID has already generated: $userId");
  }
  return userId;
}
