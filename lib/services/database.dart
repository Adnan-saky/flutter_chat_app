import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{

  Future<void> addUserInfo(userData) async {
    Firestore.instance.collection("users").add(userData).catchError((e) {
      print(e.toString());
    });
  }

  getUserInfo(String userEmail) async {
    return await Firestore.instance
        .collection("users")
        .where("userEmail", isEqualTo: userEmail)
        .getDocuments()
        .catchError((e) {
      print(e.toString());
    });
  }



  Future<bool> addChatRoom(chatRoom, chatRoomId)async {
    await Firestore.instance
        .collection("chatRoom")
        .document(chatRoomId)
        .setData(chatRoom)
        .catchError((e) {
      print(e);
    });
  }

  searchByName(String searchField) {
    return Firestore.instance
        .collection("users")
        .where('userName', isEqualTo: searchField)
        .getDocuments();
  }

  getUserName(String itIsMyName) async {
    return await Firestore.instance
        .collection("chatRoom")
        .where('users', arrayContains: itIsMyName)
        .snapshots();
  }

  getConversations(String chatRoomId) async{
    return Firestore.instance
        .collection("chatRoom")
        .document(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
  }

  Future<void> addMessage(String chatRoomId, messageMap){

     Firestore.instance.collection("chatRoom")
        .document(chatRoomId)
        .collection("chats")
        .add(messageMap).catchError((e){
      print(e.toString());
    });
  }

  getChatRoom(String userName)
  async{
    return await Firestore.instance
        .collection('chatRoom')
        .where("user",arrayContains: userName)
        .snapshots();
  }


}