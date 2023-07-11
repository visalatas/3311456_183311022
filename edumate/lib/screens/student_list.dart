

import 'package:edumate/models/user.dart';
import 'package:edumate/screens/info_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../data/dbHelper.dart';
import '../models/student.dart';
import '../screens/student_add.dart';
import '../screens/student_detail.dart';
// ignore: unused_import
import 'package:http/http.dart' as http;

class StudentList extends StatefulWidget {
  final Kullanici kullanici;
  const StudentList({Key? key, required this.kullanici}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _StudentListState();
  }
}

class _StudentListState extends State<StudentList> {
  DbHelper db = DbHelper();
  List<Student> students = [];
  List<Student> studentsApi = [];
  int studentCount = 0;

  @override
  void initState() {
    super.initState();
    getStudents();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Öğrenci Listesi"),
          actions: [
            IconButton(
                onPressed: goToInfoPage,
                icon: const Icon(
                  Icons.info_outline_rounded,
                )),
            IconButton(
                onPressed: signOut,
                icon: const Icon(
                  Icons.exit_to_app,
                ))
          ],
        ),
        body: buildStudentList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            goToStudentAdd(context);
          },
          tooltip: "Yeni Öğrenci Ekle",
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
    Navigator.pop(context);
  }

  ListView buildStudentList() {
    return ListView.builder(
      itemCount: studentCount,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.cyan,
          elevation: 0.2,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.black12,
              child: Text(students[position].grade.toString()),
            ),
            title: Text(
                "${students[position].firstName} ${students[position].lastName}"),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  db.deleteStudent(students[position].id!);
                  getStudents();
                });
              },
            ),
            subtitle: Text(students[position].getStatus),
            onTap: () {
              goToStudentDetails(students[position]);
            },
          ),
        );
      },
    );
  }

  goToStudentDetails(Student student) async {
    bool? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentDetail(student),
      ),
    );
    if (result != null && result) {
      getStudents();
    }
  }

  goToStudentAdd(BuildContext context) async {
    bool? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: ((context) => StudentAdd())),
    );
    if (result != null && result) {
      getStudents();
    }
  }

  void goToInfoPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const InfoPage(),
        ));
  }

  getStudents() async {
    await db.open();
    List<Student> data = await db.getStudents();

    setState(() {
      students = data;
      studentCount = data.length;
    });
  }
}
