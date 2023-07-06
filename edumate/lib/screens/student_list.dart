import 'package:edumate/models/user.dart';
import 'package:flutter/material.dart';
import '../data/dbHelper.dart';
import '../models/student.dart';
import '../screens/student_add.dart';
import '../screens/student_detail.dart';

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
        // Geri düğmesine basıldığında yapılacak işlemleri burada tanımlanabilir.
        // önceki sayfaya dönülmemesi için bu false değeri olmalıdır. Homepage den geriye gidilemeyecek. Sadece çıkış düğmesine basılınca dönülecek.
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Öğrenci Listesi"),
        ),
        body: buildStudentList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            goToStudentAdd(context);
          },
          child: Icon(Icons.add),
          tooltip: "Yeni Öğrenci Ekle",
        ),
      ),
    );
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
            title: Text(students[position].firstName +
                " " +
                students[position].lastName),
            trailing: IconButton(
              icon: Icon(Icons.delete),
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

  getStudents() async {
    await db.open();
    List<Student> data = await db.getStudents();

    setState(() {
      students = data;
      studentCount = data.length;
    });
  }
}





















// import 'package:edumate/screens/student_add.dart';
// import 'package:edumate/screens/student_detail.dart';
// import 'package:flutter/material.dart';
// //import 'package:path/path.dart ';
// import '../data/dbHelper.dart';
// import '../models/lesson.dart';
// import '../models/student.dart';

// class StudentList extends StatefulWidget {
//   const StudentList({super.key});

//   @override
//   State<StatefulWidget> createState() {
//     return _StudentListState();
//   }
// }

// class _StudentListState extends State<StudentList> {
//   DbHelper dbHelper = DbHelper.instance;
//   late List<Student> students = [];
//   int studentCount = 0;

//   @override
//   void initState() {
//     super.initState();
//     getStudents();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Öğrenci Listesi"),
//       ),
//       body: buildStudentList(),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           goToStudentAdd(context);
//         },
//         child: Icon(Icons.add),
//         tooltip: " Yeni Öğrenci Ekle",
//       ),
//     );
//   }

 
//  ListView buildStudentList() {
//   if (students.isEmpty) {
//     return ListView();
//   } else {
//     return ListView.builder(
//       itemCount: students.length,
//       itemBuilder: (BuildContext context, int position) {
//         final student = students[position];
//         return FutureBuilder<List<Lesson>>(
//           future: dbHelper.getLessons(),
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               final lessonList = snapshot.data!;
//               return Card(
//                 color: Colors.cyan,
//                 elevation: 0.2,
//                 child: ListTile(
//                   leading: const CircleAvatar(backgroundColor: Colors.black12),
//                   title: Text("${student.firstName} ${student.lastName}"),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: lessonList.map((lesson) {
//                       return Text("Ders: ${lesson.lessonName}");
//                     }).toList(),
//                   ),
//                   trailing: buildStatusIcon(student.grade),
//                   onTap: () {
//                     goToDetail(student);
//                   },
//                 ),
//               );
//             } else if (snapshot.hasError) {
//               return const Text("Ders bulunamadı");
//             } else {
//               return const CircularProgressIndicator();
//             }
//           },
//         );
//       },
//     );
//   }
// }


//   void goToStudentAdd(BuildContext context) async {
//     bool? result = await Navigator.push(
//         context, MaterialPageRoute(builder: ((context) => StudentAdd())));
//     if (result != null) {
//       if (result) {
//         getStudents();
//       }
//     }
//   }

//   // void getStudents() async {
//   //   List<Student> data = await dbHelper.getStudents();
//   //   setState(() {
//   //   students = data;
//   //   studentCount = data.length;
//   // });
//   // }
 
// Future<void> getStudents() async {
//   List<Student> data = await dbHelper.getStudents();
//   setState(() {
//     students = data;
//     studentCount = data.length;
//   });

//   for (var student in students) {
//     List<Lesson> lessons = student.lessons ?? [];

//     if (lessons.isEmpty) {
//       // Öğrencinin bağlı olduğu dersler yok
//       // İlgili işlemleri yapabilirsiniz
//     }
//   }
// }

//   Widget buildStatusIcon(int? grade) {
//     if (grade! >= 50) {
//       return const Icon(Icons.done);
//     } else if (grade >= 40) {
//       return const Icon(Icons.access_time_sharp);
//     } else {
//       return const Icon(Icons.clear);
//     }
//   }

//   void goToDetail(Student student) async {
//     bool? result = await Navigator.push<bool?>(
//       context ,
//       MaterialPageRoute(builder: (context) => StudentDetail(student)),
//     );
//     if (result != null && result) {
//       getStudents();
//     }
//   }
// }
