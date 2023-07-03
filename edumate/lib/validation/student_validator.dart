class StudentValidationMixin {

  String? validateFirstName(String? value) {
  if (value == null || value.isEmpty) {
    return "isim giriniz";
  } else if (value.length < 2) {
    return "isim en az iki karakter";
  } else {
    return null;
  }
}

String? validateLastName(String? value) {
  if (value == null || value.isEmpty) {
    return "isim giriniz";
  } else if (value.length < 2) {
    return "isim en az iki karakter";
  } else {
    return null;
  }
}

String? validateGrade(String? value) {
  var grade= int.parse(value!);
  if (grade<0 || grade>100) {
    return "not 0 ile 100 arasında olmalıdır";
  }
  return null;
}
}
