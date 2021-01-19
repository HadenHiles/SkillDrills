import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skill_drills/models/firestore/Category.dart';
import 'package:skill_drills/models/firestore/Measurement.dart';
import 'Activity.dart';
import 'DrillType.dart';

class Drill {
  final String title;
  final String description;
  final Activity activity;
  final DrillType drillType;
  List<Measurement> measurements;
  List<Category> categories;
  DocumentReference reference;

  Drill(this.title, this.description, this.activity, this.drillType);

  Drill.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['title'] != null),
        assert(map['description'] != null),
        assert(map['activity'] != null),
        assert(map['drill_type'] != null),
        title = map['title'],
        description = map['description'],
        activity = Activity.fromMap(map['activity']),
        drillType = DrillType.fromMap(map['drill_type']);

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'activity': activity.toMap(),
      'drill_type': drillType.toMap(),
    };
  }

  Drill.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
