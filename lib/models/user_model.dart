class UserModel {
  static String? uid;
  static String? email;
  static String? id;
  static String? name;
  static String? currentDeviceID;
  static String? lastDeviceID;
  static bool? isTeacher;
  static List subjects = [];

  String get getUID {
    return uid!;
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

  List get getSubjects {
    return subjects;
  }

  void setData(String strUID, String strCurrentDeviceID, String strLastDeviceID, String strEmail, String strID, String strName, bool boolIsTeacher, dynamic listSubjects) {
    uid = strUID;
    currentDeviceID = strCurrentDeviceID;
    strLastDeviceID = strLastDeviceID;
    email = strEmail;
    id = strID;
    name = strName;
    isTeacher = boolIsTeacher;
    subjects = List.from(listSubjects);
  }
}