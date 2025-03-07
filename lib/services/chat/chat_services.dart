import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatServices {
  //get instance of firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  //get user stream
Stream<List<Map<String,dynamic>>> getUserStream (){
  return _firestore.collection("Users").snapshots().map((snapshot){
    return snapshot.docs.map((doc){
      //go through each individual user
      final user = doc.data();
      //return user
      return user;
    }).toList();
  });
}


  //send message
Future<void> sendMessage(String receiverID, message) async {
  //get user info
    final String currentUserID= _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();
  //create a new message
    Message newMessage = Message(
      senderID: currentUserID, 
      senderEmail: currentUserEmail, 
      receiverID: receiverID, 
      message: message, 
      timestamp: timestamp);

  //construct chatroom ID for the two users(sorted to ensure uniqueness)
  List<String> ids = [currentUserID,receiverID];
  ids.sort(); //sort the id (this ensures the chatroom id is same for only 2 peoples)
  String chatRoomID= ids.join('_');

  //add new message to database
  await _firestore.collection("chat_rooms").doc(chatRoomID).collection("messages").add(newMessage.toMap());

}


  //receive message

  Stream<QuerySnapshot> getMessages(String userID,otherUserID){
    //construct chatroom id for 2 users
     List<String> ids = [userID,otherUserID];
  ids.sort(); //sort the id (this ensures the chatroom id is same for only 2 peoples)
  String chatRoomID= ids.join('_');

  return _firestore.collection("chat_rooms").doc(chatRoomID).collection("messages").orderBy("timestamp",descending: false).snapshots();
  }



}