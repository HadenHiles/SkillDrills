import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skill_drills/models/firestore/Measurement.dart';

/// MeasurementValue
/// @value The value of the saved measurement
class MeasurementResult extends Measurement {
  String id;
  final String type;
  final String metric;
  final String label;
  final int order;
  dynamic value;
  DocumentReference reference;

  MeasurementResult(this.type, this.metric, this.label, this.order, this.value) : super(type, metric, label, order, value, null, false);

  MeasurementResult.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['type'] != null),
        assert(map['metric'] != null),
        id = map['id'],
        type = map['type'],
        metric = map['metric'],
        label = map['label'],
        order = map['order'],
        value = map['value'],
        super.fromMap(map);

  MeasurementResult.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
