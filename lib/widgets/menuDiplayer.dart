import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";

import 'menuItemsDisplayer.dart' as itemsDisplay;

class menuBuilder extends StatefulWidget {
  String name;
  menuBuilder(this.name);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _BuilderState();
  }
}

class _BuilderState extends State<menuBuilder> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        margin: EdgeInsets.all(15.0),
        child: StreamBuilder(
          stream: Firestore.instance
              .collection("menu")
              .where("category", isEqualTo: widget.name)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Text('Select lot');
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.active:
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "${widget.name}",
                      style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.w600,
                          fontFamily: "nuito"),
                    ),
                    ListView(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        children: snapshot.data.documents
                            .map<Widget>((document) =>
                                itemsDisplay.MenuItemsDiplayer(document))
                            .toList())
                  ],
                );
              case ConnectionState.done:
                return Text('${snapshot.data} (closed)');
            }
          },
        ));
  }
}
