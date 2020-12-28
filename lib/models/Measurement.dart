import 'package:cloud_firestore/cloud_firestore.dart';

class Measurement {
  final String id;
  final String title;
  final String type;
  final dynamic value;
  final dynamic goal;
  final bool countdown;
  final DocumentReference reference;

  Measurement.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['id'] != null),
        assert(map['title'] != null),
        assert(map['type'] != null),
        id = map['id'],
        title = map['title'],
        type = map['type'],
        value = map['value'],
        goal = map['goal'],
        countdown = map['countdown'] != null ? map['countdown'] : false;

  Measurement.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data(), reference: snapshot.reference);
}