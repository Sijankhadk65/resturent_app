import 'package:flutter/material.dart';

import 'stepperTouch.dart';
// import 'package:stepper_touch/stepper_touch.dart';
// import 'quantityChanger.dart' as changer;

class itemsCard extends StatefulWidget {
  String itemName;
  int itemPrice, itemQty;
  Function onChanged;
  itemsCard(
      {this.itemName, this.itemPrice, this.itemQty,this.onChanged});
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
            color: Colors.blue,
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
                        fontWeight: FontWeight.w600),
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
                      label: Text(
                        "Quantity: ${widget.itemQty}",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 11.5,
                            fontFamily: "Ost"),
                      ),
                    ),
                  ),
                ),
                Transform(
                  transform: Matrix4.identity()..scale(0.9),
                  child: Chip(
                    label: Text(
                      "Price: ${widget.itemPrice}",
                      style: TextStyle(
                          color: Colors.grey,
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
