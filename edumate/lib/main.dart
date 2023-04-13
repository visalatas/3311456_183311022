import 'package:edumate/helpers/base_helper.dart';
import 'package:edumate/models/student.dart';
import 'package:edumate/screens/student_add.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Student selectedStudent =Student.WithId(0, "", "lastName", 0);
  BaseHelper baseHelper= BaseHelper();

  List<Student> students = [
    Student.WithId(1, "Visal", "Ataş", 22),
    Student.WithId(2, "Adem", "Ataş", 45),
    Student.WithId(3, "Beyza", "Uzunyol", 80)
  ];
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('EDUMATE'),
        ),
        body: buildBody(context));
  }


//  void mesajGoster(BuildContext context, String mesaj) {
//     // String mesaj = sinavHesapla(puan);
//     var alert = AlertDialog(
//       title: Text('İşlem Sonucu'),
//       content: Text(mesaj),
//     );

//     showDialog(
//       context: context,
//       builder: (BuildContext context) => alert,
//     );
//   } 

  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (BuildContext, int index) {
                  return ListTile(
                    leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://cdn.pixabay.com/photo/2016/04/01/11/10/boy-1300226_960_720.png")),
                    title: Text(students[index].firstName.toString() +
                        " " +
                        students[index].lastName.toString()),
                    subtitle: Text("sınavdan aldığı not: " +
                        students[index].grade.toString() +
                        "[" +
                        students[index].getStatus.toString() +
                        "]"),
                    trailing: buildStatusIcon(students[index].grade),
                    onTap: () {
                      setState(() {
                        selectedStudent = students[index];
                      });

                      print(selectedStudent.firstName);
                    },
                  );
                })),
        Text("Seçili Öğrenci: " + selectedStudent.firstName.toString()),
        Row(children: <Widget>[
          Flexible(
            fit: FlexFit.tight,
            flex: 2,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
              ),
              child: Row(
                children: [
                  Icon(Icons.add),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text('Yeni Öğrenci'),
                ],
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>StudentAdd()));
              },
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 2,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
              ),
              child: Row(
                children: [
                  Icon(Icons.update),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text('Güncelle'),
                ],
              ),
              onPressed: () {
                var mesaj = "Güncellendi!";
                baseHelper.mesajGoster(context, mesaj);
              },
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amberAccent,
              ),
              child: Row(
                children: [
                  Icon(Icons.delete),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text('Sil'),
                ],
              ),
              onPressed: () {
                setState(() {
                students.remove(selectedStudent);
                });
                var mesaj = selectedStudent.firstName.toString()+"  Silindi!";
                baseHelper.mesajGoster(context, mesaj);
              },
            ),
          )
        ])
      ],
    );
  }

  Widget buildStatusIcon(int? grade) {
    if (grade! >= 50) {
      return Icon(Icons.done);
    } else if (grade >= 40) {
      return Icon(Icons.access_time_sharp);
    } else {
      return Icon(Icons.clear);
    }
  }
}
