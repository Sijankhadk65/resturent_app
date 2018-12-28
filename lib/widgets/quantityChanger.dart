import "package:flutter/material.dart";

class quantityChanger extends StatefulWidget {
  Function _onPressed;
  Icon _icon;
  quantityChanger(this._icon,this._onPressed);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _changerState();
  }
}

class _changerState extends State<quantityChanger> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return IconButton(
        padding: EdgeInsets.all(0.0),
        icon: widget._icon,
        onPressed: widget._onPressed);
  }
}
