import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user.dart';


class FirestoreService {
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  final DateTime zaman = DateTime.now();

 
  Future<void> createUser({
    id,
    ad,
    soyad,
    email,
    sifre,
  }) async {
    await _firestore.collection("kullanicilar").doc(id).set({
      "ad": ad,
      "soyad": soyad,
      "email": email,
      "sifre": sifre,
      "olusturulmazamani": zaman
    });
  }

 
  Future<Kullanici> getUser(id) async {
    DocumentSnapshot doc =
        await _firestore.collection("kullanicilar").doc(id).get();
    if (doc.exists) {
      Kullanici kullanici = Kullanici.dokumandanUret(doc);
      return kullanici;
    }
    return Kullanici("email", "id", "ad", "soyad");
  }


}
