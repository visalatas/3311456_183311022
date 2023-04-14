import 'package:edumate/models/student.dart';
import 'package:flutter/material.dart';

import '../validation/student_validator.dart';

class StudentAdd extends StatefulWidget {
  List<Student> students= [];
  StudentAdd(List<Student> students){
    this.students=students;

  }
  @override
  State<StatefulWidget> createState() {
    return _StudentAddState(students);
  }
}

class _StudentAddState extends State with StudentValidationMixin {
  List<Student> students=[];
  var student = Student.withoutInfo();
  var formKey= GlobalKey<FormState>();
  
  _StudentAddState(List<Student> students){
    this.students=students;

  }


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Öğrenci Ekle"),
        ),
        body: Container(
          margin: EdgeInsets.all(20.0),
          child: Form(
              key: formKey,
              child: Column(
            children: <Widget>[
              buildFirstNameField(),
              buildLastNameField(),
              buildGradeField(),
              buildSubmitButton(),
              ],
          )),
        ));
  }

  Widget buildFirstNameField() {
    return TextFormField(
        decoration:
            InputDecoration(labelText: "Öğrenci adı", hintText: "Visal"),
        validator: validateFirstName,
        onSaved: (String? value) {
          student.firstName = value??student.firstName;
        });
  }
  Widget buildLastNameField() {
    return TextFormField(
        decoration:
            InputDecoration(labelText: "Öğrenci soyadı", hintText: "Ataş"),
        validator: validateLastName,
        onSaved: (String? value) {
          student.lastName = value??student.lastName;
        });
  }
  Widget buildGradeField() {
    return TextFormField(
        decoration:
            InputDecoration(labelText: "Notu", hintText: "50"),
        validator: validateGrade,
        onSaved: (String? value) {
          student.grade =int.parse(value!) ;
        });
  }
  
  Widget buildSubmitButton() {
    return ElevatedButton(
      child: Text("Kaydet"),
      onPressed: (){
        print(students);
        if(formKey.currentState!.validate()){
          formKey.currentState!.save();
          students.add(student);
          saveStudent();
          Navigator.pop(context,students);
        }
      },
      );

  }
  
  void saveStudent() {
    print(student.firstName);
    print(student.lastName);
    print(student.grade);

  }
  
}
