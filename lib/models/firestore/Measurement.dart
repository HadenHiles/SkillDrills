import 'package:cloud_firestore/cloud_firestore.dart';

class Measurement {
  final String type;
  final dynamic value;
  final dynamic target;
  final bool countdown;
  final DocumentReference reference;

  Measurement.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['type'] != null),
        type = map['type'],
        value = map['value'],
        target = map['target'],
        countdown = map['countdown'];

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'value': value,
      'target': target,
      'countdown': countdown,
    };
  }

  Measurement.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
