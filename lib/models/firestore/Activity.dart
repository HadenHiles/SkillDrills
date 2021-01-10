import 'package:cloud_firestore/cloud_firestore.dart';
import 'Category.dart';

class Activity {
  String id;
  final String title;
  List<Category> categories;
  final String createdBy;
  DocumentReference reference;

  Activity(this.title, this.createdBy);

  Activity.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['title'] != null),
        id = map['id'],
        title = map['title'],
        categories = map['categories'],
        createdBy = map['created_by'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'created_by': createdBy,
    };
  }

  Activity.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data(), reference: snapshot.reference);

  // For select dialogs
  @override
  String toString() => title;

  @override
  operator ==(a) => a is Activity && a.id == id;

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ createdBy.hashCode;
}
