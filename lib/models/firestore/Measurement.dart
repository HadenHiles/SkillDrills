import 'package:cloud_firestore/cloud_firestore.dart';

class Measurement {
  final String title;
  final String type;
  final dynamic value;
  final dynamic goal;
  final bool countdown;
  final DocumentReference reference;

  Measurement.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['title'] != null),
        assert(map['type'] != null),
        title = map['title'],
        type = map['type'],
        value = map['value'],
        goal = map['goal'],
        countdown = map['countdown'] != null ? map['countdown'] : false;

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'type': type,
      'value': value,
      'goal': goal,
      'countdown': countdown,
    };
  }

  Measurement.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
