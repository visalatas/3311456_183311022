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
    // ignore: unused_local_variable
    double width = MediaQuery.of(context).size.width;
    

    return Scaffold(
      
      body: SingleChildScrollView(
        
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            ustKisim(height),

           
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
                        color: const Color.fromRGBO(52, 137, 246, 1),
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
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Hesabın yok mu?"),
                  TextButton(
                      onPressed: () =>
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SignUpPage(),
                          )),
                      child: const Text("Kaydol")),
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
                child: const Icon(Icons.visibility_off_rounded))
            : InkWell(
                borderRadius: BorderRadius.circular(200),
                onTap: () {
                  setState(() {
                    _sifreGizli = !_sifreGizli;
                  });
                },
                child: const Icon(Icons.visibility_rounded)),
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
      // ignore: body_might_complete_normally_nullable
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
      // ignore: body_might_complete_normally_nullable
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
    

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!
          .save(); 
      setState(() {
        _yukleniyor =
            true; 
      });
      
      try {
        
        final result = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: sifre);

        Kullanici kullanici =
            await FirestoreService().getUser(result.user!.uid);

        
        // ignore: use_build_context_synchronously
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => StudentList(
                  kullanici: kullanici,
                )));
        _formKey.currentState!.reset();
      } on FirebaseAuthException catch (hata) {
        
        uyariGoster(hataKodu: hata.code.toString());

        
        setState(() {
          _yukleniyor = false;
        });
      }
      
      _yukleniyor = false;
    }
  }

  uyariGoster({
    String? hataKodu,
  }) {
    late String hataMesaji;
   
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
    
    var snackBar = SnackBar(content: Text(hataMesaji));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


  _yukleniyorAnimasyonu() {
    if (_yukleniyor) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return const SizedBox(
        height: 0.0,
      );
    }
  }
}
