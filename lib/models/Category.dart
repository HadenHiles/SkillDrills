import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String title;
  DocumentReference reference;

  Category(this.title);

  Category.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['title'] != null),
        title = map['title'];

  Map<String, dynamic> toMap() {
    return {
      'title': title,
    };
  }

  Category.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
