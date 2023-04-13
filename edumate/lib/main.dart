import 'package:edumate/models/student.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  List<Student> students = [
    Student("Visal", "Ataş", 22),
    Student("Adem", "Ataş", 45),
    Student("Beyza", "Uzunyol", 80)
  ];
  var ogrenciler = ['visal', 'beyza', 'nafiye'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('EDUMATE'),
        ),
        body: buildBody(context));
  }

  String sinavHesapla(int puan) {
    String mesaj = " ";
    if (puan >= 50) {
      mesaj = 'geçti';
    } else if (puan >= 40) {
      mesaj = 'büt';
    } else {
      mesaj = 'kaldı';
    }
    return mesaj;
  }

  void mesajGoster(BuildContext context, String mesaj) {
    // String mesaj = sinavHesapla(puan);
    var alert = AlertDialog(
      title: Text('sınav sonucu'),
      content: Text(mesaj),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) => alert,
    );
  }

  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (BuildContext, int index) {
                  return ListTile(
                    leading: CircleAvatar(backgroundImage: NetworkImage("https://cdn.pixabay.com/photo/2016/04/01/11/10/boy-1300226_960_720.png")),
                    title: Text(students[index].firstName.toString() +
                        " " +
                        students[index].lastName.toString()),
                    subtitle: Text("sınavdan aldığı not: " +
                        students[index].grade.toString()),
                    trailing: buildStatusIcon(students[index].grade),
                    onTap: () {
                      print(students[index].firstName.toString() +
                        " " +
                        students[index].lastName.toString());
                    },
                  );
                })),
        Center(
          child: ElevatedButton(
            child: Text('sonuç'),
            onPressed: () {
              var mesaj = sinavHesapla(55);
              mesajGoster(context, mesaj);
            },
          ),
        ),
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
