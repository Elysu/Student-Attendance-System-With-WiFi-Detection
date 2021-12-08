class CheckBoxState {
  String? title;
  final String subCode;
  bool value;

  CheckBoxState({ this.title, required this.subCode, required this.value });

  String toString() {
    return '{subCode: $subCode, value: $value}';
  }
}