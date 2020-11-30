import 'package:flutter/material.dart';
import 'package:flutter_chat_app/Views/signIn.dart';
import 'package:flutter_chat_app/Views/signup.dart';


class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {

  bool showSignIn = true;

  void toggleview()
  {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return signIn(toggleview);
    }else
      return signup(toggleview);
  }
}
