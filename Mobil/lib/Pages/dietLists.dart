import 'package:beslenme/ReadData/getDietLists.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DietLists extends StatefulWidget {
  final userId;
  final dieticianId;
  final dieticianName;
  const DietLists({Key? key,required this.dieticianId, required this.userId,required this.dieticianName}) : super(key: key);

  @override
  State<DietLists> createState() => _DietListsState();
}

class _DietListsState extends State<DietLists> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diyet Listeleri'),
      ),
      body: GetDietLists(userId: widget.userId,dieticianId: widget.dieticianId,dieticianName: widget.dieticianName,),
    );
  }
}
