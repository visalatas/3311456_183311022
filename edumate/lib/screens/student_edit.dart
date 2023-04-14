import 'package:edumate/models/student.dart';
import 'package:flutter/material.dart';

import '../validation/student_validator.dart';

class StudentEdit extends StatefulWidget {
  Student selectedStudent=Student("", "", 0);
  StudentEdit(Student selectedStudent){
    this.selectedStudent=selectedStudent;

  }
  @override
  State<StatefulWidget> createState() {
    return _StudentAddState(selectedStudent);
  }
}

class _StudentAddState extends State with StudentValidationMixin {
  Student selectedStudent=Student("","",0);
  
  var formKey= GlobalKey<FormState>();
  
  _StudentAddState(Student selectedStudent){
    this.selectedStudent=selectedStudent;

  }


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Güncelle"),
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
      initialValue: selectedStudent.firstName,
        decoration:
            InputDecoration(labelText: "Öğrenci adı", hintText: "Visal"),
        validator: validateFirstName,
        onSaved: (String? value) {
          selectedStudent.firstName = value??selectedStudent.firstName;
        });
  }
  Widget buildLastNameField() {
    return TextFormField(
      initialValue: selectedStudent.lastName != null ? selectedStudent.lastName : null,
        decoration:
            InputDecoration(labelText: "Öğrenci soyadı", hintText: "Ataş"),
        validator: validateLastName,
        onSaved: (String? value) {
          selectedStudent.lastName = value??selectedStudent.lastName;
        });
  }
  Widget buildGradeField() {
    return TextFormField(
      initialValue: selectedStudent.grade.toString(),
        decoration:
            InputDecoration(labelText: "Notu", hintText: "50"),
        validator: validateGrade,
        onSaved: (String? value) {
          selectedStudent.grade =int.parse(value!) ;
        });
  }
  
  Widget buildSubmitButton() {
    return ElevatedButton(
      child: Text("Kaydet"),
      onPressed: (){
        if(formKey.currentState!.validate()){
          formKey.currentState!.save();
          saveStudent();
          Navigator.pop(context,selectedStudent);
        }
      },
      );

  }
  
  void saveStudent() {
    print(selectedStudent.firstName);
    print(selectedStudent.lastName);
    print(selectedStudent.grade);

  }
  
}
