import 'package:flutter/material.dart';

import '../data/dbHelper.dart';
import '../models/student.dart';
import '../validation/student_validator.dart';

// ignore: must_be_immutable
class StudentDetail extends StatefulWidget {
  DbHelper db = DbHelper();
  Student student;
  StudentDetail(this.student, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _StudentDetailState(student);
  }
}

enum Options { delete, update }

class _StudentDetailState extends State<StudentDetail>
    with StudentValidationMixin {
  Student student;
  _StudentDetailState(this.student);
  var txtName = TextEditingController();
  var txtLastName = TextEditingController();
  var txtGrade = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    txtName.text = student.firstName;
    txtLastName.text = student.lastName;
    txtGrade.text = student.grade.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ürün detayı: ${student.firstName} ${student.lastName}"),
        actions: <Widget>[
          PopupMenuButton<Options>(
            onSelected: selectProcess,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Options>>[
              const PopupMenuItem<Options>(
                value: Options.delete,
                child: Text("sil"),
              ),
              const PopupMenuItem<Options>(
                value: Options.update,
                child: Text("güncelle"),
              ),
            ],
          )
        ],
      ),
      body: buildStudentDetail(),
    );
  }

  buildStudentDetail() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            buildNameField(),
            buildLastNameField(),
            buildGradeField(),
          ],
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

 void selectProcess(Options options) async {
  switch (options) {
    case Options.delete:
      await widget.db.deleteStudent(student.id!);
      Navigator.pop(context, true);
      break;
    case Options.update:
      int? id = student.id;
      if (id != null) {
        await widget.db.updateStudent(Student.withId(
          id: id,
          firstName: txtName.text,
          lastName: txtLastName.text,
          grade: int.tryParse(txtGrade.text) ?? 0,
        ));
        Navigator.pop(context, true);
      }
      break;
    default:
  }
}
}
