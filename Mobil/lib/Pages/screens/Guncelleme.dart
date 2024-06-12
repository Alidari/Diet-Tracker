import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:beslenme/Pages/home_page.dart'; // Ana sayfa dosyanızı buraya dahil edin

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  User? user = FirebaseAuth.instance.currentUser;
  String? uid;

  @override
  void initState() {
    super.initState();
    if (user != null) {
      uid = user!.uid;
      _loadUserData();
    }
  }

  Future<void> _loadUserData() async {
    DatabaseReference userRef = FirebaseDatabase.instance.ref().child('users/$uid');
    DatabaseEvent userEvent = await userRef.once();
    DataSnapshot userSnapshot = userEvent.snapshot;

    if (userSnapshot.value != null) {
      Map<String, dynamic> userData = Map<String, dynamic>.from(userSnapshot.value as Map);
      setState(() {
        nameController.text = userData['name'];
        lastnameController.text = userData['lastname'];
        weightController.text = userData['kilo'].toString();
        heightController.text = userData['boy'].toString();
        ageController.text = userData['age'].toString();
      });
    }
  }

  Future<void> _updateUserData() async {
    if (user != null) {
      try {
        double weight = double.tryParse(weightController.text) ?? 0.0;
        double heightCm = double.tryParse(heightController.text) ?? 0.0;
        double heightM = heightCm / 100.0;
        double bmi = weight / (heightM * heightM);
        String bmiString = bmi.toStringAsFixed(2);
        DatabaseReference userRef = FirebaseDatabase.instance.ref().child('users/$uid');
        await userRef.update({
          'name': nameController.text,
          'lastname': lastnameController.text,
          'kilo': weight,
          'boy': heightCm,
          'age': int.tryParse(ageController.text) ?? 0,
          'bmi': bmiString,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bilgiler güncellendi.')),
        );
        // Güncelleme başarılı olduğunda ana sayfaya yönlendir
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } catch (error) {
        print('Error updating user data: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bir hata oluştu. Lütfen tekrar deneyin.')),
        );
      }
    }
  }

  Future<void> _changePassword(String newPassword) async {
    if (user != null) {
      try {
        await user!.updatePassword(newPassword);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Şifre başarıyla güncellendi.')),
        );
      } catch (e) {
        print('Failed to update password: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Şifre güncellenirken bir hata oluştu: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.grey[300],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              
              _buildTextField(passwordController, 'Yeni Şifre', true),
              _buildTextField(nameController, 'Ad', false),
              _buildTextField(lastnameController, 'Soyad', false),
              _buildTextField(weightController, 'Kilo (kg)', false, isNumeric: true),
              _buildTextField(heightController, 'Boy (cm)', false, isNumeric: true),
              _buildTextField(ageController, 'Yaş', false, isNumeric: true),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await _updateUserData();
                  if (passwordController.text.isNotEmpty) {
                    await _changePassword(passwordController.text);
                  }
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                child: Text('Bilgileri Güncelle'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText, bool isPassword, {bool isNumeric = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hintText,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextField(
                controller: controller,
                obscureText: isPassword,
                keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

