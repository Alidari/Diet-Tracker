import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../ReadData/diyetisyen_al_mesaj.dart';
import 'dietLists.dart';

class DietList extends StatefulWidget {
  const DietList({Key? key}) : super(key: key);

  @override
  State<DietList> createState() => _DietListState();
}



void goDietTab() {}

class _DietListState extends State<DietList> {

  final user = FirebaseAuth.instance.currentUser!;
  late final String userId;

  @override
  void initState() {
    super.initState();
    userId = user.uid;
  }
  void goMessageTab(String dieticianId,String diaticianName,String diaticianSurname){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DietLists(dieticianId: dieticianId,userId: userId,dieticianName: diaticianName + " " + diaticianSurname,)), // Geçiş yapmak istediğiniz sayfayı buraya ekleyin)
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diyetisyenler'),
      ),
     body: DiyetisYenAlMesaj(userId: userId,onTap: goMessageTab,),
    );
  }
}
