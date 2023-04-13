import 'package:flutter/material.dart';

class BaseHelper {

  void mesajGoster(BuildContext context, String mesaj, [String title ='İşlem Sonucu']) {

    var alert = AlertDialog(
      title: Text(title),
      content: Text(mesaj),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) => alert,
    );
  }
}
