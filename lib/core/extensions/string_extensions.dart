extension StringExtensions on String {
  bool get isEmail {
    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return regex.hasMatch(this);
  }
}
