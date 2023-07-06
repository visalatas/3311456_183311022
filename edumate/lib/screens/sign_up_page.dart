import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edumate/data/firebase.dart';
import 'package:edumate/screens/student_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../models/user.dart';
import '../utils/constants.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  //gerekli modülleri değişkenlere atadım.
  //Burada işlemleri için de firebaseAuth'a ihtiyaç vardır
  //bu ifadeler kaydol dugmesinde kullanılacaktır.
  final FirebaseAuth _firebaseauth = FirebaseAuth.instance;

  //bu değişkenler  textformfield kutularından gelen değerleri almak ve kullanmak için alındı
  late String ad, soyad, email, sifre;
  //form widgetı ile formun mevcut durumunu kontrol etmek ve verileri kaydetmek için bir key oluşturmak lazım bu atama bunun içindir
  final formKey = GlobalKey<FormState>();

  //yukleniyor animasyonu için aç kapa değişkenidir. True olunca ekranın ortasında yükleme animasyonu oluşturmak için if kontrolünde kullanılacaktır.
  bool _yukleniyor = false;
  //bu değişken textformfield için şifrenin görünür ya da gizli olması durumlarını denetlemek için kullanılacak.
  bool _sifreGizli = true;

  //Bu ifadeler validator için yani hata kontrol yeri için birbiriyle aynı mı değil mi onu kontrol etmek için oluşturuldu
  TextEditingController _sifreController = TextEditingController();
  TextEditingController _sifreTekrarController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: height * 0.36,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/waves.png'),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      height: 72,
                      width: 72,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('assets/person.png'))),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Hesap Oluştur",
                      style: Constants.titleTextStyle,
                    ),
                  ],
                ),
                Positioned(
                  top: 36,
                  left: 8,
                  child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.arrow_back,
                        size: 32,
                        color: Colors.white,
                      )),
                )
              ],
            ),
            Stack(
              children: [govde(height), _yukleniyorAnimasyonu()],
            ),
          ],
        ),
      ),
    );
  }

  Padding govde(double height) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Form(
        key: formKey,
        child: SizedBox(
          height: height * 0.55,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: height * 0.36,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: adTextField(),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Flexible(
                          child: soyadTextField(),
                        ),
                      ],
                    ),
                    Flexible(child: emailTextfield()),
                    Flexible(child: sifreTextField()),
                    Flexible(child: sifreTekrarTextField()),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: CupertinoButton(
                  color: Color.fromRGBO(52, 137, 246, 1),
                  borderRadius: BorderRadius.circular(100),
                  onPressed: kaydolDugmesi,
                  pressedOpacity: 0.5,
                  child: const Text(
                    'Kaydol',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField sifreTekrarTextField() {
    return TextFormField(
      controller: _sifreTekrarController,
      obscureText: _sifreGizli,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.key),
        prefixStyle: const TextStyle(
          color: Colors.red,
        ),
        hintText: 'Şifrenizi tekrar girin',
        hintStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(100),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      validator: (girilenDeger) {
        if (girilenDeger!.isEmpty) {
          return "Şifre bölümü boş bırakılamaz!";
        } else if (girilenDeger.trim().length < 5) {
          return "Şifre 5 karakterden fazla olmalıdır!";
        } else if (girilenDeger != _sifreController.text) {
          return "Şifreler uyuşmuyor! Kontrol ediniz.";
        }
      },
      //burada onsaved metoduna gerek yok çünkü sadece şifre tekrarı yapılıyor.
    );
  }

  TextFormField sifreTextField() {
    return TextFormField(
      controller: _sifreController,
      obscureText: _sifreGizli,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.key),
        prefixStyle: const TextStyle(
          color: Colors.red,
        ),
        hintText: 'Şifrenizi girin.',
        hintStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        suffixIcon: _sifreGizli
            ? InkWell(
                borderRadius: BorderRadius.circular(200),
                onTap: () {
                  setState(() {
                    _sifreGizli = !_sifreGizli;
                  });
                },
                child: Icon(Icons.visibility_off_rounded))
            : InkWell(
                borderRadius: BorderRadius.circular(200),
                onTap: () {
                  setState(() {
                    _sifreGizli = !_sifreGizli;
                  });
                },
                child: Icon(Icons.visibility_rounded)),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(100),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      validator: (girilenDeger) {
        if (girilenDeger!.isEmpty) {
          return "Şifre bölümü boş bırakılamaz!";
        } else if (girilenDeger.trim().length < 5) {
          return "Şifre 5 karakterden fazla olmalıdır!";
        } else if (girilenDeger != _sifreTekrarController.text) {
          return "Şifreler uyuşmuyor! Kontrol ediniz.";
        }
      },
      onSaved: (girilenDeger) => sifre = girilenDeger!,
    );
  }

  TextFormField emailTextfield() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.mail_outline_rounded),
        prefixStyle: const TextStyle(
          color: Colors.red,
        ),
        hintText: 'Emailinizi girin',
        hintStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(100),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      validator: (girilenDeger) {
        if (girilenDeger!.isEmpty) {
          return "Email bölümü boş bırakılamaz!";
        } else if (!girilenDeger.contains('@')) {
          return "Mail formatını kullanmalısınız!";
        }
      },
      onSaved: (girilenDeger) => email = girilenDeger!,
    );
  }

  TextFormField soyadTextField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'Soyadınız',
        hintStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(100),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      inputFormatters: [
        TextInputFormatter.withFunction((oldValue, newValue) {
          if (newValue.text.isNotEmpty) {
            // İlk harfi büyük harfe dönüştür
            return TextEditingValue(
              text: newValue.text.substring(0, 1).toUpperCase() +
                  newValue.text.substring(1),
              selection: newValue.selection,
              composing: newValue.composing,
            );
          }
          return newValue;
        }),
      ],
      validator: (girilenDeger) {
        if (girilenDeger!.isEmpty) {
          return "Soyad alanı boş bırakılamaz!";
        } else if (_containsNumbersOrSpecialCharacters(girilenDeger)) {
          return "Soyad sadece harflerden oluşmalıdır!";
        }
      },
      onSaved: (girilenDeger) => soyad = girilenDeger!,
    );
  }

  TextFormField adTextField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'Adınız',
        hintStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(100),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      inputFormatters: [
        TextInputFormatter.withFunction((oldValue, newValue) {
          if (newValue.text.isNotEmpty) {
            // İlk harfi büyük harfe dönüştür
            return TextEditingValue(
              text: newValue.text.substring(0, 1).toUpperCase() +
                  newValue.text.substring(1),
              selection: newValue.selection,
              composing: newValue.composing,
            );
          }
          return newValue;
        }),
      ],
      validator: (girilenDeger) {
        if (girilenDeger!.isEmpty) {
          return "Ad alanı boş bırakılamaz!";
        } else if (_containsNumbersOrSpecialCharacters(girilenDeger)) {
          return "Ad sadece harflerden oluşmalıdır!";
        }
      },
      onSaved: (girilenDeger) => ad = girilenDeger!,
    );
  }

  //Bu fonksiyon ad ve soyad için özel karakterlerin olmamasını denetlemek için kullanılacak.
  bool _containsNumbersOrSpecialCharacters(String value) {
    final regex = RegExp(r'[0-9!"\$%&/()=}+{^#*@]');
    return regex.hasMatch(value);
  }
  //bu metot uzun sürebilecek giriş veya kaydolma işlemleri gibi yerlerde giriş ya da kaydol butonuna basıldığında kullanıcıya bilgi vermek amaçlı ekranın ortasında yükleniyor animasyonu oluşturuyor.

  _yukleniyorAnimasyonu() {
    if (_yukleniyor) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return const SizedBox(
        height: 0.0,
      );
    }
  }

