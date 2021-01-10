import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skill_drills/models/firestore/Measurement.dart';

/// MeasurementTarget
/// @target The target for the measurement (what MeasurementValue is the user aiming for)
/// @reverse Is the measurement target incremental or decremental
class MeasurementTarget extends Measurement {
  final dynamic target;
  final bool reverse;
  final DocumentReference reference;

  MeasurementTarget.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['type'] != null),
        target = map['target'],
        reverse = map['reverse'] ?? false,
        super.fromMap(map);

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = super.toMap();
    map['target'] = target;
    map['reverse'] = reverse;

    return map;
  }

  MeasurementTarget.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
