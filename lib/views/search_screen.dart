import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/helper/constants.dart';
import 'package:flutter_chat_app/services/database.dart';
import 'package:flutter_chat_app/widgets/widget.dart';

import 'conversation_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  TextEditingController searchTextEditingController = TextEditingController();
  DatabaseMethods databaseMethods = DatabaseMethods();
  QuerySnapshot? searchSnapshot;

  initSearch() {
      databaseMethods.getUserByUsername(searchTextEditingController.text).then((val) {
      // Future를 반환하기 때문에 다 완료된 then 이후에 setState를 통해 val 값을 넣어 상태변화를 시켜줘야 함
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  searchList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: searchSnapshot?.size,
      itemBuilder: (context, index) {
        // var searchData = searchSnapshot?.docs[index].data();
        // 위의 표현처럼 data()를 바로 담으려 하니 널 체크를 하라고 오류가 떠서 이것 저것 해보던 중 cast를 통해 해결책을 찾았다.
        Map<String, dynamic> searchData = searchSnapshot?.docs[index].data() as Map<String, dynamic>;
        return searchTile(
          username: searchData['username'],
          email: searchData['email'],
        );
      },
    );
  }

  Widget searchTile({username, email}) {
    return Container(
        padding: EdgeInsets.only(top: 10),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(username!, style: simpleTextFieldStyle()),
                Text(email!, style: simpleTextFieldStyle()),
              ],
            ),
            Spacer(),
            InkWell(
              onTap: () => createChatRoom(username),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text('Message'),
              ),
            )
          ],
        )
    );
  }

  createChatRoom(String username) {

    if(username != Constants.myName) {
      /// 상대방이름, 내이름
      List<String> userList = [username, Constants.myName];

      /// 상대방이름, 내이름 정렬해서 방이름 만들기
      var roomId = makeChatRoomId(username, Constants.myName);

      Map<String, dynamic> roomInfoMap = {
        'users': userList,
        'roomId': roomId
      };

      databaseMethods.createChatRoom(roomId, roomInfoMap);
      Navigator.push(context, MaterialPageRoute(builder: (context) => ConversationScreen(roomId)));
    } else {
      /// 본인을 검색한 경우 채팅룸을 만들면 안된다.? 안되나?? 나와 대화하기 이런거 있자나……
      print('You cannot send message to yourself');
    }

  }

  makeChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return '$b\_$a';
    } else {
      return '$a\_$b';
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(child: TextField(
                    controller: searchTextEditingController,
                    style: TextStyle(color: Colors.white),
                    decoration: textFieldInputDecoration('search username..'),
                  )),
                  InkWell(
                    onTap: () {
                      initSearch();
                      },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(
                          colors: [
                            Colors.white70,
                            Colors.white38
                          ]
                        )
                      ),
                      padding: EdgeInsets.all(15),
                      child: Icon(Icons.search, size: 30,)
                    ),
                  )
                ],
              ),
            ),
            searchSnapshot != null ?
            searchList() : Container(height: 30,child: Placeholder(fallbackHeight: 30,)),
          ],
        )
      )
    );
  }
}