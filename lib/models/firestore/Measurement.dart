import 'package:cloud_firestore/cloud_firestore.dart';

/// Measurement
/// @type A string representation of the measurement type (count, duration)
class Measurement {
  final String type;
  DocumentReference reference;

  Measurement.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['type'] != null),
        type = map['type'];

  Map<String, dynamic> toMap() {
    return {
      'type': type,
    };
  }

  Measurement.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
