import 'package:cloud_firestore/cloud_firestore.dart';

/// Measurement
/// @type A string representation of the measurement type (amount, duration)
class Measurement {
  final String type;
  final String metric;
  final String label;
  final int order;
  DocumentReference reference;

  Measurement(this.type, this.metric, this.label, this.order);

  Measurement.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['type'] != null),
        assert(map['metric'] != null),
        type = map['type'],
        metric = map['metric'],
        label = map['label'],
        order = map['order'];

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'metric': metric,
      'label': label,
      'order': order,
    };
  }

  Measurement.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
