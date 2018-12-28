import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../screens/foodOrder.dart';

class TableCards extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;
  TableCards(this.documentSnapshot);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      child: RaisedButton(
        padding: EdgeInsets.all(15.0),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => FoodOrder(documentSnapshot)));
        },
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: Icon(
                        Icons.fastfood,
                        color: getCardColors(documentSnapshot['status']),
                        size: 50,
                      ),
                    ),
                  ),
                  Text(
                    "${documentSnapshot['name']}",
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Color getCardColors(String status) {
    if (status == "active") {
      return Colors.green;
    } else if (status == "reserved") {
      return Colors.yellow;
    } else if (status == "empty") {
      return Colors.red;
    }
  }
}
