//import 'dart:ffi';



class Student {
 int? id;
 late String firstName;
 late String lastName;
 late int grade;
 
 

  
  Student({ required this.firstName, required this.lastName, this.grade=0});
  Student.withId({required this.id, required this.firstName, required this.lastName, this.grade=0});

  Student.withoutInfo();

  get status => null;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'grade': grade,
      
    };
  }
  
factory Student.fromMap( dynamic map) {
    return Student.withId(
      id: map['id'] ,
      firstName: map['firstName'],
      lastName: map['lastName'],
      grade: map['grade'],
      
      
    );
  }

  String get getStatus{
     
    String message = " ";
    if (grade >= 50) {
      message = 'geçti';
    } else if (grade >= 40) {
      message = 'büt';
    } else {
      message = 'kaldı';
    }
    return message;
  }
}
