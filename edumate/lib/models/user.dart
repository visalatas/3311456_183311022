import 'package:cloud_firestore/cloud_firestore.dart';


class Kullanici {
  final String email;
  final String id;
  final String firstName;
  final String lastName;

  

  factory Kullanici.dokumandanUret(DocumentSnapshot doc) {
    return Kullanici(
      doc['email'],
      doc.id,
      doc['ad'],
      doc['soyad'],
    );
  }

  Kullanici(this.email, this.id, this.firstName, this.lastName);
}

