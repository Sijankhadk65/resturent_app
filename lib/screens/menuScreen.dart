import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/menuDiplayer.dart' as displayer;

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return menuDisplay();
  }
}

class menuDisplay extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _displayState();
  }
}

class _displayState extends State<menuDisplay> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: StreamBuilder(
      stream: Firestore.instance.collection("category").snapshots(),
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
            return ListView(
              children: snapshot.data.documents.map<Widget>((document) {
                return displayer.menuBuilder(document['name']);
              }).toList(),
            );
          case ConnectionState.done:
            return Text('${snapshot.data} (closed)');
        }
      },
    ));
  }
}
