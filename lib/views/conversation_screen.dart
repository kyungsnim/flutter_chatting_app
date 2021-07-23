import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/helper/constants.dart';
import 'package:flutter_chat_app/services/database.dart';
import 'package:flutter_chat_app/widgets/widget.dart';

class ConversationScreen extends StatefulWidget {
  String roomId;

  ConversationScreen(this.roomId);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController messageTextEditingController = TextEditingController();
  Stream? chatMessageStream;

  // Widget chatMessageList() {
  //   // return
  // }

  Widget chatMessageList() {
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapshot) {
        QuerySnapshot? querySnapshot = snapshot.data as QuerySnapshot<Object?>?;
        return snapshot.hasData
            ? ListView.builder(
                itemCount: querySnapshot?.size,
                itemBuilder: (context, index) {
                  Map<String, dynamic> messageData =
                      querySnapshot?.docs[index].data() as Map<String, dynamic>;
                  return MessageTile(messageData['message'],
                      messageData['sendBy'] == Constants.myName);
                })
            : Container();
      },
    );
  }

  sendMessage() {
    if (messageTextEditingController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        'message': messageTextEditingController.text,
        'sendBy': Constants.myName,
        'sendDt': DateTime.now()
      };

      databaseMethods.addConversationMessages(widget.roomId, messageMap);
      messageTextEditingController.text = '';
    }
  }

  @override
  void initState() {
    databaseMethods.getConversationMessages(widget.roomId).then((val) {
      setState(() {
        chatMessageStream = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Stack(
          children: [
            chatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: messageTextEditingController,
                    style: TextStyle(color: Colors.white),
                    decoration: textFieldInputDecoration('search message..'),
                  )),
                  InkWell(
                    onTap: () {
                      // initSearch();
                      sendMessage();
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: LinearGradient(
                                colors: [Colors.white70, Colors.white38])),
                        padding: EdgeInsets.all(15),
                        child: Icon(
                          Icons.send,
                          size: 20,
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  String message;
  bool isSendByMe;

  MessageTile(this.message, this.isSendByMe);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      padding: EdgeInsets.all(5),
      child: Container(
        padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: isSendByMe ? BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10)) :
            BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
            color: isSendByMe ? Colors.yellow : Colors.white60,
          ),
          child: Text(message, style: TextStyle(color: Colors.black87, fontSize: 16))),
    );
  }
}
