import 'package:bakenda/login.dart';
import 'package:bakenda/notes_modal.dart';
import 'package:bakenda/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class home_screen extends StatefulWidget {
  const home_screen({super.key});

  @override
  State<home_screen> createState() => _home_screenState();
}

class _home_screenState extends State<home_screen> {
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
  addNoteDialog(){
    showDialog(context: context, builder: (context){
      TextEditingController addNoteController = TextEditingController();
      return AlertDialog(
        
        content: TextField(
          controller: addNoteController,
                    decoration: InputDecoration(
                    labelText: "Add Book ",
                    labelStyle: TextStyle(fontSize: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                actions: [
                  TextButton(onPressed: (){
                    
                print(addNoteController.text);
                UploadNotes(note: addNoteController.text);
                  }, child: Text("Add"))
                ],
      );
    });
  }
  UploadNotes({required String note}) async{
     final SharedPreferences preferences = await SharedPreferences.getInstance();
    String userId = preferences.getString("userId") ?? "";
    await FirebaseFirestore.instance.collection("Notes").add(
      {
        "user_id":userId,
        "Note": note,
        "created_at": DateTime.now(),
        "updated_at": DateTime.now(),
        
      },).then((value) {Navigator.pop(context);});
  }
  
  Stream<QuerySnapshot> getNotes() {    
    Stream<QuerySnapshot> notesStream = FirebaseFirestore.instance
    .collection("Notes")
    //.where("user_id",isEqualTo: userId)
    .snapshots();
    return notesStream;
    
  }
  String userId = "";
  @override
  void initState ()  {
    super.initState();
    getUserId();
   
  }
  getUserId() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
     userId = preferences.getString("userId") ?? "";
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HOME"),
        actions: [
          IconButton(onPressed: () async { Navigator.push(
     context,
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
          }, icon: Icon(Icons.person_2_rounded),
          ),
        ],
        
      ), floatingActionButton: FloatingActionButton(onPressed: () {
        addNoteDialog();
      },
      child: Icon(Icons.add_comment_sharp),),
      body:StreamBuilder(
  stream: getNotes(),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      if (snapshot.data!.docs.isNotEmpty) {
        List<NotesModal> notesList = [];

        for (var element in snapshot.data!.docs) {
          Map<String, dynamic> data = element.data() as Map<String, dynamic>;
          data["document_id"] = element.id;
          if (data["user_id"] == userId) {
            notesList.add(NotesModal.fromDocumentSnapshot(data));
          }
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: notesList.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 255, 116, 116),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                         
                      
                      SizedBox(height: 16.0),
                      Text(
                        notesList[index].note!,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Select Progress",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Slider(
          value: notesList[index].progress ?? 0.0,
          onChanged: (value) {
            // Update progress in Firestore when the slider is changed
            FirebaseFirestore.instance
              .collection("Notes")
              .doc(notesList[index].documentId)
              .update({'progress': value});
            setState(() {
              notesList[index].progress = value;
            });
          },
          
          min: 0.0,
          max: 100,
          divisions: 100,
          label: '${(notesList[index].progress ?? 0.0 * 100).round()}%',
        ),
                      IconButton(
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection("Notes")
                              .doc(notesList[index].documentId)
                              .delete();
                        },
                        
                        icon: Icon(Icons.delete_outline_outlined),
                      ),

                    ],
                  ),
                ),
              );
            },
          ),
        );
      } else {
        return Center(child: Text("No Books Added"));
      }
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  },
),






      );
  }
}

class notewidget extends StatelessWidget {
  const notewidget({
    super.key, required this.notes,
     
  });
  final List<NotesModal> notes;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(notes[index].note!
          ),
          trailing: IconButton(onPressed: () async {
       await FirebaseFirestore.instance.collection("Notes").doc(notes[index].documentId).delete();
          }, icon: Icon(Icons.delete_outline_outlined)),
        );
      }
     
    );
  }
}