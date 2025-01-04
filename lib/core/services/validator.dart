class MyValidators {
  static String? displayNamevalidator(String? displayName) {
    if (displayName == null || displayName.isEmpty) {
      return 'Nama tampilan tidak boleh kosong';
    }
    if (displayName.length < 3 || displayName.length > 20) {
      return 'Nama tampilan harus terdiri dari 3 hingga 20 karakter';
    }

    return null; // Return null if display name is valid
  }

  static String? emailValidator(String? value) {
    if (value!.isEmpty) {
      return 'Silakan masukkan email';
    }
    if (!RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b')
        .hasMatch(value)) {
      return 'Silakan masukkan email yang valid';
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value!.isEmpty) {
      return 'Silakan masukkan kata sandi';
    }
    if (value.length < 6) {
      return 'Kata sandi minimal harus terdiri dari 6 karakter';
    }
    return null;
  }

  static String? repeatPasswordValidator({String? value, String? password}) {
    if (value != password) {
      return 'Kata sandi tidak cocok';
    }
    return null;
  }

  static String? uploadProdTexts({String? value, String? toBeReturnedString}) {
    if (value!.isEmpty) {
      return toBeReturnedString;
    }
    return null;
  }
}
