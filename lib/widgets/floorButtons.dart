import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../screens/floor_screen.dart' as floorScreen;

import 'package:flutter_svg/flutter_svg.dart';

class FloorButtons extends StatelessWidget {
  DocumentSnapshot documentSnapshot;
  FloorButtons(this.documentSnapshot);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.all(10.0),
      child: RaisedButton(
        padding: EdgeInsets.all(15.0),
        onPressed: () {
          Scaffold.of(context).showBottomSheet((context) {
            return floorScreen.Floor(
                documentSnapshot.documentID, documentSnapshot['name']);
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: Center(
                  child: SvgPicture.asset(
                "assets/pics/svg/construction.svg",
                height: 50,
                width: 50,
                color: Theme.of(context).primaryColor,
              )),
            ),
            Text(
              "${documentSnapshot['name']}",
              style: TextStyle(),
            ),
            Divider(),
            Text(
              "Tables: ${documentSnapshot['tables'].toString()}",
              style: TextStyle(color: Colors.grey, fontSize: 10.0),
            ),
          ],
        ),
      ),
    );
  }
}
