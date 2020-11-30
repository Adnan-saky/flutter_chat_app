import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/helper/helperFunctions.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_chat_app/model/user_model.dart';

class AuthMethods{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  ///sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  ///signUp with email & password
  Future signUpWithEmailANdPassword(String email , String password) async{
    try{
      AuthResult result  = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);

    }catch(e){
      print(e.toString());
      return null;
    }
  }

  ///Forget pass

  Future resetPass(String email) async{
    try{
      return await _auth.sendPasswordResetEmail(email: email);
    }catch(e){
      print(e.toString());
      return null;
    }
  }



  ///SignOut
  Future signOut() async {
    try {
      print("Ssssssssssssssssssssignout");
      HelperFunctions.saveUserLoggedInSharedPreference(false);
      return await _auth.signOut();

    } catch (e) {
      print(e.toString());
      return null;
    }
  }


}