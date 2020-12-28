import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

void initFactoryDefaults() async {
  hasActivities().then((val) {
    if (auth.currentUser != null && (val == null || !val)) {
      resetActivities();
    }
  });
}

// ignore: missing_return
Future<bool> hasActivities() async {
  FirebaseFirestore.instance.collection('activities').doc(auth.currentUser.uid).get().then((snapshot) {
    return snapshot.exists;
  });
}

// Reset / initialize the activities for the current user
Future<void> resetActivities() async {
  // Clear out any existing activities for the signed in user
  FirebaseFirestore.instance.collection('activities').doc(auth.currentUser.uid).get().then((snapshot) {
    snapshot.reference.delete();
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
