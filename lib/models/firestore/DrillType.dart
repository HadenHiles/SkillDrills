import 'package:cloud_firestore/cloud_firestore.dart';

import 'Measurement.dart';

class DrillType {
  final String title;
  final String descriptor;
  final List<Measurement> measurements;
  final DocumentReference reference;

  DrillType(this.title, this.descriptor, this.measurements, this.reference);

  DrillType.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['title'] != null),
        assert(map['descriptor'] != null),
        assert(map['measurements'] != null),
        title = map['title'],
        descriptor = map['descriptor'],
        measurements = map['measurements'];

  Map<String, dynamic> toMap() {
    List<Map> measures = [];
    measurements.forEach((m) {
      measures.add(m.toMap());
    });

    return {
      'title': title,
      'descriptor': descriptor,
      'measurements': measures,
    };
  }

  DrillType.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
