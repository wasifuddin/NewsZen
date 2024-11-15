import 'package:shared_preferences/shared_preferences.dart';

class PrefUtils{
  static SharedPreferences? _sharedPreferences;

  PrefUtils(){
    SharedPreferences.getInstance().then((value)
    {
      _sharedPreferences = value ;
    });
  }

  Future<void> init() async{
    _sharedPreferences ??= await SharedPreferences.getInstance();
  }

  void clearPreferencesData() async{
    _sharedPreferences!.clear();
  }

  static Future<void> saveLoginInfo(String phoneNumber, String password) async {
    await _sharedPreferences?.setString('phone_Number', phoneNumber);
    await _sharedPreferences?.setString('password', password);

  }
  static Future<String?> getPhoneNumber() async{
    return _sharedPreferences?.getString('phone_Number');
  }

  static Future<String?> getPassword() async{
    return _sharedPreferences?.getString('password');
  }


}
