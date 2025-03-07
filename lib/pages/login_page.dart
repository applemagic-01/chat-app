import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/components/my_textfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();

//tap to go to register
final void Function()? onTap;

void login(BuildContext context) async{
  //get authservice

  final authService= AuthService();

  //try login
try {
  await authService.signInWithEmailAndPassword(_emailController.text, _passwordController.text);
  
} catch (e) {
  showDialog(context: context, builder: (context)=>AlertDialog(
    title: Text(e.toString()),
  )
  );
}

}


  LoginPage({super.key,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.message,size: 60.0,color: Theme.of(context).colorScheme.primary,),
          const SizedBox(height: 50,),
          Text("Welcome back, you've been missed!",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16.0
          ),),
          const SizedBox(height: 25,),
          MyTextfield(hintText: "Email",obscureText: false,controller: _emailController,),
          const SizedBox(height: 10,),
          MyTextfield(hintText: "Password",obscureText: true,controller: _passwordController,),
          const SizedBox(height: 25,),
          MyButton(text: "Login",onTap: ()=>login(context),),
          const SizedBox(height: 25,),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Not a member? ",style: TextStyle(color: Theme.of(context).colorScheme.primary),),
              GestureDetector(onTap:onTap,
              child:  Text("Register now",style: TextStyle(fontWeight: FontWeight.bold),)),
            ],
          )
        ],
      ),),

    );
  }
}