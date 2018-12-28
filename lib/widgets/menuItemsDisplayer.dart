import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../classes/menu_items.dart';

class MenuItemsDiplayer extends StatefulWidget {
  DocumentSnapshot documentSnapshot;
  MenuItemsDiplayer(this.documentSnapshot);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DisplayerState();
  }
}

class DisplayerState extends State<MenuItemsDiplayer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.0),
      margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey, offset: Offset(0.0, 5.0), blurRadius: 10.0)
          ],
          borderRadius: BorderRadius.circular(5.0)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          widget.documentSnapshot.data.isEmpty
              ? Text("No Items")
              : Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 15.0, right: 7.5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.documentSnapshot['name'],
                          style: TextStyle(
                              fontFamily: "nuito", fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
          Container(
            margin: EdgeInsets.only(left: 7.5, right: 15.0),
            child: Center(
              child: Text(
                "Rs.${widget.documentSnapshot['price']}/-",
                style: TextStyle(fontFamily: "nuito", color: Colors.green),
              ),
            ),
          ),
          Center(
            child: widget.documentSnapshot['isAvailable'] == true
                ? Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                  )
                : Icon(
                    Icons.highlight_off,
                    color: Colors.red,
                  ),
          ),
        ],
      ),
    );
  }
}
