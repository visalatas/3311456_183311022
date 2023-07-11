import 'dart:convert';
import 'dart:io';

import 'package:edumate/models/users_api.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  String _filePath = "";
  List<UsersApi> usersApi = [];
  final url = Uri.parse('https://jsonplaceholder.typicode.com/users');

  Future<List<UsersApi>> fetchUsers() async {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      List<UsersApi> users = [];
      for (var item in jsonData) {
        users.add(UsersApi.fromJson(item));
      }
      usersApi = users;
      return users;
    } else {
      throw Exception('API verileri alınamadı.');
    }
  }

  Future<String> get _localDevicePath async {
    final devicePath = await getApplicationDocumentsDirectory();
    return devicePath.path;
  }

  Future<File> _localFile({String? path, String? type}) async {
    // ignore: no_leading_underscores_for_local_identifiers
    String _path = await _localDevicePath;

    var newPath = await Directory("$_path/$path").create();
    return File("${newPath.path}/hakkinda.$type");
  }

  Future _downloadSamplePDF() async {
    final response = await http
        .get(Uri.parse("https://metaldolap.com.tr/uploads/site/katalog.pdf"));
    if (response.statusCode == 200) {
      final file = await _localFile(path: "pdfs", type: "pdf");
      final saveFile = await file.writeAsBytes(response.bodyBytes);
      debugPrint(
          "Dosya yazma işlemi tamamlandı. Dosyanın yolu: ${saveFile.path}");
      setState(() {
        _filePath = saveFile.path;
      });
    } else {
      debugPrint(response.statusCode.toString());
    }
  }

  _openFile() async {
    final openFile = await OpenFilex.open(_filePath);
    // ignore: avoid_print
    print(openFile);
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Uygulama Hakkında"),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
                flex: 4,
                child: SizedBox(
                  width: double.infinity,
                  child: FutureBuilder<List<UsersApi>>(
                    future: fetchUsers(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<UsersApi> users = snapshot.data!;

                        return ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: CircleAvatar(
                                  backgroundColor: Colors.black12,
                                  child: Text(
                                    users[index].id.toString(),
                                    style: const TextStyle(color: Colors.black),
                                  )),
                              title: Text(users[index].name),
                              subtitle: Text(users[index].email),
                            );
                          },
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                )),
            Flexible(
              flex: 3,
              child: Column(
                children: [
                  elevatedButton(
                      "Dosyayı İndir", Icons.download, _downloadSamplePDF),
                  _filePath != ""
                      ? const Text(
                          "Dosya İndirildi!",
                          style: TextStyle(color: Colors.red),
                        )
                      : const SizedBox(),
                  elevatedButton(
                      "Dosyayı Yükle", Icons.picture_as_pdf, _openFile),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  elevatedButton(String text, IconData icon, Function() onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: SizedBox(
        height: 40,
        width: 180,
        child: ElevatedButton(
            onPressed: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(icon),
                const SizedBox(
                  width: 6,
                ),
                Text(text)
              ],
            )),
      ),
    );
  }
}


