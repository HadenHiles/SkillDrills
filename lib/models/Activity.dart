import 'package:cloud_firestore/cloud_firestore.dart';
import 'Category.dart';

class Activity {
  final String id;
  final String name;
  final List<Category> categories;
  final String createdBy;
  final DocumentReference reference;

  Activity.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['id'] != null),
        assert(map['name'] != null),
        assert(map['categories'] != null),
        assert(map['created_by'] != null),
        id = map['id'],
        name = map['name'],
        categories = map['categories'],
        createdBy = map['created_by'];

  Activity.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
