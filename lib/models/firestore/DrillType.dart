import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skill_drills/models/firestore/Measurement.dart';

class DrillType {
  final String id; // Ensure unique
  final String title;
  final String descriptor;
  final Duration timeLimit;
  List<Measurement> measurements;
  DocumentReference reference;

  DrillType(this.id, this.title, this.descriptor, this.timeLimit);

  DrillType.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['id'] != null),
        assert(map['title'] != null),
        assert(map['descriptor'] != null),
        assert(map['measurements'] != null),
        id = map['id'],
        title = map['title'],
        descriptor = map['descriptor'],
        measurements = map['measurements'],
        timeLimit = map['time_limit'];

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'descriptor': descriptor,
    };
  }

  DrillType.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
