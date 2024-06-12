import 'package:beslenme/Pages/errorPage.dart';
import 'package:beslenme/Pages/viewDietList.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GetDietLists extends StatelessWidget {

  final userId;
  final dieticianId;
  final dieticianName;
  const GetDietLists({Key? key,required this.userId,required this.dieticianId,required this.dieticianName}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final ref = FirebaseDatabase.instance.ref("diyetlistesi");

    return FutureBuilder(
      future: ref.child("$userId/").get(),
      builder: ((context,snapshot) {
        List<dynamic> dietLists = [];

        if(snapshot.connectionState == ConnectionState.done) {
          if(snapshot.hasData && snapshot.data!.value != null) {
            Map value = snapshot.data!.value as Map;
            if (value[dieticianId] != null) {
              List dietData = value[dieticianId];

              print(dietData);
              return ListView(
                children: [
                  for(int i = 0; i < dietData.length; i++)
                    if(dietData[i] != null)
                      Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(13)
                        ),
                        child: MaterialButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    ViewDietList(
                                        dietList: dietData[i])), // Geçiş yapmak istediğiniz sayfayı buraya ekleyin)
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(dietData[i]["listeadi"],
                                      style: TextStyle(fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.start,),
                                    Text(dieticianName + " tarafından",
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.6),
                                        fontSize: 11
                                      )
                                    )
                                  ],
                                ),
                                Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12)
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text("Toplam Kalori",
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                            fontSize: 13
                                          )
                                          ,),
                                        Text(dietData[i]["toplamkalori"].toString(),
                                          style: TextStyle(
                                            color: Colors.black.withOpacity(0.7),
                                            fontSize: 11
                                          ),
                                        ),
                                      ],
                                    ))
                              ],
                            )
                        ),
                      )
                ],
              );
            }

            else {
              return ErrorPage(errorMessage: "Bu Diyetisyen Tarafından Gönderilmiş Bir Diyet Lisetesi Bulunamadı!!");

            }
          }
          else{
            return ErrorPage(errorMessage: "Bu Diyetisyen Tarafından Gönderilmiş Bir Diyet Lisetesi Bulunamadı!!");
          }
        }
        else return Text("");
      }
      ),
    );
  }
}
