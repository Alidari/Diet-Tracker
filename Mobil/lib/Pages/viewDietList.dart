import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ViewDietList extends StatefulWidget {
  final dietList;
  const ViewDietList({Key? key,required this.dietList}) : super(key: key);

  @override
  State<ViewDietList> createState() => _ViewDietListState();
}

class _ViewDietListState extends State<ViewDietList> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  Map foodList = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    loadFoodData();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  String shortFoodName(String longName) {
    String shortName = longName.split(',')[0];
    return shortName;
  }

  Future<void> loadFoodData() async {
    String jsonData = await rootBundle.loadString('assets/data.json');
    List<dynamic> jsonList = json.decode(jsonData);

    List<Map<String,dynamic>> dataList = [];
    dataList.addAll(jsonList.cast<Map<String, dynamic>>());

    dataList.forEach((element) {
      Map data = element as Map;
      Map nameKcalData = {
        data["foodname"] : data["Energy"]
      };
      foodList.addAll(nameKcalData);
    });
    setState(() {
      print("object");
    });

  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;

    List dinnerFoods = [];
    List launchFoods = [];
    List breakfastFoods = [];

    Map dinner = widget.dietList["aksam"];
    Map launch = widget.dietList["ogle"];
    Map breakfast = widget.dietList["sabah"];


    dinner.forEach((key, value) {
      dinnerFoods.add(key);
    });
    launch.forEach((key, value) {
      launchFoods.add(key);
    });
    breakfast.forEach((key, value) {
      breakfastFoods.add(key);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Diyet Listem'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 50.0),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                indicator: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 3),
                tabs: [
                  Tab(text: 'Sabah'),
                  Tab(text: 'Öğle'),
                  Tab(text: 'Akşam'),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                MealTab(
                  imagePath: 'assets/breakfast.png', // Resminizi buraya ekleyin
                  meals: [
                    for(int i=0;i<breakfastFoods.length;i++)
                      {'name':shortFoodName(breakfastFoods[i]),'kcal':foodList[breakfastFoods[i]],'amount':breakfast[breakfastFoods[i]]["adet"]}
                  ],
                ),
                MealTab(
                  imagePath: 'assets/breakfast.png', // Resminizi buraya ekleyin
                  meals: [
                    for(int i=0;i<launchFoods.length;i++)
                      {'name':shortFoodName(launchFoods[i]),'kcal':foodList[launchFoods[i]],'amount':launch[launchFoods[i]]["adet"]}
                  ],
                ),
                MealTab(
                  imagePath: 'assets/breakfast.png', // Resminizi buraya ekleyin
                  meals: [
                    for(int i=0;i<dinnerFoods.length;i++)
                      {'name':shortFoodName(dinnerFoods[i]),'kcal':foodList[dinnerFoods[i]],'amount':dinner[dinnerFoods[i]]["adet"]}
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MealTab extends StatelessWidget {
  final String imagePath;
  final List<Map<String, dynamic>> meals;
  int totalCal = 0;

  MealTab({required this.imagePath, required this.meals});

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(imagePath, height: 200), // Yemek resmini buraya ekleyin
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                width: screenWidth - 70,
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(width: 1,color: Colors.black.withOpacity(0.4)),
                  borderRadius: BorderRadius.circular(12)
                ),
                child: DataTable(
                  columnSpacing: 25,
                  dataRowMaxHeight: 70,
                  columns: [
                    DataColumn(label: Text('İsmi',style: TextStyle(color: Colors.black.withOpacity(0.7)),),numeric: false),
                    DataColumn(label: Text('Kcal',style: TextStyle(color: Colors.black.withOpacity(0.7)),)),
                    DataColumn(label: Text('Gram/Adet',style: TextStyle(color: Colors.black.withOpacity(0.7)),)),
                  ],
                  rows: meals
                      .map(
                        (meal) => DataRow(cells: [
                      DataCell(Text(meal['name'])),
                      DataCell(Text(meal['kcal'].toString())),
                      DataCell(Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(meal['amount'].toString(),textAlign: TextAlign.center,),
                        ],
                      )),
                    ],),

                  )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}