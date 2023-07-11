import 'package:edumate/data/firebase.dart';
import 'package:edumate/screens/student_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/user.dart';
import '../utils/constants.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  
  final FirebaseAuth _firebaseauth = FirebaseAuth.instance;

  
  late String ad, soyad, email, sifre;
   
  final formKey = GlobalKey<FormState>();

  
  bool _yukleniyor = false;
  
  bool _sifreGizli = true;

 
  final TextEditingController _sifreController = TextEditingController();
  final TextEditingController _sifreTekrarController = TextEditingController();

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
                      icon: const Icon(
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
                        const SizedBox(
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
                  color: const Color.fromRGBO(52, 137, 246, 1),
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
      // ignore: body_might_complete_normally_nullable
      validator: (girilenDeger) {
        if (girilenDeger!.isEmpty) {
          return "Şifre bölümü boş bırakılamaz!";
        } else if (girilenDeger.trim().length < 5) {
          return "Şifre 5 karakterden fazla olmalıdır!";
        } else if (girilenDeger != _sifreController.text) {
          return "Şifreler uyuşmuyor! Kontrol ediniz.";
        }
      },
      
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
        return null;
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
        return null;
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
        return null;
      },
      onSaved: (girilenDeger) => ad = girilenDeger!,
    );
  }

  
  bool _containsNumbersOrSpecialCharacters(String value) {
    final regex = RegExp(r'[0-9!"\$%&/()=}+{^#*@]');
    return regex.hasMatch(value);
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



  void kaydolDugmesi() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      setState(() {
        _yukleniyor = true;
      });

      try {
        
        final result = await _firebaseauth.createUserWithEmailAndPassword(
            email: email, password: sifre);

        
        await FirestoreService().createUser(
            id: result.user!.uid,
            ad: ad,
            soyad: soyad,
            email: email,
            sifre: sifre);

       
        Kullanici kullanici = Kullanici(email, result.user!.uid, ad, soyad);
        
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => StudentList(
            kullanici: kullanici,
          ),
        ));
        formKey.currentState!.reset();
      } on FirebaseAuthException catch (hata) {
       
        uyariGoster(hataKodu: hata.code.toString());

        
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
