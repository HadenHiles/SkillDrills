import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skill_drills/models/firestore/Measurement.dart';

class DrillType {
  final String title;
  final String descriptor;
  List<Measurement> measurements;
  DocumentReference reference;

  DrillType(this.title, this.descriptor);

  DrillType.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['title'] != null),
        assert(map['descriptor'] != null),
        assert(map['measurements'] != null),
        title = map['title'],
        descriptor = map['descriptor'],
        measurements = map['measurements'];

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'descriptor': descriptor,
    };
  }

  DrillType.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
