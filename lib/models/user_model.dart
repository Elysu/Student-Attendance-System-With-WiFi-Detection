class UserModel {
  static String? uid;
  static bool? isTeacher;

  String get getUID {
    return uid!;
  }

  bool get getTeacher {
    return isTeacher!;
  }

  set setUID(String userID) {
    if (userID is Null) {
      throw new ArgumentError();
    }

    uid = userID;
  }

  set setTeacher(bool teacher) {
    if (teacher is Null) {
      throw new ArgumentError();
    }

    isTeacher = teacher;
  }
}