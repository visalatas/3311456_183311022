import 'package:edumate/data/firebase.dart';
import 'package:edumate/screens/sign_up_page.dart';
import 'package:edumate/screens/student_list.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';
import '../utils/constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late String email, sifre;
  bool _sifreGizli = true;
  bool _yukleniyor = false;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    //Cihazın yükseklik ve genişlik değerleri değişkenlere atandı. Widget'ların farklı cihazlarda denk çözünürlüklere sahip olsun diye kullanılır.

    return Scaffold(
      //singlechildscrolview yapısı kullanıldığında Klavye çıkınca aşağıda kalan yapıları kaydırarak görebilmeye imkan verir.
      body: SingleChildScrollView(
        //ana yapı column içinde olacaktır. iki çocuğu var üst kısım ve gövde.
        // Scaffold kısmında appBar ve body parametrelerine karşılık geliyor gibi düşünmek lazım
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //burası ekranın üst kısmında bulunan arka plan resmi ve yazılar yer alıyor.
            ustKisim(height),

            //burada gövde ve yükleniyor animasyonu kısmı var. Yükleniyor animasyonu yukleniyor değerine göre ekranda belirlenecek.
            //_yukleniyor=true olduğunda ekranın ortasında belirecek. Şimdilik false değerinde kaydol veya giriş yap düğmelerinden
            //birine basıldığında true değeri alacak ve kullanıcıya işlemin gerçekleştiği uyarısını vermiş olacak.
            Stack(
              children: [
                govde(height),
                _yukleniyorAnimasyonu(),
              ],
            )
          ],
        ),
      ),
    );
  }

  Stack ustKisim(double height) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: height * 0.45,
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
              height: 60,
              width: 60,
              decoration: const BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/quiz.png'))),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Hoş Geldiniz!",
              style: Constants.titleTextStyle,
            ),
          ],
        )
      ],
    );
  }

  Padding govde(double height) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      // Gövde kısmı
      child: Form(
        key: _formKey,
        child: SizedBox(
          height: height * 0.55,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: height * 0.24,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    emailTextField(),
                    sifreTextField(),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.20,
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: CupertinoButton(
                        color: Color.fromRGBO(52, 137, 246, 1),
                        borderRadius: BorderRadius.circular(100),
                        onPressed: () => girisYap(),
                        pressedOpacity: 0.5,
                        child: const Text(
                          'Giriş Yap',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                        onPressed: () {}, child: Text("Şifremi Unuttum")),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Hesabın yok mu?"),
                  TextButton(
                      onPressed: () => Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => SignUpPage(),
                          )),
                      child: Text("Kaydol")),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  TextFormField sifreTextField() {
    return TextFormField(
      //bool tipinde_sifreGizli değişken oluşturdum bunu aşağıda suffixicon kısmında kontrol ediyorum.
      obscureText: _sifreGizli,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.key),
        prefixStyle: const TextStyle(
          color: Colors.red,
        ),
        hintText: 'Şifre',
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
        }
      },
      onSaved: (girilenDeger) => sifre = girilenDeger!,
    );
  }

  TextFormField emailTextField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.mail_outline_rounded),
        prefixStyle: const TextStyle(
          color: Colors.red,
        ),
        hintText: 'Email',
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

  girisYap() async {
    //burada giriş yap kontrolü sağlanıp sağlanmadığı kontrol edilecek. if kısmının koşulu validator kullanılan yerde sorun olmamasıdır.

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!
          .save(); // sorun yoksa mail ve şifre değerleri save metoduyla kaydoluyor. Girilen mail, email değişkenine ve şifre de sifre değişkenine atandı
      //burada setstate ile widget ağacını tekrar döndürmek lazım ki yükleniyor widgetı ekranda gözüksün setstate kullanılmazsa ekrana gelmez.
      setState(() {
        _yukleniyor =
            true; // yükleniyor true govde kısmının altında yükleniyorAnimasyonu devreye giriyor.
      });
      //burada try catch kullanılmanın avantajı program hata alırsa çökmesin uygulama ekranında kullanıcıya bildirim versin.
      try {
        // burada firebaseauth un signwithemailandpassword metodu kullanılıyor. Burada adı üstünde olduğu gibi mail ve şifre gerekiyor save metoduyla aldığımız değerleri burada bu metoda gönderiyoruz.
        final result = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: sifre);

        Kullanici kullanici =
            await FirestoreService().getUser(result.user!.uid);

        //Giriş işlemi başarılı olduğunda anasayfaya gidecek
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => StudentList(
                  kullanici: kullanici,
                )));
        _formKey.currentState!.reset();
      } on FirebaseAuthException catch (hata) {
        //Bu kısımda hatalar bahsettiğim uygulamanın çökme durumunma getirebilecek hataları ekrana yazdırıyoruz.
        uyariGoster(hataKodu: hata.code.toString());

        // burada false yaparak hata olduğunda animasyonu ortadan kaldırıyoruz.
        setState(() {
          _yukleniyor = false;
        });
      }
      // burada false değeri tekrardan fonksiyon sonunda verilmelidir. Eğer kullanıcı anasayfadan çıkış işlemi yapmak isterse _yukleniyor true olarak kalmamalı.
      _yukleniyor = false;
    }
  }

  uyariGoster({
    String? hataKodu,
  }) {
    late String hataMesaji;
    // burada late kullanmılmazsa aşağıda text kısmında nonnullable hatası verecek. Late bir verinin şu an boş ama derlendiğinde o verinin geleceğini ifade ediyor.

    //burada hata kodları signInWithEmailAndPassword metodunun varsayılan hata kodlarıdır. Bir if kontrolleriyle hangi hataya göre çevirisini ekrana hatamesaji na aktaracak
    if (hataKodu == "user-not-found") {
      hataMesaji = "Mail Adresi Bulunamadı!";
    } else if (hataKodu == "invalid-email") {
      hataMesaji = "Geçersiz e-posta adresi girildi!";
    } else if (hataKodu == "user-disabled") {
      hataMesaji = "Bu hesap engellendi!";
    } else if (hataKodu == "weak-password") {
      hataMesaji = "Şifre güçlü değil!";
    } else if (hataKodu == "wrong-password") {
      hataMesaji = "Şifre yanlış!";
    }
    //burada hataMesaji ni ekranda snackbar olarak gösterecek
    var snackBar = SnackBar(content: Text(hataMesaji));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
}
