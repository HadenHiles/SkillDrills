import 'package:cloud_firestore/cloud_firestore.dart';

class SkillDrillsUser {
  final String displayName;
  final String email;
  final String photoURL;
  DocumentReference reference;

  SkillDrillsUser(this.displayName, this.email, this.photoURL);

  SkillDrillsUser.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['displayName'] != null),
        assert(map['email'] != null),
        assert(map['photoURL'] != null),
        displayName = map['displayName'],
        email = map['email'],
        photoURL = map['photoURL'];

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'email': email,
      'photoURL': photoURL,
    };
  }

  SkillDrillsUser.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
