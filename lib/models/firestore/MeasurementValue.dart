import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skill_drills/models/firestore/Measurement.dart';

/// MeasurementValue
/// @value The value of the saved measurement
class MeasurementValue extends Measurement {
  final dynamic value;
  DocumentReference reference;

  MeasurementValue.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['type'] != null),
        value = map['value'],
        super.fromMap(map);

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = super.toMap();
    map['value'] = value;

    return map;
  }

  MeasurementValue.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
