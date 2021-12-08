class CheckBoxState {
  final String title;
  final String subCode;
  bool value;

  CheckBoxState({ required this.title, required this.subCode, required this.value });

  String toString() {
    return '{subCode: $subCode, title: $title}';
  }
}