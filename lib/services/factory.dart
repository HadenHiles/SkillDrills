import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

void initFactoryDefaults() {
  FirebaseFirestore.instance.collection('activities').doc(auth.currentUser.uid).collection('activities').get().then((snapshot) {
    if (auth.currentUser.uid != null && !(snapshot.docs.length > 0)) {
      resetActivities();
    }
  });
}

// Reset / initialize the activities for the current user
Future<void> resetActivities() async {
  // Clear out any existing activities for the signed in user
  FirebaseFirestore.instance.collection('activities').doc(auth.currentUser.uid).collection('activities').get().then((snapshot) {
    snapshot.docs.forEach((doc) {
      doc.reference.delete();
    });
  });

  // Setup the default activities in the user's activities collection
  FirebaseFirestore.instance.collection('activities').doc(auth.currentUser.uid).collection('activities').add({
    'title': "Hockey",
    'categories': [
      {
        "id": "1",
        "title": "Shooting",
        "description": null,
      },
      {
        "id": "2",
        "title": "Passing",
        "description": null,
      },
      {
        "id": "3",
        "title": "Stickhandling",
        "description": null,
      },
      {
        "id": "4",
        "title": "Skating",
        "description": null,
      },
    ],
    'created_by': null
  });
}
