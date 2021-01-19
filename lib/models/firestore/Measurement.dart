import 'package:cloud_firestore/cloud_firestore.dart';

/// Measurement
/// @type A string representation of the measurement type (amount, duration)
class Measurement {
  final String type;
  final String metric;
  final String label;
  final int order;
  dynamic value;
  dynamic target;
  bool reverse;
  DocumentReference reference;

  Measurement(this.type, this.metric, this.label, this.order, this.value, this.target, this.reverse);

  Measurement.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['type'] != null),
        assert(map['metric'] != null),
        type = map['type'],
        metric = map['metric'],
        label = map['label'],
        order = map['order'],
        value = map['value'],
        target = map['target'],
        reverse = map['reverse'] ?? false;

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'metric': metric,
      'label': label,
      'order': order,
      'value': value,
      'target': target,
      'reverse': reverse,
    };
  }

  Measurement.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
