
import 'package:flutter/material.dart';
import 'package:bakenda/login.dart';


class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("Book Tracker",style: TextStyle(fontWeight:FontWeight.bold,color: Colors.black),),

      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.account_circle, 
              size: 96, 
              color: Theme.of(context).colorScheme.primary,
            
            ),
            Text(
              'Welcome',
              style: Theme.of(context).textTheme.headline4,
            ),
            ElevatedButton(
                  onPressed: () {Navigator.push( context,MaterialPageRoute(builder: (context) => const Login()),);},
                  child: const Text(
                    "Login",
                  ),
                ),
         
          ],
        ),
        
      ),
    );
  }
}