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
    DrillType("reps", "Reps", "Number of repetitions", null, 1),
    DrillType("score", "Score", "Number of successful attempts out of a target score", null, 2),
    DrillType("time_elapsed", "Time elapsed", "How long a drill was performed", null, 3),
    DrillType("timer", "Timer", "Countdown from a set duration", Duration(minutes: 1).inSeconds, 4),
    DrillType("reps_in_time", "Reps in duration", "Number of repetitions in a set duration", Duration(minutes: 1).inSeconds, 5),
    DrillType("score_in_time", "Score in duration", "How many successful attempts out of target in a set duration", Duration(minutes: 1).inSeconds, 6),
    DrillType("duration_target", "Duration vs. Target", "How long the drill was performed versus a target duration", null, 7),
    DrillType("reps_time", "Time to perform reps", "How long it took to do a set number of reps", null, 8),
    DrillType("score_time", "Time to get score", "How long it took to achieve a target score", null, 9),
    DrillType("weighted_reps", "Weighted reps", "Number of repetitions with a set weight", null, 10),
    DrillType("assisted_reps", "Assisted reps", "Number of repetitions with a set assisted weight", null, 11),
  ];

  FirebaseFirestore.instance.collection('drill_types').doc(auth.currentUser.uid).collection('drill_types').get().then((snapshot) async {
    if (auth.currentUser.uid != null && snapshot.docs.length != drillTypes.length) {
      // Drill types don't match - replace them
      await Future.forEach(snapshot.docs, (dtDoc) {
        // Delete the activities categories first
        dtDoc.reference.collection('measurements').get().then((measurementSnapshots) {
          measurementSnapshots.docs.forEach((mDoc) {
            mDoc.reference.delete();
          });
        });

        // Then delete the activity itself
        dtDoc.reference.delete();
      });

      drillTypes.forEach((dt) {
        DocumentReference drillType = FirebaseFirestore.instance.collection('drill_types').doc(auth.currentUser.uid).collection('drill_types').doc();

        List<Measurement> measurements = [];

        switch (dt.id) {
          case "reps":
            measurements = [
              MeasurementResult("result", "amount", "Reps", 1, null),
            ];

            break;
          case "score":
            measurements = [
              MeasurementResult("result", "amount", "Score", 1, null),
              MeasurementTarget("target", "amount", "Target Score", 2, null, false),
            ];

            break;
          case "time_elapsed":
            measurements = [
              MeasurementResult("result", "duration", "Time", 1, null),
            ];

            break;
          case "timer":
            measurements = [
              MeasurementResult("result", "duration", "Timer", 1, null),
            ];

            break;
          case "reps_in_time":
            measurements = [
              MeasurementResult("result", "amount", "Reps", 1, null),
            ];

            break;
          case "score_in_time":
            measurements = [
              MeasurementResult("result", "amount", "Score", 1, null),
              MeasurementTarget("target", "amount", "Target Score", 2, null, false),
            ];

            break;
          case "duration_target":
            measurements = [
              MeasurementResult("result", "duration", "Time", 1, null),
              MeasurementTarget("target", "duration", "Target Time", 2, null, false),
            ];

            break;
          case "reps_time":
            measurements = [
              MeasurementResult("result", "amount", "Reps", 1, null),
              MeasurementResult("result", "duration", "Time", 2, null),
            ];

            break;
          case "score_time":
            measurements = [
              MeasurementResult("result", "amount", "Score", 1, null),
              MeasurementResult("result", "duration", "Time", 2, null),
              MeasurementTarget("target", "amount", "Target Score", 3, null, false),
            ];

            break;
          case "weighted_reps":
            measurements = [
              MeasurementResult("result", "amount", "Weight", 1, null),
              MeasurementResult("result", "amount", "Reps", 2, null),
            ];

            break;
          case "assisted_reps":
            measurements = [
              MeasurementResult("result", "amount", "Assisted", 1, null),
              MeasurementResult("result", "amount", "Reps", 2, null),
            ];

            break;
          default:
        }

        measurements.forEach((m) {
          _saveMeasurement(drillType, m);
        });

        dt.measurements = measurements;
        drillType.set(dt.toMap());
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
