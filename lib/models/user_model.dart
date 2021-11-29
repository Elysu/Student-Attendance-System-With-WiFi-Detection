class UserModel {
  static String? uid;
  static String? deviceID;
  static String? email;
  static String? id;
  static String? name;
  static bool? isTeacher;
  static List<String>? subjects;

  String get getUID {
    return uid!;
  }

  String get getDeviceID {
    return deviceID!;
  }

  String get getEmail {
    return email!;
  }

  String get getID {
    return id!;
  }

  String get getName {
    return name!;
  }

  bool get getTeacher {
    return isTeacher!;
  }

  List<String> get getSubjects {
    return subjects!;
  }

  void setData(String strUID, String strDeviceID, String strEmail, String strID, String strName, bool boolIsTeacher, dynamic listSubjects) {
    uid = strUID;
    deviceID = strDeviceID;
    email = strEmail;
    id = strID;
    name = strName;
    isTeacher = boolIsTeacher;
    subjects = List.from(listSubjects);
  }
}