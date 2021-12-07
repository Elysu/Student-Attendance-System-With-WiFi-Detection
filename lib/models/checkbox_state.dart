class CheckBoxState {
  String? title;
  final String subCode;
  bool value;

  CheckBoxState({ this.title, required this.subCode, this.value = false });

  String toString() {
    return '{subCode: $subCode, value: $value}';
  }
}