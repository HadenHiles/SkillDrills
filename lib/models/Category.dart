import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String id;
  final String title;
  final String description;
  final DocumentReference reference;

  Category.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['id'] != null),
        assert(map['title'] != null),
        assert(map['description'] != null),
        id = map['id'],
        title = map['title'],
        description = map['description'];

  Category.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
