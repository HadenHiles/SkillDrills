import 'package:cloud_firestore/cloud_firestore.dart';

import 'Measurement.dart';

class DrillType {
  final String id;
  final String title;
  final String descriptor;
  final List<Measurement> measurements;
  final DocumentReference reference;

  DrillType.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['id'] != null),
        assert(map['title'] != null),
        assert(map['descriptor'] != null),
        assert(map['measurements'] != null),
        id = map['id'],
        title = map['title'],
        descriptor = map['descriptor'],
        measurements = map['measurements'];

  DrillType.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
