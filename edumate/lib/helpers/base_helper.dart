import 'package:flutter/material.dart';

class BaseHelper {
  void mesajGoster(BuildContext context, String mesaj) {
    var alert = AlertDialog(
      title: Text('İşlem Sonucu'),
      content: Text(mesaj),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) => alert,
    );
  }
}
