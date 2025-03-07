import 'package:chat_app/components/chat_bubble.dart';
import 'package:chat_app/components/my_textfield.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/chat/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

  const ChatPage({super.key, required this.receiverEmail, required this.receiverID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  //text controller
  final TextEditingController _messageController = TextEditingController();

  //get chat and auth services
  final ChatServices _chatServices = ChatServices();
  final AuthService _authService = AuthService();

  //for text field focus
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    myFocusNode.addListener((){
        if(myFocusNode.hasFocus){
          //cause the delay so that the keyboard has time to show up
          //then the amount of remaining space will be calculated
          //then scroll down
          Future.delayed(const Duration(microseconds: 500),()=>scrollDown());
        }
    });

    //wait for listview to build then scroll down
    Future.delayed(const Duration(milliseconds: 500),()=>scrollDown());

  }

@override
  void dispose(){
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

//scroll controller
final ScrollController _scrollController = ScrollController();
void scrollDown(){
  _scrollController.animateTo(_scrollController.position.maxScrollExtent,
  duration: const Duration(seconds: 1),
   curve: Curves.fastOutSlowIn);
}

  //send message
  void sendMessage() async {
    //if there is anything to send inside text field
    if (_messageController.text.isNotEmpty) {
      //send message
      await _chatServices.sendMessage(widget.receiverID, _messageController.text);

      //clear controller
      _messageController.clear();
    }
      scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(widget.receiverEmail),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: Column(
        children: [
          //display messages
          Expanded(
            child: _buildMessageList(),
          ),

          //user input
          _builderUserInput()
        ],
      ),
    );
  }

  //build message list
  Widget _buildMessageList() {
    final String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder<QuerySnapshot>(
      stream: _chatServices.getMessages(senderID, widget.receiverID),
      builder: (context, snapshot) {
        // errors
        if (snapshot.hasError) {
          return const Text("Error");
        }

        // loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...!");
        }

        // check if snapshot has data
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text("No messages yet.");
        }

        // return list view
        return ListView(
          controller: _scrollController,
          children: snapshot.data!.docs
              .map<Widget>((doc) => _buildMessageItem(context, doc))
              .toList(),
        );
      },
    );
  }

  //build message Item
  Widget _buildMessageItem(BuildContext context, DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Determine if the current user is the sender
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;

    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubble(message: data['message'], isCurrentUser: isCurrentUser),
        ],
      ),
    );
  }

  //build message input
  Widget _builderUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Row(
        children: [
          Expanded(
              child: MyTextfield(
                  hintText: "Type a message",
                  obscureText: false,
                  focusNode: myFocusNode,
                  controller: _messageController)),
                  
      
          //send button
          Container(
            decoration: BoxDecoration(color: Colors.green,
            shape: BoxShape.circle),
            margin: EdgeInsets.only(right: 25),
            child: IconButton(onPressed: sendMessage, icon: const Icon(Icons.arrow_upward)))
        ],
      ),
    );
  }
}