import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yvnet/components/mybuttons.dart';
import 'package:yvnet/helper_function/helper_function.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //text controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  //login method
  void login() async{
    //show circular indicator
    progressIndication(context);

    //try sign in
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
      if(!mounted) return;
      Navigator.pop(context);
      //if(context.mounted) Navigator.pop(context);
    }on FirebaseAuthException catch (e){
        //pop loading  circle
        Navigator.pop(context);

        //display error message
        displayErrorMessage(e.code, context);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //logo
                    Image.asset('Images/logo.png',height: 100, width: 100,),
                  //Text
                    const Text("Be a", 
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              
                    Text("VOLUNTEER", 
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amber[400]),),
              
                    const Text("The smallest act of kindess is worth more than the grandest intention.", 
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900),),
          
                    //User
                    const SizedBox(height: 15),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12)),
                              hintText: 'Email',
                              hintStyle: const TextStyle( fontSize: 12), 
                              prefixIcon: const Icon(Icons.email),
                            ),
                            obscureText: false,
                            validator: (value) {
                              if(value!.isEmpty){
                                return 'Required!';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          //password
                          TextFormField(
                            controller: passwordController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12)),
                              hintText: 'Password',
                              hintStyle: const TextStyle( fontSize: 12), 
                              prefixIcon: const Icon(Icons.key),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if(value!.isEmpty){
                                return 'Required!';
                              }
                              return null;
                            },
                          ),                                                      
                        ],
                      ),
                    ),
                    
                    //Login Button
                    const SizedBox(height: 150),
                    MyButton(text: 'Login', onTap: () {
                      if(_formKey.currentState!.validate()){
                        login();
                      }
                    },),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         const Text(
                          'Don\'t have an Account? '
                          ,style: TextStyle(fontSize: 12),),
                         GestureDetector(
                          onTap: widget.onTap,
                          child: const Text(
                            'Register here', 
                            style: TextStyle(
                              color: Colors.black, 
                              fontSize: 12, 
                              fontWeight: FontWeight.bold),
                            ),
                         ),
                       ],
                     )
                  //Sign up Button
              ]),
            ),
          ),
        ),
      ),
    );
  }
}