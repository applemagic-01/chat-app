import 'package:chat_app/components/my_drawer.dart';
import 'package:chat_app/components/user_tile.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/chat/chat_services.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
   HomePage({super.key});
  // chat and auth service

  final ChatServices _chatServices = ChatServices();
  final AuthService _authService = AuthService();

  //get current user

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(title: Text("Home"),
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.grey,
      elevation: 0,
      ),
      drawer: const MyDrawer(),
      body: _buildUserList(),
          ); 
  }

  //build list of users except for the current logged in user
  Widget _buildUserList(){
    return StreamBuilder(stream: _chatServices.getUserStream(), builder: (context, snapshot) {
      //errors
      if(snapshot.hasError){
        return const Text("Error");
      }

      //loading
      if(snapshot.connectionState== ConnectionState.waiting){
        return const Text("Loading...");
      }


      //return list of users
      if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Text("No users found");
      }
      //return list of users
      final users = (snapshot.data as List).cast<Map<String, dynamic>>();
      return ListView(
        children: users.map<Widget>((userData) => _builderListItem(userData, context)).toList(),
      );
    },
    );
  }

  //individual list title for user
  Widget _builderListItem(Map<String,dynamic> userData,BuildContext context){
    //displaying all user except for current user
    if(userData["email"]!= _authService.getCurrentUser()!.email){
      return UserTile(
      text: userData["email"],
      onTap: (){
        Navigator.push(context,
      MaterialPageRoute(
        builder: (context)=> ChatPage(
          receiverEmail: userData["email"],
          receiverID: userData["uid"],
        )
        ),
        );
      },
    );
    }else{
      return Container();
    }

  }
}