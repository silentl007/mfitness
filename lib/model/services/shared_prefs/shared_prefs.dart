import 'package:shared_preferences/shared_preferences.dart';

class PrefsHandler {
  late SharedPreferences myPrefs;
  initializePrefs() async {
    myPrefs = await SharedPreferences.getInstance();
  }

  Future<SharedPreferences> get prefInstance async {
    return myPrefs;
  }

  Future<String> get emailAddress async {
    return myPrefs.getString('emailAddress') ?? '';
  }

  Future<bool> get isLogged async {
    return myPrefs.getBool('isLogged') ?? false;
  }

  Future<String> get lastBacked async {
    return myPrefs.getString('lastBacked') ?? '';
  }

  Future<String> get name async {
    return myPrefs.getString('name') ?? '';
  }

  Future<bool> get biometric async {
    return myPrefs.getBool('biometricLogin') ?? false;
  }

  Future<bool> get notification async {
    return myPrefs.getBool('allowNotification') ?? true;
  }

  Future<bool> get showBalance async {
    return myPrefs.getBool('showBalance') ?? true;
  }

  Future<String> get profileData async {
    return myPrefs.getString('profileData') ?? '';
  }

  Future<String> get selectedInstitution async {
    return myPrefs.getString('selectedInstitution') ?? '';
  }

  Future<String> get accountType async {
    return myPrefs.getString('accountType') ?? '';
  }

  Future<String> get username async {
    return myPrefs.getString('username') ?? '';
  }

  Future<String> get id async {
    return myPrefs.getString('id') ?? '';
  }

  Future<String> get password async {
    return myPrefs.getString('password') ?? '';
  }

  Future<String> get token async {
    return myPrefs.getString('token') ?? '';
  }

  deletePrefData() {
    myPrefs.clear();
  }

  savePrefData({
    required PrefsType type,
    required String key,
    String stringValue = '',
    bool boolValue = true,
  }) {
    if (type == PrefsType.string) {
      myPrefs.setString(key, stringValue);
    } else {
      myPrefs.setBool(key, boolValue);
    }
  }
}

enum PrefsType { string, boolean }

PrefsHandler prefsHandler = PrefsHandler();
