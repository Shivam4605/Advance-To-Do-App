import 'package:shared_preferences/shared_preferences.dart';

class UserController {
  String email = "";
  String password = "";
  bool isloggedin = false;

  // using the shared Preferences Set the Data for All field of the class

  // setData
  Future<void> setSharedpreferenced(Map<String, dynamic> obj) async {
    SharedPreferences sharedPreferencesobj =
        await SharedPreferences.getInstance();

    await sharedPreferencesobj.setString("email", obj['email']);
    await sharedPreferencesobj.setString("password", obj['password']);
    await sharedPreferencesobj.setBool("isloggedin", obj['isloggedin']);
  }

  //Getdata

  Future<void> getSharedpreferenced() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    email = sharedPreferences.getString("email") ?? "";
    password = sharedPreferences.getString("password") ?? "";
    isloggedin = sharedPreferences.getBool("isloggedin") ?? false;
  }
}
