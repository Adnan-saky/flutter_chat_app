import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/Views/chatRoomScreen.dart';
import 'package:flutter_chat_app/helper/constans.dart';
import 'package:flutter_chat_app/helper/helperFunctions.dart';
import 'package:flutter_chat_app/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/Wiget/wiget.dart';
import 'package:flutter_chat_app/services/database.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class signIn extends StatefulWidget {
  final Function toggle;
  signIn(this.toggle);

  @override
  _signInState createState() => _signInState();
}

class _signInState extends State<signIn> {

  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  HelperFunctions helperFunctions = new HelperFunctions();


  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  signIn() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      await authMethods
          .signInWithEmailAndPassword(
          emailEditingController.text, passwordEditingController.text)
          .then((result) async {
        if (result != null)  {




          QuerySnapshot userInfoSnapshot =
          await DatabaseMethods().getUserInfo(emailEditingController.text);


          HelperFunctions.saveUserLoggedInSharedPreference(true);
          HelperFunctions.saveUserNameSharedPreference(
              userInfoSnapshot.documents[0].data["userName"]);
          HelperFunctions.saveUserEmailSharedPreference(
              userInfoSnapshot.documents[0].data["userEmail"]);

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Chatroom()));
        } else {
          setState(() {
            isLoading = false;
          });
        }
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD6cbe8),
      body:isLoading
          ? Container(
        child: Center(child: CircularProgressIndicator()),
      )
          :  Form(
        key: formKey,
            child: Center(
        child: ListView(
            children: [
              Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * .386,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/logo.png'),
                    alignment: Alignment.topCenter,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 20.0),
                child: Text('Flutter Chats',
                    style: TextStyle(fontSize: 30, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                child: TextFormField(
                  controller: emailEditingController,
                    validator: (val) {
                      return RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(val)
                          ? null
                          : "Please Enter Correct Email";
                    },
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  keyboardType: TextInputType.text,
                  decoration: textFieldInputDecoration("Email")
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                child: TextFormField(
                  controller: passwordEditingController,
                  obscureText: true,
                  validator: (val) {
                    return val.length > 6
                        ? null
                        : "Enter Password 6+ characters";
                  },
                  keyboardType: TextInputType.text,
                  decoration: textFieldInputDecoration('Password'),

                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(247.5, 0.0, 0.0, 0.0),
                child: FlatButton(
                  child: Text(
                    "Forget Password?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black.withOpacity(.8),
                    ),
                  ),
                  onPressed: () {
                    //Todo forget password screen
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 15.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * .82,
                  height: 40,
                  child: RaisedButton(
                    color: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      //side: BorderSide(color: Colors.black.withOpacity(.5)),
                    ),
                    //focusColor: Colors.red,
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      signIn();
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 30,
                child: Text(
                  "---------- Or ----------",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton.icon(
                      onPressed: () {},
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(40.0),
                            bottomLeft: const Radius.circular(40.0)),
                        //side: BorderSide(color: Colors.black.withOpacity()),
                      ),
                      label: Text(
                        "Facebook",
                        style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontSize: 22,
                          // fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      icon: FaIcon(
                        FontAwesomeIcons.facebook,
                        color: Colors.white,
                      ),
                      color: Colors.blue,
                    ),
                    RaisedButton.icon(
                      onPressed: () {},
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: const Radius.circular(40.0),
                            bottomRight: const Radius.circular(40.0)),
                        //side: BorderSide(color: Colors.black.withOpacity(.5)),
                      ),
                      label: Text(
                        " Google    ",
                        style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontSize: 22,
                          //fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      icon: FaIcon(FontAwesomeIcons.google, color: Colors.white),
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
                child: Text(
                  "Don't have an account?",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(0),
                child: GestureDetector(
                  onTap: (){
                    widget.toggle();
                  },
                  child: Container(
                    child: Text(
                      "REGISTER",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
        ),
      ),
          ),
    );
  }
}
