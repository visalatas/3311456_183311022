import 'package:edumate/models/student.dart';
import 'package:flutter/material.dart';

import '../data/dbHelper.dart';
import '../validation/student_validator.dart';

class StudentAdd extends StatefulWidget {
  DbHelper db = DbHelper();

  @override
  State<StatefulWidget> createState() {
    return StudentAddState();
  }
}

class StudentAddState extends State<StudentAdd> with StudentValidationMixin {
  var txtName = TextEditingController();
  var txtLastName = TextEditingController();
  var txtGrade = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Öğrenci Ekle"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              buildNameField(),
              buildLastNameField(),
              buildGradeField(),
              buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNameField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Öğrenci adı"),
      controller: txtName,
      validator: validateFirstName,
    );
  }

  Widget buildLastNameField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Soyadı"),
      controller: txtLastName,
      validator: validateLastName,
    );
  }

  Widget buildGradeField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Notu"),
      controller: txtGrade,
      validator: validateGrade,
    );
  }

  Widget buildSaveButton() {
    return ElevatedButton(
      child: const Text("Ekle"),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          addStudent();
        }
      },
    );
  }

  void addStudent() async {
    await DbHelper().open();
    String firstName = txtName.text;
    String lastName = txtLastName.text;
    int grade = int.tryParse(txtGrade.text) ?? 0;
    Student student = Student(
      firstName: firstName,
      lastName: lastName,
      grade: grade,
    );
    await DbHelper().insertStudent(student);

    // ignore: use_build_context_synchronously
    Navigator.pop(context, true);
  }
}

  
  



















// class StudentAdd extends StatefulWidget {
  

//   }
//   @override
//   State<StatefulWidget> createState() {
//     return _StudentAddState();
//   }
// }

// class _StudentAddState extends State with StudentValidationMixin {
//   List<Student> students=[];
//   var student = Student.withoutInfo();
//   var formKey= GlobalKey<FormState>();
  
//   _StudentAddState(List<Student> students){
//     this.students=students;

//   }


  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("Öğrenci Ekle"),
//         ),
//         body: Container(
//           margin: EdgeInsets.all(20.0),
//           child: Form(
//               key: formKey,
//               child: Column(
//             children: <Widget>[
//               buildFirstNameField(),
//               buildLastNameField(),
//               buildGradeField(),
//               buildSubmitButton(),
//               ],
//           )),
//         ));
//   }

//   Widget buildFirstNameField() {
//     return TextFormField(
//         decoration:
//             InputDecoration(labelText: "Öğrenci adı", hintText: "Visal"),
//         validator: validateFirstName,
//         onSaved: (String? value) {
//           student.firstName = value??student.firstName;
//         });
//   }
//   Widget buildLastNameField() {
//     return TextFormField(
//         decoration:
//             InputDecoration(labelText: "Öğrenci soyadı", hintText: "Ataş"),
//         validator: validateLastName,
//         onSaved: (String? value) {
//           student.lastName = value??student.lastName;
//         });
//   }
//   Widget buildGradeField() {
//     return TextFormField(
//         decoration:
//             InputDecoration(labelText: "Notu", hintText: "50"),
//         validator: validateGrade,
//         onSaved: (String? value) {
//           student.grade =int.parse(value!) ;
//         });
//   }
  
//   Widget buildSubmitButton() {
//     return ElevatedButton(
//       child: Text("Kaydet"),
//       onPressed: (){
//         print(students);
//         if(formKey.currentState!.validate()){
//           formKey.currentState!.save();
//           students.add(student);
//           saveStudent();
//           Navigator.pop(context,students);
//         }
//       },
//       );

//   }
  
//   void saveStudent() {
//     print(student.firstName);
//     print(student.lastName);
//     print(student.grade);

//   }
  
// }
