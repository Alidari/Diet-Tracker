import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';

class DiyetisYenAl extends StatelessWidget {
  final String userId;
  final String kosul;
  final Function(Map,String) onTap;
  final Function (String) onTapMevcutDegil;

  DiyetisYenAl({required this.userId,required this.kosul,required this.onTap,required this.onTapMevcutDegil});

  List<dynamic> mevcutDiyetisyenKontrol = [];

  @override
  Widget build(BuildContext context) {

    //get the collection
    final ref = FirebaseDatabase.instance.ref();


    return FutureBuilder(
      future: ref.child("bilgitbl").get(),
      builder: ((context,snapshot) {
        final newRef = ref.child("relationships");
        return FutureBuilder(
            future: newRef.once(),
            builder: (context, eventSnapshot){
              if(snapshot.connectionState == ConnectionState.done) {
                Map diyetistenData = eventSnapshot.data!.snapshot.value as Map;
              diyetistenData.forEach((key, value) {

              int control = 0;
              Map kullanicilar = value as Map;
              kullanicilar.forEach((key, value) {
                if(key == userId){
                  control = 1;
                }
                });
                if(control == 1){
                  mevcutDiyetisyenKontrol.add(key);
                }
              });


          List<dynamic> diyetisyenlerMevcut = [];
          List<dynamic> mevcutOlmayandiyetisyenler = [];
          List<String> mevcutOlmayanKey = [];
          Map puanTable = {};
          List<String> mevcutKey = [];
          Map diyetisyen = snapshot.data!.value as Map;

          int i = 0;
          //MEVCUT OLMAYAN DİYETİSYEN ATAMASI
          diyetisyen.forEach((key, value) {

            try {
              Uint8List bytes = base64Decode(value["base64resim"]);
              value["base64resim"] = bytes;
            }
            catch(e){
              print(key + "için hata!! " + e.toString());
            }

            int control = 0;
              mevcutDiyetisyenKontrol.forEach((element) {

                if(element == key) control = 1;
                i++;
              });
              if(control != 1){
                mevcutOlmayandiyetisyenler.add(value);
                mevcutOlmayanKey.add(key);
              }
              else{
                diyetisyenlerMevcut.add(value);
                mevcutKey.add(key);
              }
          });




          //---------------PUAN TABLOSU OLAYI ---------------------------------
         ref.child("reviews").get().then((value) {
            Map data = value.value as Map;

            data.forEach((key, value) {
              Map data2 = value as Map;

              int puan = 0;
              int iterate = 0;
              data2.forEach((key, value) {
                Map review = value as Map;
                iterate++;
                puan += int.tryParse(review["puan"])!;
              });

              if(iterate != 0) {
                puanTable[key] = puan / iterate;
              }
              print("Puan Tablsou" + puanTable[key].toString());
            });

          });
          print("PUAN TABLOSU:" + puanTable.toString());
          //----------------------------------------------------------



          if(diyetisyen != null && kosul == "mevcut" && diyetisyenlerMevcut.length != 0) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //MEVCUT OLAN DİYETSYENLER LİSTESİ --------------------
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color:Colors.grey),
                      borderRadius: BorderRadius.circular(12)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          for(int i=0;i<diyetisyenlerMevcut.length;i++)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 8),
                              child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    ),
                                    child: ClipRRect(
                                      child: Image.memory(
                                      diyetisyenlerMevcut[i]["base64resim"],
                                      fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(30/2),

                                    ),

                              ),
                            ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          for(int i=0;i<diyetisyenlerMevcut.length;i++)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 8),
                              child: Text(diyetisyenlerMevcut[i]["ad"] + " " + diyetisyenlerMevcut[i]["soyad"]),
                            ),
                        ],
                      ),
                      Column(
                        children: [
                          for(int i=0;i<diyetisyenlerMevcut.length;i++)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 8),
                              child: Text((diyetisyenlerMevcut[i]["puan"] == null) ? "-" :  diyetisyenlerMevcut[i]["puan"].toString() ),
                            ),
                        ],
                      ),
                      Column(
                        children: [
                          for(int i=0;i<diyetisyenlerMevcut.length;i++)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 0.0),
                              child: MaterialButton(
                                minWidth: 5, // minimum genişlik
                                height: 10,
                                padding: EdgeInsets.all(1), // padding ayarı
                                onPressed: (){
                                  onTap(diyetisyenlerMevcut[i],mevcutKey[i]);
                                },
                                child: Text("Detay",style: TextStyle(fontSize: 15),),
                                color: Colors.green,
                              ),
                            )
                        ],
                      ),
                    ],
                  ),
                ),

              ],
            );
          }
          else if(diyetisyen != null && kosul == "mevcut degil" && mevcutOlmayandiyetisyenler.length != 0){
            return Container(
              margin: EdgeInsets.all(0),
              decoration: BoxDecoration(
                  border: Border.all(color:Colors.grey),
                  borderRadius: BorderRadius.circular(12)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      for(int i=0;i<mevcutOlmayandiyetisyenler.length;i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 8),
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: ClipRRect(
                              child: Image.memory(
                                mevcutOlmayandiyetisyenler[i]["base64resim"],
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(30/2),

                            ),

                          ),
                        ),
                    ],
                  ),
                  Column(
                    children: [
                      for(int i=0;i<mevcutOlmayandiyetisyenler.length;i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 8),
                          child: Text(mevcutOlmayandiyetisyenler[i]["ad"] + " " + mevcutOlmayandiyetisyenler[i]["soyad"]),
                        ),
                    ],
                  ),
                  Column(
                    children: [
                      for(int i=0;i<mevcutOlmayandiyetisyenler.length;i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 8),
                          child: Text((mevcutOlmayandiyetisyenler[i]["puan"] == null) ? "-" :  mevcutOlmayandiyetisyenler[i]["puan"].toString() ),
                        ),
                    ],
                  ),
                  Column(
                    children: [
                      for(int i=0;i<mevcutOlmayandiyetisyenler.length;i++)
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: MaterialButton(
                            minWidth: 5, // minimum genişlik
                            height: 20,
                            padding: EdgeInsets.all(1),
                            onPressed: (){
                              onTapMevcutDegil(mevcutOlmayanKey[i]);
                            },
                            child: Icon(Icons.add,size: 20,),
                            color: Colors.green,
                          ),
                        )
                    ],
                  ),
                ],
              ),
            );
          }
          else{
            return Container(
                decoration : BoxDecoration(
                    border: Border.all(color:Colors.grey),
                    borderRadius: BorderRadius.circular(12)
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0,vertical: 7),
                  child: Text("Herhangi bir diyetisyen bulunamadı.."),
                ));
          }
        }
        return CircularProgressIndicator();
      }

      );
      })
    );

  }
}

