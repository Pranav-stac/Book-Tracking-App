
import 'package:bakenda/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class RegistartionScreen extends StatefulWidget {
  const RegistartionScreen({super.key});

  @override
  State<RegistartionScreen> createState() => _RegistartionScreenState();
}

class _RegistartionScreenState extends State<RegistartionScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController= TextEditingController();
   TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController= TextEditingController();
  registerUser ({
    required String email,
    required String password,
    required String firstname,
    required String lastname,
    }
  ) {
    try {
       final credential = FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: email,
    password: password,
  ) .then((value) {

    print(value.user?.uid.toString());
    adduserdata(
      firstname: firstname,
      lastname: lastname,
      email: email,
      userid: value.user?.uid ?? "",
    );
    Fluttertoast.showToast(msg: "User registered");
  });
        } on FirebaseAuthException catch (e) {
  if (e.code == 'weak-password') {
   Fluttertoast.showToast(msg: "Password is weak");
  } else if (e.code == 'email-already-in-use') {
    Fluttertoast.showToast(msg: "Email already exists");
  } }
    catch(e){}
  }
  adduserdata( 
 {required String firstname,
  required String lastname,
  required String email,
  required String userid,
  }){
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection("user").doc(userid).set({"first_name": firstname,
    "last_name": lastname,
    "created_at": DateTime.now(),
    "updated_at": DateTime.now(),
    "email": email,
    "user_id": userid,
    "photo": ""
    }
    ).then((value) async {
      // final SharedPreferences prefs = await SharedPreferences.getInstance();
  // await prefs.setBool('isloggedIn', false);
      Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                  );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: firstnameController,
                  decoration: InputDecoration(
                    labelText: "ENTER FIRSTNAME",
                    labelStyle: TextStyle(fontSize: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: lastnameController,
                  decoration: InputDecoration(
                      labelText: "ENTER LASTNAME",
                      labelStyle: TextStyle(fontSize: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(

                      labelText: "ENTER EMAIL",
                      labelStyle: TextStyle(fontSize: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                      labelText: "ENTER PASSWORD",
                      labelStyle: TextStyle(fontSize: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    registerUser(
                    email: emailController.text,
                    password: passwordController.text,
                    firstname: firstnameController.text,
                    lastname: lastnameController.text);
                  },
                  child: const Text(
                    "Register",
                  ),
                ),
              ],
            ),
          ),
         Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Already have an account?"),
              SizedBox(
                width: 5,
              ),
              TextButton( 
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                  );
                },
                child: Text("Login"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
  