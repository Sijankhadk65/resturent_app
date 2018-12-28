import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/tableCards.dart' as tableCards;


class Floor extends StatelessWidget {
  final String docId, floorName;
  Floor(this.docId, this.floorName);
  @override
  Widget build(BuildContext context) {
    return FloorScreen(docId, floorName);
  }
}

class FloorScreen extends StatefulWidget {
  final String id, name;
  FloorScreen(this.id, this.name);
  @override
  FloorScreenState createState() {
    return FloorScreenState();
  }
}

class FloorScreenState extends State<FloorScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            child: Center(
              child: Text(
                "${widget.name}",
                style:TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600
                )
              ),
            ),
            margin: EdgeInsets.only(bottom: 15.0,top:15.0),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection("tables")
                  .where("floorID", isEqualTo: widget.id)
                  .snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Text('Press button to start.');
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  default:
                    if (snapshot.hasError)
                      return Text('Error: ${snapshot.error}');
                    else
                      return GridView.count(
                        crossAxisCount: 2,
                        children: snapshot.data.documents.map((f) => tableCards.TableCards(f)).toList(),
                      );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}


