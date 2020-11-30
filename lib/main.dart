import 'package:flutter/material.dart';
import 'package:flutter_chat_app/Views/signIn.dart';
import 'package:flutter_chat_app/helper/Authenticate.dart';

import 'Views/chatRoomScreen.dart';
import 'helper/helperFunctions.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool userIsLoggedIn ;

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value){
      setState(() {
        userIsLoggedIn  =value;
      });
    });
  }

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:userIsLoggedIn != null ?  userIsLoggedIn ? Chatroom() : Authentication()
          : Authentication(),


    );
  }
}

