import 'package:bakenda/capitalise.dart';
import 'package:bakenda/login.dart';

import 'package:bakenda/user_modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  signoutUser() async{
    await FirebaseAuth.instance.signOut().then((value) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isloggedIn', false);
      Navigator.push(
     context,
      MaterialPageRoute(builder: (context) => const Login()),
      );
    });
  }
   Future <UserModal> getUserDetaild() async{
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    String userId = preferences.getString("userId") ?? "";
    print(userId);
    //CollectionReference users = FirebaseFirestore.instance.collection("users");
  var userResponse = await FirebaseFirestore.instance.collection("user").doc(userId).get();
  UserModal userModal = UserModal.fromDocumentSnapshot(userResponse);
  print(userModal.firstName);
  return userModal;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: 
        FloatingActionButton(
          child: Icon(Icons.logout_rounded),
          onPressed: () async { signoutUser();
          },
          
          ),
          

          body: FutureBuilder<UserModal>(
            future: getUserDetaild(),
            builder: (context, snapshot) {
             if(snapshot.hasData){
              return ProfileWidget(userData: snapshot.data!);
              
             }
             else{
              return CircularProgressIndicator();
             }
            }
          ),
      appBar: AppBar(automaticallyImplyLeading: kIsWeb ? false: true,
      title: Text("Profile Screen"),
       actions: [        
        ],
    )
    );
      
    
  }
}

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({
    super.key,
    required this.userData,
  });
 final UserModal userData;
  @override
  Widget build(BuildContext context) {
    return Center(
         child: Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
     
     SizedBox(height: 10),
     CircleAvatar(radius: 50,backgroundColor: Colors.cyan,foregroundColor: Colors.black,
     child: Text(userData.firstName![0].capitalize(),style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold),)
     
     ),
      SizedBox(height: 20),
      Row(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(userData.firstName!.capitalize()  ),
          SizedBox(width: 5,),
          Text(userData.lastName!.capitalize()),
        ],
      ),
      SizedBox(height: 5),
      Text(              
       userData.email!
      ),
     
    ],
        ),
      );
  }
}