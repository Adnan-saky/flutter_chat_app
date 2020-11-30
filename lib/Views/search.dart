import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/Views/conversation.dart';
import 'package:flutter_chat_app/helper/constans.dart';
import 'package:flutter_chat_app/services/database.dart';


class search extends StatefulWidget {
  @override
  _searchState createState() => _searchState();
}

class _searchState extends State<search> {
  TextEditingController searchEditingController = new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot searchResultSnapshot;
  bool isLoading = false;
  bool haveUserSearched = false;

  initiateSearch() async {
    if (searchEditingController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await databaseMethods
          .searchByName(searchEditingController.text)
          .then((snapshot) {
        searchResultSnapshot = snapshot;
        print("$searchResultSnapshot");
        setState(() {
          isLoading = false;
          haveUserSearched = true;
        });
      });
    }
  }

  ///search List
  Widget SearchList() {
    return searchResultSnapshot != null
        ? ListView.builder(
            itemCount: searchResultSnapshot.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return userTile(
                searchResultSnapshot.documents[index].data["userName"],
                searchResultSnapshot.documents[index].data["userEmail"],
              );
            })
        : Container();
  }

  ///create Chatroom , send user to conversation , push replacement..

  createChatRoomAndStartConversation(String userName) {

    List<String> user = [userName, Constants.myName];

    String chatRoomId ;

    Map<String, dynamic> chatRoom = {
      "user": user,
      "chatRoomId": chatRoomId = getChatRoomId(userName, Constants.myName)
    };
    databaseMethods.addChatRoom(chatRoom, chatRoomId);
    Navigator.push(context, MaterialPageRoute(builder: (context)=>Conversation(chatRoomId)));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  getChatRoomId(String a, String b) {
    if (a.compareTo(b)>0) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF811be8),
        title: Text("Search"),
      ),
      body: isLoading ? Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ): Container(
        color: Color(0xFFD6cbe8),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
              color: Colors.black12,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchEditingController,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                          hintText: "search username ...",
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
                        gradient: LinearGradient(
                            colors: [
                              const Color(0x36FFFFFF),
                              const Color(0x0FFFFFFF)
                            ],
                            begin: FractionalOffset.topLeft,
                            end: FractionalOffset.bottomRight),
                        borderRadius: BorderRadius.circular(40)),
                    child: IconButton(
                      padding: EdgeInsets.fromLTRB(7, 02, 20, 0),
                      icon: Icon(
                        Icons.search,
                        size: 25,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        initiateSearch();
                      },
                    ),
                  ),
                ],
              ),
            ),
            SearchList(),
          ],
        ),
      ),
    );
  }

  Widget userTile(String userName, String userEmail) {
    //String userName = "";
    //String userEmail = "";
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              Text(
                userEmail,
                style: TextStyle(color: Colors.black, fontSize: 16),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatRoomAndStartConversation(userName);


            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(24)),
              child: Text(
                "Message",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }
}
