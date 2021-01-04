import 'package:cloud_firestore/cloud_firestore.dart';
import 'Activity.dart';
import 'Category.dart';
import 'DrillType.dart';

class Drill {
  final String id;
  final String title;
  final String description;
  final Activity activity;
  final Category category;
  final DrillType drillType;
  final DocumentReference reference;

  Drill.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['id'] != null),
        assert(map['title'] != null),
        assert(map['description'] != null),
        assert(map['activity'] != null),
        assert(map['category'] != null),
        assert(map['drill_type'] != null),
        id = map['id'],
        title = map['title'],
        description = map['description'],
        activity = map['activity'],
        category = map['category'],
        drillType = map['drill_type'];

  Drill.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
