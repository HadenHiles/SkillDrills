import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skill_drills/models/firestore/Measurement.dart';

/// MeasurementValue
/// @value The value of the saved measurement
class MeasurementResult extends Measurement {
  String id;
  final String type;
  final String label;
  final int order;
  final dynamic value;
  DocumentReference reference;

  MeasurementResult(this.type, this.label, this.order, this.value) : super(type, label, order);

  MeasurementResult.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['type'] != null),
        id = map['id'],
        type = map['type'],
        label = map['label'],
        order = map['order'],
        value = map['value'],
        super.fromMap(map);

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = super.toMap();
    map['value'] = value;

    return map;
  }

  MeasurementResult.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
