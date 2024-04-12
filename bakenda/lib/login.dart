import 'package:bakenda/home_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bakenda/reg_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';



class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController= TextEditingController();
  loginUser ({
    required String email,
    required String password,}
  ) {
    try {
       final credential = FirebaseAuth.instance.signInWithEmailAndPassword(
    email: email,
    password: password,
  ) .then((value) async {Fluttertoast.showToast(msg: "Login Succesful");
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isloggedIn', true);
  await prefs.setString("userId", value.user?.uid ?? "");
  print(value.user?.uid);
   Navigator.push(
     context,
      MaterialPageRoute(builder: (context) => const home_screen()),
      );
  
  });
        } on FirebaseAuthException catch (e) {
  if (e.code == 'weak-password') {
   Fluttertoast.showToast(msg: "Password is weak");
  } else if (e.code == 'email-already-in-use') {
    Fluttertoast.showToast(msg: "Email already exists");
  } }
    catch(e){}
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: "Enter Email Id",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.all(15.0)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    
                    const SizedBox(height: 20),
                  ],
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: "Enter Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    loginUser(email: emailController.text, password: passwordController.text);
                 
                  },
                  child: const Text("Login"),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Don't have an account?"),
              SizedBox(
                width: 5,
              ),
              TextButton( 
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegistartionScreen()),
                  );
                },
                child: Text("Sign Up"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
