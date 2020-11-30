import 'package:flutter/material.dart';
import 'package:flutter_chat_app/Wiget/wiget.dart';
import 'package:flutter_chat_app/helper/constans.dart';
import 'package:flutter_chat_app/helper/helperFunctions.dart';
import 'package:flutter_chat_app/services/auth.dart';
import 'package:flutter_chat_app/Views/chatRoomScreen.dart';
import 'package:flutter_chat_app/services/database.dart';

class signup extends StatefulWidget {
  final Function toggle;
  signup(this.toggle);

  @override
  _signupState createState() => _signupState();
}

class _signupState extends State<signup> {
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();
  TextEditingController usernameEditingController = new TextEditingController();

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  signUp() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      await authMethods
          .signUpWithEmailANdPassword(
              emailEditingController.text, passwordEditingController.text)
          .then((val) {


        Map<String,String> userDataMap = {
          "userName" : usernameEditingController.text,
          "userEmail" : emailEditingController.text,
          "userPassword": passwordEditingController.text
        };

        HelperFunctions.saveUserLoggedInSharedPreference(true);
        HelperFunctions.saveUserNameSharedPreference( usernameEditingController.text);
        HelperFunctions.saveUserEmailSharedPreference(emailEditingController.text);

            databaseMethods.addUserInfo(userDataMap);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Chatroom()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD6cbe8),
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Center(
              child: Form(
              key: formKey,
              child: ListView(children: [
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
                  child: Text('Register',
                      style: TextStyle(
                          fontSize: 30,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  child: TextFormField(
                    controller: emailEditingController,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    validator: (val) {
                      return RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(val)
                          ? null
                          : "Enter correct email";
                    },
                    decoration: textFieldInputDecoration("Email"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  child: TextFormField(
                    controller: usernameEditingController,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    validator: (val) {
                      return val.isEmpty || val.length < 3
                          ? "Enter valid user name"
                          : null;
                    },
                    decoration: textFieldInputDecoration("Username"),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    child: TextFormField(
                        controller: passwordEditingController,
                        obscureText: true,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        validator: (val) {
                          return val.length < 6
                              ? "Enter Strong Password with 6+ character"
                              : null;
                        },
                        decoration: textFieldInputDecoration("Password"))),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 15.0),
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
                        "SignUp",
                        style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        signUp();
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                  child: Text(
                    "Already have Account?",
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
                        "SignIn Now",
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
              ]),
            )),
    );
  }
}
