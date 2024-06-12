import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';


class ChatWithAI extends StatefulWidget {

  final userId;
  const ChatWithAI({Key? key,required this.userId}) : super(key: key);

  @override
  State<ChatWithAI> createState() => _DietitianAssistantState();
}


class _DietitianAssistantState extends State<ChatWithAI> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool started = false;

  final ref = FirebaseDatabase.instance.ref();
  Map userInfo = {};
  int index = 0;

  @override
  void initState() {
    super.initState();
    FetchData();
  }

  String _initialPrompt = 'Sen şu an "Diet Tracker" adlı bir uygulamada kişisel bir diyetisyen asistanısın. Kullanıcıların Diyet ve beslenme ile ilgili sorularını yanıtlamalasın. Eğer soru diyetle ilgili değilse, “Bu benim uzmanlık alanımın dışında” şeklinde cevap verin.';
  String lastMessage = "";
  int base = 10;


  Future<void> _sendMessage(String userInput) async {
    started = true;
    if (userInput.trim().isEmpty) return;

    setState(() {
      _messages.add({"user" : userInput});
    });

    _initialPrompt += "Şu anda konuştuğun kullanıcının bilgileri şu şekilde. Adı: ${userInfo["name"]} , Yaşı:${userInfo["age"]}, Boyu: ${userInfo["boy"]}, Kilosu: ${userInfo["kilo"]}, Vücut Kitle İndeksi (BMI): ${userInfo["bmi"]}";

    final apiKey = "AIzaSyAGvaBeWbbrkU1Hg7aBo5iFhBGVTLlvwXE";

    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
    final content = [Content.text('$_initialPrompt + " " + $userInput')];

    final response = await model.generateContent(content);

    String? responseText = response.text;

    if(index!=0){
      if(response.text!.contains("Merhaba Ali!")) {
        responseText = response.text?.split("Merhaba Ali!")[1];
      }
    }
    setState(() {
      _messages.add({'bot': responseText ?? 'No response received'});
    });

    _controller.clear();
    index++;
  }

  Future<void> FetchData() async {
    final newRef = ref.child("users/${widget.userId}");
    DatabaseEvent event = await newRef.once();
    userInfo = event.snapshot.value as Map;
    //print("USERRR"+ userInfo.toString());
    setState(() {
    });
  }

    Future<String> writingMessage (String _message) async {
    print("GİRDDİİİİ");
      lastMessage = "";
      for(int i=0;i<_message.length;i++){
        lastMessage += _message[i];
      //print(lastMessage);
      await Future.delayed(Duration(milliseconds: 2));
    }
      print("BİTTİİİ");
      lastMessage = "";
      return lastMessage;
    }

    Future<String> getLastMessage () async {
    return lastMessage;
    }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Diyetisyen Asistan'),
      ),
      body: Column(
        children: [
          if(!started)
            Container(
              margin: EdgeInsets.only(top:150),
              child: Column(
                children: [
                  Image.asset("assets/dietLogoNoBack.png",width: 85,),
                  SizedBox(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: (){
                          _sendMessage("Diyet listeleri için ipuçlar ve tüyolar verebilir misin?? ");
                        },
                        child: Container(
                        width: 100,
                        height: 85,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.circular(12)
                        ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0,top: 1),
                                child: Row(
                                  children: [
                                    Icon(Icons.food_bank_outlined,color: Colors.green,),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text("Diyet listeleri için ipuçları ve tüyoları",style: TextStyle(fontSize: 11),),
                              ),
                            ],
                          ),

                      ),
                      ),
                      GestureDetector(
                        onTap: (){
                          _sendMessage("Bana uygun kilo vermek için örnek bir diyet listesi oluşturabilir misin? ");
                        },
                        child: Container(
                          width: 100,
                          height: 85,
                          decoration: BoxDecoration(
                              border: Border.all(width: 1),
                              borderRadius: BorderRadius.circular(12)
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0,top: 1),
                                child: Row(
                                  children: [
                                    Icon(Icons.emoji_food_beverage_outlined,color: Colors.deepPurpleAccent,),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text("Vücuduna uygun kişisel bir diyet listesi oluşturma",style: TextStyle(fontSize: 11),),
                              ),
                            ],
                          ),
                        ),

                      ),
                      GestureDetector(
                        onTap: (){
                          _sendMessage("Bana sağlıklı besinler hakkında bilgi verebilir misin? ");
                        },
                        child: Container(
                          width: 100,
                          height: 85,
                          decoration: BoxDecoration(
                              border: Border.all(width: 1),
                              borderRadius: BorderRadius.circular(12)
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0,top: 1),
                                child: Row(
                                  children: [
                                    Icon(Icons.fastfood_outlined,color: Colors.orange,),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text("Sağlıklı besinler hakkında bazı bilgiler",style: TextStyle(fontSize: 11),),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),// Arka plan rengi
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              reverse: true,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length-index-1];

                print("INDEX:" + index.toString());
                print("ITEM COUNT:" + _messages.length.toString());
                if (index == 0 && lastMessage.isEmpty && message['bot'] != null) {
                  //lastMessage = "";
                  //writingMessage(message['bot']!);
                 //lastMessage = message["bot"]!;
                }

                return
                  (message.containsKey('user') ?  Row(children:
                [
                  //Text(userInfo["name"]),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Container(
                      constraints: BoxConstraints(maxWidth: screenWidth- 100), // Maksimum genişlik 300 piksel olarak ayarlanıyor
                        child:
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(message['user']!),
                        ),
                      decoration: BoxDecoration(
                        color:Colors.green.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(12)
                      ),
                    ),
                  ),
                  ],
                ) : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset("assets/dietLogoNoBack.png",width:40,),
                    Container(
                      width: screenWidth-100,
                        child:
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: (index == 0) ? TypewriterText(message["bot"]!) : Text(message["bot"]!)

                ),
                        )
                        //(index == 0) ? Text(lastMessage) : Text(message["bot"]!)

                  ],
                ));
              },
            ),
          ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Sorunuzu Giriniz',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _sendMessage(_controller.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TypewriterText extends StatefulWidget {
  final String text;
  final Duration duration;

  TypewriterText(this.text, {this.duration = const Duration(milliseconds: 2)});

  @override
  _TypewriterTextState createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  String _displayedText = '';
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  void _startTyping() {
    Timer.periodic(widget.duration, (timer) {
      if (_currentIndex < widget.text.length) {
        setState(() {
          _displayedText += widget.text[_currentIndex];
          _currentIndex++;
        });
      } else {

        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _displayedText,
    );
  }
}
