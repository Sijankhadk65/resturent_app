import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/floorButtons.dart' as floors;

class Order extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return OrderScreen();
  }
}

class OrderScreen extends StatefulWidget {
  @override
  OrderScreenState createState() {
    // TODO: implement createState
    return OrderScreenState();
  }
}

class OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection("floors").snapshots(),
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
                        children:snapshot.data.documents.map((f) => floors.FloorButtons(f)).toList(),
                      );
                      // ListView(
                      //     shrinkWrap: true,
                      //     children: snapshot.data.documents
                      //         .map((DocumentSnapshot document) {
                      //       return FloorButton(document);
                      //     }).toList());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}


