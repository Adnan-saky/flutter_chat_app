import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/Views/chatRoomScreen.dart';
import 'package:flutter_chat_app/helper/constans.dart';
import 'package:flutter_chat_app/helper/helperFunctions.dart';
import 'package:flutter_chat_app/services/database.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Conversation extends StatefulWidget {
  final String chatRoomId;
  Conversation(this.chatRoomId);
  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController massageEditingController = new TextEditingController();
  Stream chatStream;

  Widget chatList() {
    return StreamBuilder<QuerySnapshot>(
      stream: chatStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                      message: snapshot.data.documents[index].data["message"],
                      sendByMe: Constants.myName ==
                          snapshot.data.documents[index].data["sendBy"]);
                })
            : Container();
      },
    );
  }




  sendMassage() {
    if (massageEditingController.text != null) {
      Map<String, dynamic> messageMap = {
        "message": massageEditingController.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().microsecondsSinceEpoch
      };
      databaseMethods.addMessage(widget.chatRoomId, messageMap);
      massageEditingController.text = "";
    }
  }

  @override
  void initState() {
    //getchatname();
    databaseMethods.getConversations(widget.chatRoomId).then((val) {
      setState(() {
        chatStream = val;
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
        backgroundColor: Color(0xFF811be8),
        elevation: 10,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          color: Color(0xFFD6cbe8),
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 60),
                child: chatList(),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(100),
                      topRight: Radius.circular(100),
                      bottomRight: Radius.circular(0),
                      bottomLeft: Radius.circular(0),
                    ),
                    color: Colors.deepPurple[200],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: massageEditingController,
                          maxLines: null,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                          decoration: InputDecoration(
                              hintText: "Type here ...",
                              hintStyle: TextStyle(
                                color: Colors.black45,
                                fontSize: 16,
                              ),
                              border: InputBorder.none),
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(40)),
                        child: IconButton(
                          padding: EdgeInsets.fromLTRB(7, 02, 20, 0),
                          icon: FaIcon(
                            FontAwesomeIcons.telegram,
                            size: 25,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            sendMassage();
                          },
                        ),
                      ),
                    ],
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

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  MessageTile({@required this.message, @required this.sendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8, bottom: 8, left: sendByMe ? 0 : 24, right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin:
            sendByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(5, 5), // changes position of shadow
              ),
            ],
            borderRadius: sendByMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23))
                : BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
              colors: sendByMe
                  ? [Colors.blue[700], Colors.blueAccent[100]]
                  : [const Color(0xFF899be8), const Color(0xFF811be8)],
            )),
        child: Text(message.trim(),
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'OverpassRegular',
                fontWeight: FontWeight.w300)),
      ),
    );
  }
}

/*class ChatbarTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  ChatbarTile({this.userName, @required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        userName,
        textAlign: TextAlign.start,
        style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'OverpassRegular',
            fontWeight: FontWeight.w300),
      ),
    );
  }
}
*/