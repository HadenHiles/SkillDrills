import 'package:cloud_firestore/cloud_firestore.dart';

/// Measurement
/// @type A string representation of the measurement type (amount, duration)
class Measurement {
  final String type;
  final String label;
  DocumentReference reference;

  Measurement(this.type, this.label);

  Measurement.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['type'] != null),
        type = map['type'],
        label = map['label'];

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'label': label,
    };
  }

  Measurement.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
