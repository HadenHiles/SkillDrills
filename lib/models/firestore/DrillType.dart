import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skill_drills/models/firestore/Measurement.dart';

class DrillType {
  final String id; // Ensure unique
  final String title;
  final String descriptor;
  final int order;
  final int timerInSeconds;
  List<Measurement> measurements;
  DocumentReference reference;

  DrillType(this.id, this.title, this.descriptor, this.timerInSeconds, this.order);

  DrillType.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['id'] != null),
        assert(map['title'] != null),
        assert(map['descriptor'] != null),
        id = map['id'],
        title = map['title'],
        descriptor = map['descriptor'],
        measurements = map['measurements'],
        timerInSeconds = map['timer_in_seconds'],
        order = map['order'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'descriptor': descriptor,
      'timer_in_seconds': timerInSeconds,
      'order': order,
    };
  }

  DrillType.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data(), reference: snapshot.reference);

  // For select dialogs
  @override
  String toString() => title;

  @override
  operator ==(dt) => dt is DrillType && dt.id == id;

  @override
  int get hashCode => id.hashCode ^ title.hashCode;
}
