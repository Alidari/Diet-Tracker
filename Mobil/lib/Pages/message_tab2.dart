import 'package:beslenme/Pages/screens/chat/chat_service_for_doctor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageTab2 extends StatefulWidget {
  final String message_with_id;
  final String userId;
  final String other_name;
  final String other_surname;


  const MessageTab2({
    Key? key,
    required this.message_with_id,
    required this.userId,
    required this.other_name,
    required this.other_surname
  }) : super(key: key);

  @override
  State<MessageTab2> createState() => _ChatPageState();
}

class _ChatPageState extends State<MessageTab2> {
  final TextEditingController _messageController = TextEditingController();
  final ChatServiceForDoctor _chatService = ChatServiceForDoctor();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
        widget.message_with_id,
        _messageController.text,
      );
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[150],
        title: Text(widget.other_name),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          image: DecorationImage(
            image: AssetImage('assets/dietLogo.png'),
            
          ),
        ),// Arka plan rengi
        child: Column(
          children: [
            Expanded(
              child: _buildMessageList(),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _chatService.getMessages(
        widget.message_with_id,
        _firebaseAuth.currentUser!.uid,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Hata: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        List<Widget> messageWidgets = [];
        List<Map<String, dynamic>>? messages = snapshot.data;
        print("Messages = " + messages.toString());
        if (messages != null) {
          // Mesajları tarih damgasına göre sırala
          //messages.sort((a, b) => b['tarih'].compareTo(a['tarih']));
          messages.sort((a, b) => (b['tarih'] as int).compareTo(a['tarih'] as int));
          messages.forEach((message) {
            messageWidgets.add(_buildMessageItem(message));
          });
        }
        return Column(
          children: [
            Expanded(
              child: ListView(
                reverse: true, // ListView'ı tersine çevirme
                children: messageWidgets,
              ),
            ),
            _buildMessageInput(), // Yeni metin giriş alanı
          ],
        );
      },
    );
  }

  Widget _buildMessageItem(Map<dynamic, dynamic> data) {
    final bool isCurrentUser =
        data['gonderen'] == _firebaseAuth.currentUser!.uid;

    return Align(
      alignment:
      isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: 200), // Maksimum genişlik 300 piksel olarak ayarlanıyor
        margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: isCurrentUser ? Colors.green : Colors.grey[300],
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Gölge rengi ve opaklığı
              spreadRadius: 5, // Gölgeyi ne kadar yayacağı
              blurRadius: 7, // Gölge bulanıklığı
              offset: Offset(0, 3), // Gölgenin yerleşimini ayarlar
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.0),
            Text(data["mesaj"],)
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Mesajınızı buraya girin...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                contentPadding:
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              ),
            ),
          ),
          SizedBox(width: 8.0),
          IconButton(
            onPressed: sendMessage,
            icon: Icon(Icons.send),
            color: Colors.lightGreen[400],
            iconSize: 32.0,
          ),
        ],
      ),
    );
  }
}