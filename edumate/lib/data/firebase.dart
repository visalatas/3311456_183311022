import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user.dart';


class FirestoreService {
  //Burada Firestore kütüphanesini _firestore değişkenine atandı.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //anlık zamanı almak için bu atama işlemi yapıldı.
  final DateTime zaman = DateTime.now();

  // Bu metot çağrıldığında aldığı id, ad,soyad,email ve sifre değerleriyle firestore database de kullanicilar koleksiyonunda kullanıcı oluşturur.
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

  //bu yapı kullaniciyi kullanicilar koleksiyonundan getirir. Bu yapı login page de mail ile giriş yaparken gereklidir.
  //mail ve sifre ile giriş yapıldığında bu giriş başarılı olursa o id ye sahip olan kullanıcının verilerini getirir
  //Böylece home page e yöneldiğinde isim soyisim anasayfada gözükür.
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
