import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/components/my_textfield.dart';
import 'package:flutter/material.dart';


class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final void Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  void register(BuildContext context){
    //get auth  service
    final auth = AuthService();
    //if password match-> create user
    if(_passwordController.text == _confirmPasswordController.text){
    try{
      auth.signUpWithEmailAndPassword(_emailController.text, _passwordController.text,);
      } catch (e){
     showDialog(context: context, builder: (context)=>AlertDialog(
    title: Text(e.toString()),
  )
  );
      }
    }
    // if password don't match-> show error
    else{
      showDialog(context: context, builder: (context)=> const AlertDialog(
    title: Text("Password doesn't match!"),
    ));
    }
  }

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
          Text("let's create a new account for you",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16.0
          ),),
          const SizedBox(height: 25,),
          MyTextfield(hintText: "Email",obscureText: false,controller: _emailController,),
          const SizedBox(height: 10,),
          MyTextfield(hintText: "Password",obscureText: true,controller: _passwordController,),
          const SizedBox(height: 10,),
          MyTextfield(hintText: "Confirm password",obscureText: true,controller: _confirmPasswordController,),
          const SizedBox(height: 25,),
          MyButton(text: "Register",onTap: ()=>register(context),),
          const SizedBox(height: 25,),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Already have an account? ",style: TextStyle(color: Theme.of(context).colorScheme.primary),),
              GestureDetector(onTap: onTap, child: Text("Login now",style: TextStyle(fontWeight: FontWeight.bold),)),
            ],
          )
        ],
      ),),

    );
  }
}