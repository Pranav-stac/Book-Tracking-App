
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModal {
String? firstName;
String? lastName;
String? email;
String? userid;
String? photo;

UserModal({
this.firstName,
this.lastName,
this.email,
this.userid,
this.photo

});

UserModal.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>>doc)
:firstName = doc["first_name"],
lastName = doc["last_name"],
email = doc["email"],
userid = doc["user_id"],
photo = doc["photo"];

Map<String, dynamic> toMap() {

  return {
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "user_id": userid,
    "photo": photo,
  };
}


}
