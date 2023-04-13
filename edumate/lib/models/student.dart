import 'dart:ffi';

class Student {
  int? id;
  String? firstName;
  String? lastName;
  int? grade;
  String? status;

  Student.WithId(int id, String firstName, String lastName, int grade) {
    this.id=id;
    this.firstName = firstName;
    this.lastName = lastName;
    this.grade = grade;
    
  }
  Student( String firstName, String lastName, int grade) {
    this.firstName = firstName;
    this.lastName = lastName;
    this.grade = grade;
    
  }
  
  String get getStatus{
     
    String message = " ";
    if (this.grade! >= 50) {
      message = 'geçti';
    } else if (this.grade! >= 40) {
      message = 'büt';
    } else {
      message = 'kaldı';
    }
    return message;
  }
}
