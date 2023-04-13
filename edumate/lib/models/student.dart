import 'dart:ffi';

class Student {
  String? firstName;
  String? lastName;
  int? grade;
  String? status;

  Student(String firstName, String lastName, int grade) {
    this.firstName = firstName;
    this.lastName = lastName;
    this.grade = grade;
    this.status = 'gecti';
  }
}
