import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skill_drills/models/Activity.dart';
import 'package:skill_drills/models/Category.dart';

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

    // Setup the default activities in the user's activities collection
    List<Activity> activities = [
      Activity(
        "Hockey",
        [
          Category("1", "Shooting", null),
          Category("2", "Passing", null),
          Category("3", "Stickhandling", null),
          Category("4", "Skating", null),
        ],
        null,
      ),
    ];
    activities.forEach((a) {
      FirebaseFirestore.instance.collection('activities').doc(auth.currentUser.uid).collection('activities').add(a.toMap());
    });
  });
}
