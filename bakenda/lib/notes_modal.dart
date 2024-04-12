

class NotesModal {
String? note;
String? userid;
String? documentId;
bool? completed; // Added field for completion status
double? progress;

NotesModal({

this.userid,
this.note,
this.documentId,
this.completed,
this.progress

});

NotesModal.fromDocumentSnapshot(Map<String, dynamic>doc)
:
userid = doc["user_id"],
note = doc["Note"],
documentId = doc["document_id"],
completed = doc["completed"] ?? false, // Default value for completed is false
progress = (doc["progress"] ?? 0.0).toDouble(); // Default value for progress is 0.0

Map<String, dynamic> toMap() {

  return {

    "user_id": userid,
    "Note": note,
    "document_id":documentId,
    "completed": completed,
    "progress": progress,
  };
}


}
