import 'package:flutter/material.dart';

class FoodDetails extends StatefulWidget {
  final String foodName;
  final double? energy;
  final double? carbohydrate;
  final double? protein;
  final double? totalFat;
  final double? water;
  final double? sugars;
  final double? calcium;
  final double? iron;
  final double? magnesium;
  final double? potassium;
  final double? sodium;
  final String url;
  final String altUrl;

  const FoodDetails({Key? key
    ,required this.foodName,required this.energy,required this.carbohydrate,required this.protein,required this.totalFat
    ,required this.water,required this.sugars,required this.calcium,required this.iron,required this.magnesium,
    required this.potassium, required this.sodium,required this.url,required this.altUrl
  }) : super(key: key);
  @override
  State<FoodDetails> createState() => _FoodDetailsState();
}

class _FoodDetailsState extends State<FoodDetails> {


  List<String> optionsPortion = ['Büyük', 'Orta', 'Küçük'];
  String selectedOptionPortion = 'Orta';
  int selectedPortionIndex = 2;

  List<String> optionNumber = ["1","2","3","4","5","6","7","8","9"];
  String selectedOptionNumber = "1";

  double carpan = 1;


  @override
  Widget build(BuildContext context) {
    final double total = widget.carbohydrate! + widget.totalFat!+ widget.protein!;
    final double percentCar = widget.carbohydrate!/total * 100 ;
    final double percentFat = widget.totalFat!/total * 100 ;
    final double percentPro = widget.protein!/total * 100 ;


    double screenWidth = MediaQuery.of(context).size.width;

    void changeportion(String newValue){
      setState(() {
        selectedOptionPortion = newValue;
        switch(newValue){
          case "Büyük":
            carpan *= 4/selectedPortionIndex;
            selectedPortionIndex = 4;
            break;
          case "Orta" :
        carpan *= 2/selectedPortionIndex;
        selectedPortionIndex = 2;
            break;
          case "Küçük":
        carpan *= 1/selectedPortionIndex;
        selectedPortionIndex = 1;
            break;
        }

      });
    }

    void changeNumber(String newValue){
      setState(() {

        for(int i = 1;i<10;i++){
          if(i == int.parse(newValue)){
            carpan *= i/(int.parse(selectedOptionNumber));
            selectedOptionNumber = newValue;
            break;
          }
        }

      });
    }


    return Scaffold(appBar:
    AppBar(
      title: Text(widget.foodName),
    ),
      body:Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [

                  Container(
                    constraints: BoxConstraints(maxWidth: 150,maxHeight: 150,minHeight: 150,minWidth: 130), // Maksimum genişlik 300 piksel olarak ayarlanıyor
                    child: Image.network(
                      widget.url,
                      loadingBuilder: (context, child, loadingProgress){
                        if (loadingProgress == null) return child;
                        if(loadingProgress.cumulativeBytesLoaded == 0){
                          return CircularProgressIndicator(); // Yükleme sırasında gösterilecek ilerleme çubuğu
                        }
                        else{
                          return Image.network(
                            widget.altUrl,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child; // Yükleme tamamlandıysa resmi göster
                              return CircularProgressIndicator(); // Alternatif URL yükleme sırasında gösterilecek ilerleme çubuğu
                            },
                            errorBuilder: (context, error, stackTrace) {
                              print('Resim yüklenirken bir hata oluştu: $error');
                              // Alternatif URL yüklenirken hata olursa
                              return Image.asset("assets/dietLogo.png");

                            },

                          );

                        }
                      },
                      errorBuilder: (context, error, stackTrace) {
                        // Alternatif URL yüklenirken hata olursa
                        print('Resim yüklenirken bir hata oluştu: $error');
                        // Alternatif URL yüklenirken hata olursa
                        return Image.asset("assets/dietLogo.png");
                      },
                    ),
                  ),

                  //PORSİYON AYARLAMA DROPDOWN
                  Container(
                    width: screenWidth-170,
                    decoration: BoxDecoration(
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              width: 150,
                              height: 80,
                              decoration: BoxDecoration(
                              ),
                              child: DropdownButtonFormField<String>(
                                value: selectedOptionPortion.toString(),
                                onChanged: (String? newValue){

                                  changeportion(newValue as String);

                                },
                                items: optionsPortion.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value, style: TextStyle(decoration: TextDecoration.none)), // Altı çiziliği kaldırmak için TextDecoration.none kullanılır,
                                  );
                                }).toList(),
                                style: TextStyle(decoration: TextDecoration.none),
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                ),
                                dropdownColor: Colors.lightGreen,
                                decoration: InputDecoration(
                                  labelText: "Porsiyon",
                                  prefixIcon: Icon(
                                    Icons.emoji_food_beverage,
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)
                                  ),

                                ),
                                selectedItemBuilder: (BuildContext context) {
                                  return optionsPortion.map((String value) {
                                    return Text(
                                      value,
                                      style: TextStyle(color: Colors.black), // Seçili öğenin rengini buradan ayarlıyoruz
                                    );
                                  }).toList();
                                },

                              ),
                            ),
                            SizedBox(height: 0,),

                            //ADET AYARLAMA
                            Container(
                              width: 130,
                              decoration: BoxDecoration(
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    width: 100,
                                    height: 70,
                                    decoration: BoxDecoration(
                                    ),
                                    child: DropdownButtonFormField<String>(
                                      value: selectedOptionNumber,
                                      onChanged: (String? newValue) {
                                        changeNumber(newValue as String);
                                      },
                                      items: optionNumber.map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      style: TextStyle(decoration: TextDecoration.none),
                                      icon: Icon(
                                        Icons.arrow_drop_down,
                                      ),
                                      dropdownColor: Colors.lightGreen,
                                      decoration: InputDecoration(
                                        labelText: "Adet",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      selectedItemBuilder: (BuildContext context) {
                                        return optionNumber.map((String value) {
                                          return Text(
                                            value,
                                            style: TextStyle(color: Colors.black), // Seçili öğenin rengini buradan ayarlıyoruz
                                          );
                                        }).toList();
                                      },
                                    )
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),

              SizedBox(height: 25,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //Karbonhidrat
                  Column(
                    children: [
                      Text("Karbonhidrat",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                      Text((widget.carbohydrate!*carpan).toStringAsFixed(2)),
                      Text("%"+percentCar.toStringAsFixed(2))
                    ],
                  ),
                  //Yağ
                  Column(
                    children: [
                      Text("Yağ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                      Text((widget.totalFat!*carpan).toStringAsFixed(2)),
                      Text("%"+percentFat.toStringAsFixed(2))
                    ],
                  ),

                  //Protein
                  Column(
                    children: [
                      Text("Protein",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                      Text((widget.protein!*carpan).toStringAsFixed(2)),
                      Text("%"+percentPro.toStringAsFixed(2))
                    ],
                  ),
                ],
              ),

              SizedBox(height: 50,),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(12)
                ),
                child: Column(
                  children: [
                    Text("Besin Değerleri",style: TextStyle(fontWeight: FontWeight.bold),),
                    Container(
                        width: screenWidth/2+100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("1 Porsiyon (Orta)",style: TextStyle(color:Colors.black.withOpacity(0.7)),),
                          ],
                        )),
                    Container(
                        width: screenWidth/2+100,
                        child: Divider()),
                    Container(
                      width: screenWidth/2+100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Kalori (kcal)"),
                          Text(widget.energy!.toStringAsFixed(2))
                        ],
                      ),
                    ),
                    Container(
                        width: screenWidth/2+100,
                        child: Divider()),
                    Container(
                      width: screenWidth/2+100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Şeker"),
                          Text(widget.sugars!.toStringAsFixed(2))
                        ],
                      ),
                    ),
                    Container(
                        width: screenWidth/2+100,
                        child: Divider()),
                    Container(
                      width: screenWidth/2+100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Kalsiyum"),
                          Text(widget.calcium!.toStringAsFixed(2))
                        ],
                      ),
                    ),
                    Container(
                        width: screenWidth/2+100,
                        child: Divider()),
                    Container(
                      width: screenWidth/2+100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Sodyum (mg)"),
                          Text(widget.sodium!.toStringAsFixed(2))
                        ],
                      ),
                    ),
                    Container(
                        width: screenWidth/2+100,
                        child: Divider()),
                    Container(
                      width: screenWidth/2+100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Potasyum (mg)"),
                          Text(widget.potassium!.toStringAsFixed(2))
                        ],
                      ),
                    ),
                    Container(
                        width: screenWidth/2+100,
                        child: Divider()),
                    Container(
                      width: screenWidth/2+100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Demir"),
                          Text(widget.iron!.toStringAsFixed(2))
                        ],
                      ),
                    ),
                    Container(
                        width: screenWidth/2+100,
                        child: Divider()),
                    Container(
                      width: screenWidth/2+100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Su"),
                          Text(widget.water!.toStringAsFixed(2))
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ) ,
    );
  }
}

