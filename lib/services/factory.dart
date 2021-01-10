import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skill_drills/models/firestore/Activity.dart';
import 'package:skill_drills/models/firestore/Category.dart';
import 'package:skill_drills/models/firestore/SkillDrillsUser.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

void bootstrap() {
  // Determine whether or not to add the user to the users collection
  FirebaseFirestore.instance.collection('users').doc(auth.currentUser.uid).get().then((snapshot) {
    if (auth.currentUser.uid != null && !snapshot.exists) {
      FirebaseFirestore.instance.collection('users').doc(auth.currentUser.uid).set(SkillDrillsUser(auth.currentUser.displayName, auth.currentUser.email, auth.currentUser.photoURL).toMap());
    }
  });

  // Determine whether or not to create (reset) the activities
  FirebaseFirestore.instance.collection('activities').doc(auth.currentUser.uid).collection('activities').get().then((snapshot) {
    if (auth.currentUser.uid != null && !(snapshot.docs.length > 0)) {
      resetActivities();
    }
  });
}

// Reset / initialize the activities for the current user
Future<void> resetActivities() async {
  // Clear out any existing activities for the signed in user
  FirebaseFirestore.instance.collection('activities').doc(auth.currentUser.uid).collection('activities').get().then((snapshot) async {
    await Future.forEach(snapshot.docs, (doc) {
      // Delete the activities categories first
      doc.reference.collection('categories').get().then((categorySnapshots) {
        categorySnapshots.docs.forEach((cDoc) {
          cDoc.reference.delete();
        });
      });

      // Then delete the activity itself
      doc.reference.delete();
    });

    // Setup the default activities in the user's activities collection
    List<Activity> activities = [
      Activity(
        "Hockey",
        null,
      ),
      Activity(
        "Basketball",
        null,
      ),
      Activity(
        "Baseball",
        null,
      ),
      Activity(
        "Golf",
        null,
      ),
      Activity(
        "Soccer",
        null,
      ),
      Activity(
        "Weight Training",
        null,
      ),
    ];
    activities.forEach((a) {
      DocumentReference activity = FirebaseFirestore.instance.collection('activities').doc(auth.currentUser.uid).collection('activities').doc();
      a.id = activity.id;
      activity.set(a.toMap());

      if (a.title == "Hockey") {
        List<Category> categories = [
          Category("Skating"),
          Category("Shooting"),
          Category("Stickhandling"),
          Category("Passing"),
        ];

        categories.forEach((c) {
          _saveActivityCategory(activity, c);
        });
      } else if (a.title == "Basketball") {
        List<Category> categories = [
          Category("Shooting"),
          Category("Rebounding"),
          Category("Passing"),
          Category("Dribbling"),
          Category("Blocking"),
          Category("Stealing"),
        ];

        categories.forEach((c) {
          _saveActivityCategory(activity, c);
        });
      } else if (a.title == "Baseball") {
        List<Category> categories = [
          Category("Hitting"),
          Category("Bunting"),
          Category("Throwing"),
          Category("Pitching"),
          Category("Base Running"),
          Category("Stealing"),
          Category("Sliding"),
          Category("Ground Balls"),
          Category("Pop Fly's"),
        ];

        categories.forEach((c) {
          _saveActivityCategory(activity, c);
        });
      } else if (a.title == "Golf") {
        List<Category> categories = [
          Category("Drive"),
          Category("Approach"),
          Category("Putt"),
          Category("Lay-Up"),
          Category("Chip"),
          Category("Punch"),
          Category("Flop"),
          Category("Draw"),
          Category("Fade"),
        ];

        categories.forEach((c) {
          _saveActivityCategory(activity, c);
        });
      } else if (a.title == "Soccer") {
        List<Category> categories = [
          Category("Ball Control"),
          Category("Passing"),
          Category("Stamina"),
          Category("Dribbling"),
          Category("Shooting"),
          Category("Penalty Shots"),
          Category("Free Kicks"),
          Category("Keep-up"),
          Category("Tricks/Moves"),
        ];

        categories.forEach((c) {
          _saveActivityCategory(activity, c);
        });
      } else if (a.title == "Weight Training") {
        List<Category> categories = [
          Category("Core"),
          Category("Arms"),
          Category("Back"),
          Category("Chest"),
          Category("Legs"),
          Category("Shoulders"),
          Category("Olympic"),
          Category("Full Body"),
          Category("Cardio"),
        ];

        categories.forEach((c) {
          _saveActivityCategory(activity, c);
        });
      }
    });
  });
}

void _saveActivityCategory(a, c) {
  DocumentReference category = FirebaseFirestore.instance.collection('activities').doc(auth.currentUser.uid).collection('activities').doc(a.id).collection('categories').doc();
  c.id = category.id;
  category.set(c.toMap());
}
