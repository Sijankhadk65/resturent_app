import 'package:flutter/material.dart';

import 'stepperTouch.dart';

import '../classes/colorsScheme.dart';

class itemsCard extends StatefulWidget {
  String itemName;
  int itemPrice, itemQty;
  Function onChanged;
  itemsCard({this.itemName, this.itemPrice, this.itemQty, this.onChanged});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _cardState();
  }
}

class _cardState extends State<itemsCard> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        margin:
            EdgeInsets.only(bottom: 12.5, left: 15.0, right: 15.0, top: 12.5),
        padding: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colorScheme().body2,
                  Color(0xFF3F324D),
                  colorScheme().body1
                ]),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 2.0),
                  blurRadius: 3.0),
            ],
            borderRadius: BorderRadius.circular(10.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: Text(
                    "${widget.itemName}",
                    style: TextStyle(
                        fontFamily: "mon",
                        fontSize: 25.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
                StepperTouch(
                  initialValue: widget.itemQty,
                  onChanged: widget.onChanged,
                  withSpring: false,
                )
                // changer.quantityChanger(
                //     Icon(
                //       Icons.add_circle_outline,
                //       color: Colors.cyan,
                //     ),
                //     widget.onAdd),
                // changer.quantityChanger(
                //     Icon(
                //       Icons.remove_circle_outline,
                //       color: Colors.red,
                //     ),
                //     widget.onSub),
              ],
            ),
            Divider(),
            Row(
              children: <Widget>[
                Container(
                  child: Transform(
                    transform: Matrix4.identity()..scale(0.9),
                    child: Chip(
                      backgroundColor: Colors.white,
                      label: Text(
                        "Total: ${widget.itemQty * widget.itemPrice}",
                        style: TextStyle(
                          color: colorScheme().accentColor,
                          fontSize: 11.5,
                          fontFamily: "Ost",
                        ),
                      ),
                    ),
                  ),
                ),
                Transform(
                  transform: Matrix4.identity()..scale(0.9),
                  child: Chip(
                    backgroundColor: Colors.white,
                    label: Text(
                      "Price: ${widget.itemPrice}",
                      style: TextStyle(
                          color: colorScheme().accentColor,
                          fontSize: 11.5,
                          fontFamily: "Ost"),
                    ),
                  ),
                )
              ],
            )
          ],
        ));
  }
}
