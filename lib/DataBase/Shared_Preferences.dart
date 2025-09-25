import 'package:shared_preferences/shared_preferences.dart';

class UserController {
  String username = "";
  String email = "";
  String password = "";
  bool isloggedin = false;

  // using the shared Preferences Set the Data for All field of the class

  ///[setData]
  Future<void> setSharedpreferenced(Map<String, dynamic> obj) async {
    SharedPreferences sharedPreferencesobj =
        await SharedPreferences.getInstance();
    await sharedPreferencesobj.setString("username", obj['username']);
    await sharedPreferencesobj.setString("email", obj['email']);
    await sharedPreferencesobj.setString("password", obj['password']);
    await sharedPreferencesobj.setBool("isloggedin", obj['isloggedin']);
  }

  ///[Getdata]
  Future<bool> getSharedpreferenced() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    username = sharedPreferences.getString("username") ?? "";
    email = sharedPreferences.getString("email") ?? "";
    password = sharedPreferences.getString("password") ?? "";
    isloggedin = sharedPreferences.getBool("isloggedin") ?? false;

    return isloggedin;
  }
}
