import 'package:bakenda/firebase_options.dart';
import 'package:bakenda/home_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:bakenda/color_schemes.g.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
).then((value) => print(value.options.projectId));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
Future<bool?> checkIfUserIsLoggedIn() async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isloggedIn') ?? false;
 }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.deepPurple,
        colorScheme: lightColorScheme,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        colorScheme: darkColorScheme,
      ),
      home: FutureBuilder<bool?>(
        future: checkIfUserIsLoggedIn(),
        builder: (context, snapshot) {
          if(snapshot.hasData)
          {if(snapshot.data ?? false){return home_screen();}
          else{return loginScreen();
          }}
          else{
            return Center(child: CircularProgressIndicator());
          }
          
        }
      ), // Set LoginScreen as the home page
    );
  }
}
