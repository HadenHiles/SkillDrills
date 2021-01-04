import 'package:cloud_firestore/cloud_firestore.dart';
import 'Category.dart';

class Activity {
  final String title;
  final List<Category> categories;
  final String createdBy;
  DocumentReference reference;

  Activity(this.title, this.categories, this.createdBy);

  Activity.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['title'] != null),
        assert(map['categories'] != null),
        title = map['title'],
        categories = mapCategories(map['categories']),
        createdBy = map['created_by'];

  Map<String, dynamic> toMap() {
    List<Map> cats = [];
    categories.forEach((cat) {
      cats.add(cat.toMap());
    });

    return {
      'title': title,
      'categories': cats,
      'created_by': createdBy,
    };
  }

  Activity.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data(), reference: snapshot.reference);
}

List<Category> mapCategories(List<dynamic> categories) {
  return categories.map((cat) => Category.fromMap(cat)).toList();
}
