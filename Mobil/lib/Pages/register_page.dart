import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage({Key? key,
    required this.showLoginPage
  }) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final email_controller = TextEditingController();
  final password_controller = TextEditingController();
  final password_again_controller = TextEditingController();

  final firstName_controller = TextEditingController();
  final lastName_controller = TextEditingController();
  final age_controller = TextEditingController();

  @override
  void dispose() {
    email_controller.dispose();
    password_controller.dispose();
    password_again_controller.dispose();
    firstName_controller.dispose();
    lastName_controller.dispose();
    age_controller.dispose();
    super.dispose();
  }
 late final user;
  Future signUp() async {
    if(passwordConfirmed()) {
      //User create
      try {
        user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email_controller.text.trim(),
            password: password_controller.text.trim()
        );
        //Add user details
        try {
          addUserDetails(
              firstName_controller.text.trim(),
              lastName_controller.text.trim(),
              email_controller.text.trim(),
              int.parse(age_controller.text.toString()));
        }
        catch (e) {
          showDialog(context: context, builder: (context) {
            return AlertDialog(
              content: Text("Yaşınız sadece rakamdan ibaret olmalıdır"),
            );
          });
        }
      }
      catch (e) {
        print("Giriş Başarısız : {$e}");
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (BuildContext context){

              return AlertDialog(
                title: Text("Kayıt Yapılamadı"),
                content: Text("Bu eposta kullanılıyor veya geçersiz olabilir"),
                actions: [
                  TextButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      child: Text("Tamam"))
                ],
              );
            });

      }


    }
    else{
      showDialog(context: context, builder: (context){
        return AlertDialog(
          content: Text("Şifreler Eşleşmiyor"),
        );
      });
    }
  }

  Future addUserDetails(String firstName,String lastName, String email, int age) async {
    /*
    await FirebaseFirestore.instance.collection('users').add(
      {
        "First Name" :firstName,
        "Last Name" : lastName,
        "Email" : email,
        "Age" : age,
      });
  }*/
    DatabaseReference ref = FirebaseDatabase.instance.ref("/users/${user.user!.uid}");

    await ref.set({
      "name": firstName,
      "lastname": lastName,
      "email": email,
      "age": age

    });

  }

  bool passwordConfirmed() {
    if(password_controller.text.trim() == password_again_controller.text.trim()){
      return true;
    }
    else{
      return false;
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("../../assets/dietLogo.png"),
                SizedBox(
                  height: 20,
                ),
                //Tekrar Hoşgeldiniz
                Text("Diet Tracker'a Üye Olunuz",
                    style: GoogleFonts.bebasNeue(
                      fontSize: 30,
                    )),

                SizedBox(
                  height: 50,
                ),


                //first and last Name textfield

                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextFormField(
                            controller: firstName_controller,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'İsim',
                              contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),

                          child: TextFormField(
                            controller: lastName_controller,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Soyisim',
                              contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                //age textfield

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: age_controller,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Yaş',
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 10,
                ),

                //email textfield

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: email_controller,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Email',
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 10,
                ),

                //password textfield
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: password_controller,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Şifre',
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 10,
                ),

                //Şifre Tekrar alanı

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: password_again_controller,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Şifre Tekrar',
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 10,
                ),

                //giriş yap button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: GestureDetector(
                    onTap: signUp,
                    child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(12)),
                        child: Center(
                          child: Text(
                            "Üye Ol",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        )),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Zaten bir hesabınız var mı? "),
                    GestureDetector(
                      onTap: widget.showLoginPage,
                      child: Text(
                        "Giriş Yapmak",
                        style: TextStyle(
                            color: Colors.blue[800], fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(" için tıklayınız"),
                  ],
                ),

                //üye değil misin üye ol yazısı
              ],
            ),
          ),
        ),
      ),
    );
  }
}
