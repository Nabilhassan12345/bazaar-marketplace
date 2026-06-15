class Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    return null;
  }
}
