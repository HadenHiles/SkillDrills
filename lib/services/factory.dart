import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skill_drills/models/firestore/Activity.dart';
import 'package:skill_drills/models/firestore/Category.dart';
import 'package:skill_drills/models/firestore/DrillType.dart';
import 'package:skill_drills/models/firestore/Measurement.dart';
import 'package:skill_drills/models/firestore/MeasurementTarget.dart';
import 'package:skill_drills/models/firestore/MeasurementResult.dart';
import 'package:skill_drills/models/firestore/SkillDrillsUser.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

void bootstrap() {
  addUser();
  bootstrapActivities();
  bootstrapDrillTypes();
}

/// Add user to users collection
void addUser() {
  FirebaseFirestore.instance.collection('users').doc(auth.currentUser.uid).get().then((snapshot) {
    if (auth.currentUser.uid != null && !snapshot.exists) {
      FirebaseFirestore.instance.collection('users').doc(auth.currentUser.uid).set(SkillDrillsUser(auth.currentUser.displayName, auth.currentUser.email, auth.currentUser.photoURL).toMap());
    }
  });
}

/**
 * ACTIVITY functions
 */

/// Bootstrap the activities if user has none (first launch)
void bootstrapActivities() {
  FirebaseFirestore.instance.collection('activities').doc(auth.currentUser.uid).collection('activities').get().then((snapshot) {
    if (auth.currentUser.uid != null && !(snapshot.docs.length > 0)) {
      resetActivities();
    }
  });
}

/// Reset activities for the current user
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

/// Save individual category to activity categories collection
void _saveActivityCategory(a, c) {
  DocumentReference category = FirebaseFirestore.instance.collection('activities').doc(auth.currentUser.uid).collection('activities').doc(a.id).collection('categories').doc();
  c.id = category.id;
  category.set(c.toMap());
}

/**
 * DRILL TYPE functions
 */

/// Bootstrap the drill types with our predetermined drill types
void bootstrapDrillTypes() {
  List<DrillType> drillTypes = [
    DrillType("reps", "Reps", "Number of repetitions", null),
    DrillType("score", "Score", "Number of successful attempts out of the set total", null),
    DrillType("time_elapsed", "Time elapsed", "How long the drill was performed", null),
    DrillType("timer", "Timer", "Countdown from the set duration", null),
    DrillType("reps_in_time", "Reps in time", "Number of repetitions in the set duration", null),
    DrillType("score_in_time", "Score in time", "How many successful attempts out of x in the set duration", null),
    DrillType("time_elapsed_target_time", "Time elapsed vs. Target Time", "How long the drill was performed versus the set target time", null),
    DrillType("reps_time", "Time to perform reps", "How long it took to do the set number of reps", null),
    DrillType("score_time", "Time to get score", "How long it took to achieve the set score", null),
    DrillType("weighted_reps", "Weighted reps", "Number of repetitions with the set weight", null),
    DrillType("assisted_reps", "Assisted reps", "Number of repetitions with the set assisted weight", null),
  ];

  FirebaseFirestore.instance.collection('drill_types').doc(auth.currentUser.uid).collection('drill_types').get().then((snapshot) async {
    if (auth.currentUser.uid != null && snapshot.docs.length != drillTypes.length) {
      // Drill types don't match - replace them
      await Future.forEach(snapshot.docs, (doc) {
        // Delete the activities categories first
        doc.reference.collection('measurements').get().then((measurementSnapshots) {
          measurementSnapshots.docs.forEach((mDoc) {
            mDoc.reference.delete();
          });
        });

        // Then delete the activity itself
        doc.reference.delete();
      });

      drillTypes.forEach((dt) {
        DocumentReference drillType = FirebaseFirestore.instance.collection('drill_types').doc(auth.currentUser.uid).collection('drill_types').doc();
        drillType.set(dt.toMap());

        List<Measurement> measurements = [];

        switch (dt.id) {
          case "reps":
            measurements = [
              MeasurementResult("amount", "Reps", null),
            ];

            break;
          case "score":
            measurements = [
              MeasurementResult("amount", "Score", null),
              MeasurementTarget("amount", "Target", null, false),
            ];

            break;
          case "time_elapsed":
            measurements = [
              MeasurementResult("duration", "Time", null),
            ];

            break;
          case "timer":
            measurements = [
              MeasurementResult("duration", "Timer", null),
            ];

            break;
          case "reps_in_time":
            measurements = [
              MeasurementResult("amount", "Reps", null),
            ];

            break;
          case "score_in_time":
            measurements = [
              MeasurementResult("amount", "Score", null),
              MeasurementTarget("amount", "Target", null, false),
            ];

            break;
          case "time_elapsed_target_time":
            measurements = [
              MeasurementResult("duration", "Time", null),
              MeasurementTarget("duration", "Target Time", null, false),
            ];

            break;
          case "reps_time":
            measurements = [
              MeasurementResult("amount", "Reps", null),
              MeasurementResult("duration", "Time", null),
            ];

            break;
          case "score_time":
            measurements = [
              MeasurementResult("amount", "Score", null),
              MeasurementResult("duration", "Time", null),
              MeasurementTarget("amount", "Target", null, false),
            ];

            break;
          case "weighted_reps":
            measurements = [
              MeasurementResult("amount", "Weight", null),
              MeasurementResult("amount", "Reps", null),
            ];

            break;
          case "assisted_reps":
            measurements = [
              MeasurementResult("amount", "Assisted", null),
              MeasurementResult("amount", "Reps", null),
            ];

            break;
          default:
        }

        measurements.forEach((m) {
          _saveMeasurement(drillType, m);
        });
      });
    }
  });
}

/// Save individual category to activity categories collection
void _saveMeasurement(dt, m) {
  DocumentReference measurement = FirebaseFirestore.instance.collection('drill_types').doc(auth.currentUser.uid).collection('drill_types').doc(dt.id).collection('measurements').doc();
  m.id = measurement.id;
  measurement.set(m.toMap());
}
