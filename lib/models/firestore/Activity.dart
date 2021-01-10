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
        categories = mapCategories(map['categories']),
        createdBy = map['created_by'];

  Map<String, dynamic> toMap() {
    List<Map> cats = [];
    categories.forEach((cat) {
      cats.add(cat.toMap());
    });

    return {
      'id': id,
      'title': title,
      'categories': cats,
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

List<Category> mapCategories(List<dynamic> categories) {
  return categories.map((cat) => Category.fromMap(cat)).toList();
}
