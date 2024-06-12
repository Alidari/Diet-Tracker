import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:beslenme/Pages/screens/chat_page.dart';

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  late DatabaseReference _userRef;
  late User _currentUser;
  

  @override
  void initState() {
    super.initState();
    _userRef = FirebaseDatabase.instance.reference().child('users');
    _currentUser = FirebaseAuth.instance.currentUser!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Colors.lightGreen[200],
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
  return StreamBuilder<DatabaseEvent>(
    stream: _userRef.onValue,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text('Hata: ${snapshot.error}');
      }

      if (!snapshot.hasData || snapshot.data == null) {
        return CircularProgressIndicator();
      }

      final dataSnapshot = snapshot.data!.snapshot;
      Map<dynamic, dynamic>? users = dataSnapshot.value as Map<dynamic, dynamic>?;

      if (users == null) {
        return Center(
          child: Text('Kullanıcı bulunamadı.'),
        );
      }

      // Aktif kullanıcıyı listeden kaldır
      users.removeWhere((key, value) => key == _currentUser.uid);

      // Map<dynamic, dynamic> türündeki veriyi Map<String, dynamic> türüne dönüştür
      Map<String, dynamic> convertedUsers = {};
      users.forEach((key, value) {
        convertedUsers[key.toString()] = Map<String, dynamic>.from(value);
      });

     return ListView.builder(
      itemCount: convertedUsers.length,
      itemBuilder: (context, index) {
        String uid = convertedUsers.keys.elementAt(index);
        Map<String, dynamic> userData = convertedUsers[uid]!;
        String userName = userData['name'] ?? '';
        String userLastName = userData['lastname'] ?? '';
        String usereceiverID = uid;
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        elevation: 4.0,
        child: ListTile(
          title: Text(
            '$userName $userLastName ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          leading: CircleAvatar(
            backgroundColor: Colors.blue,
            child: Icon(
              Icons.person,
              color: Colors.white,
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  receiverID: usereceiverID,
                  receiverUserName: '$userName ',
                ),
              ),
            );
          },
        ),
      ),
    );
  },
);
    },
  );
}
}