//burada yapılan işlemler loginPage'in giriş yap fonksiyonlarıyla aynı olduğundan ek bir açıklama olabilecek yerler açıklandı sadece.
//Detaylı ayrıntıyı bahsettiğim yerde bulabilirsiniz.

  void kaydolDugmesi() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      setState(() {
        _yukleniyor = true;
      });

      try {
        // bu metot aldığı maili ve şifreyi firebase Authentication bölümüne kaydeder.
        final result = await _firebaseauth.createUserWithEmailAndPassword(
            email: email, password: sifre);

        //burada firestore database de kullanıcı kaydı yapılıyor.
        //lib/services/firebase.dart yolunda bulunan FirestoreServisi sınıfı sayesinde firebasefirestore da kullanıcı oluşturuluıyor.
        await FirestoreService().createUser(
            id: result.user!.uid,
            ad: ad,
            soyad: soyad,
            email: email,
            sifre: sifre);

        //Ayrıca Flutter içerisinden de bu kullanıcıyı oluşturmak için
        //lib/models/user.dart dosyasında Kullanici sınıfından bir kullanıcı oluşturuldu.
        Kullanici kullanici = Kullanici(email, result.user!.uid, ad, soyad);
        //İşlemler tamamlandığında HomePage e gidecektir.

        //HomePage Kullanici tipinde bir kullanıcı almalı
        //Yukarıda oluşturulan kullanici değerini bu sayfaya giderken gönderiyoruz.
        //Böylece anasayfada kullanıcının adına ve soyadına erişim sağlanabilecektir.
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => StudentList(
            kullanici: kullanici,
          ),
        ));
        formKey.currentState!.reset();
      } on FirebaseAuthException catch (hata) {
        //Bu kısımda hatalar bahsettiğim uygulamanın çökme durumunma getirebilecek hataları ekrana yazdırıyoruz.
        uyariGoster(hataKodu: hata.code.toString());

        // burada false yaparak hata olduğunda animasyonu ortadan kaldırıyoruz.
        setState(() {
          _yukleniyor = false;
        });
      }
    } else {}
  }

  uyariGoster({
    String? hataKodu,
  }) {
    late String hataMesaji;
    if (hataKodu == "email-already-in-use") {
      hataMesaji = "Bu e-posta adresi zaten kayıtlı.";
    } else if (hataKodu == "invalid-email") {
      hataMesaji = "Geçersiz e-posta adresi girildi!";
    } else if (hataKodu == "operation-not-allowed") {
      hataMesaji = "E-posta ve şifre henüz etkin değil!";
    } else if (hataKodu == "weak-password") {
      hataMesaji = "Şifre güçlü değil!";
    }

    var snackBar = SnackBar(content: Text(hataMesaji));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
