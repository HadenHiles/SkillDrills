import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skill_drills/models/firestore/Category.dart';
import 'package:skill_drills/models/firestore/Drill.dart';
import 'package:skill_drills/models/firestore/Measurement.dart';
import 'package:skill_drills/tabs/drills/DrillItem.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

class Drills extends StatefulWidget {
  Drills({Key key}) : super(key: key);

  @override
  _DrillsState createState() => _DrillsState();
}

class _DrillsState extends State<Drills> {
  Widget _buildDrills(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('drills').doc(auth.currentUser.uid).collection('drills').orderBy('title', descending: false).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Column(
              children: [
                LinearProgressIndicator(
                  minHeight: 5,
                ),
              ],
            );

          return _buildDrillList(context, snapshot.data.docs);
        });
  }

  Widget _buildDrillList(BuildContext context, List<DocumentSnapshot> snapshot) {
    List<DrillItem> items = [];

    snapshot.forEach((docSnap) {
      Drill d = Drill.fromSnapshot(docSnap);
      d.reference.collection('measurements').get().then((mSnap) {
        List<Measurement> measurements = [];

        mSnap.docs.forEach((m) {
          measurements.add(Measurement.fromSnapshot(m));
        });

        d.measurements = measurements;
      });

      d.reference.collection('categories').get().then((cSnap) {
        List<Category> categories = [];

        cSnap.docs.forEach((m) {
          categories.add(Category.fromSnapshot(m));
        });

        d.categories = categories;
      });

      items.add(
        DrillItem(
          drill: d,
          deleteCallback: _deleteDrill,
        ),
      );
    });

    return items.length > 0
        ? ListView(
            padding: EdgeInsets.only(top: 10),
            children: items,
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "There are no drills to display",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          );
  }

  void _deleteDrill(Drill drill) {
    FirebaseFirestore.instance.collection('drills').doc(auth.currentUser.uid).collection('drills').doc(drill.reference.id).delete();

    FirebaseFirestore.instance.collection('drills').doc(auth.currentUser.uid).collection('drills').doc(drill.reference.id).get().then((doc) {
      doc.reference.collection('measurements').get().then((mSnapshots) {
        mSnapshots.docs.forEach((mDoc) {
          mDoc.reference.delete();
        });
      });

      doc.reference.collection('categories').get().then((catSnapshots) {
        catSnapshots.docs.forEach((cDoc) {
          cDoc.reference.delete();
        });
      });

      doc.reference.delete();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildDrills(context);
  }
}
