import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Kullanici {
  final String email;
  final String id;
  final String firstName;
  final String LastName;

  
//bu dokumandanuret factory yapısı kullanıcı getirildiğinde bu metot sayesinde Kullanici sınıfından bir nesne üretmesini sağlar. Böylece Kullanici nin email,id,ad ve soyad bilgilerine erişebilinir.
  factory Kullanici.dokumandanUret(DocumentSnapshot doc) {
    return Kullanici(
      doc['email'],
      doc.id,
      doc['ad'],
      doc['soyad'],
    );
  }

  Kullanici(this.email, this.id, this.firstName, this.LastName);
}

