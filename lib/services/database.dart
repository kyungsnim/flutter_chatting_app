import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  /// 유저 아이디 검색
  getUserByUsername(String username) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  /// 유저 이메일 검색
  getUserByEmail(String email) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  /// 회원가입시 회원정보 DB에 저장
  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection('users').add(userMap).catchError((e) {
      print(e.toString());
    });
  }

  /// 채팅룸 만들기
  createChatRoom(String roomId, roomInfoMap) {
    FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(roomId)
        .set(roomInfoMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  /// 상대에게 메시지 보내기
  addConversationMessages(String roomId, messageMap) {
    FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(roomId)
        .collection('chats')
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  /// 모든 메시지 목록 가져오기
  getConversationMessages(String roomId) async {
    return await FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(roomId)
        .collection('chats')
        .orderBy('sendDt')
        .snapshots();
  }

  /// 모든 채팅룸 가져오기
  getChatRooms(String username) async {
    return await FirebaseFirestore.instance
        .collection('chatRoom')
        .where('users', arrayContains: username)
        .snapshots();
  }
}
