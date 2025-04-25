class BabyProfile {
  static String name = '';
  static String? photoPath;
  static String birthDate = '';
  static String gender = '';
  static String fatherName = '';
  static String motherName = '';

  static void updateProfile({
    required String newName,
    String? newPhotoPath,
    required String newBirthDate,
    required String newGender,
    required String newFatherName,
    required String newMotherName,
  }) {
    name = newName;
    if (newPhotoPath != null) photoPath = newPhotoPath;
    birthDate = newBirthDate;
    gender = newGender;
    fatherName = newFatherName;
    motherName = newMotherName;
  }
}
