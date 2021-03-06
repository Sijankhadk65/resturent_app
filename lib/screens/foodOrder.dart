import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../classes/menu_items.dart';
import '../classes/order.dart';

import "../widgets/itemsCard.dart" as itemCard;

import '../classes/colorsScheme.dart';

Map<String, dynamic> orderData = Map<String, dynamic>();
Map<String, dynamic> tableData = Map<String, dynamic>();

List<menuItem> menu = List();
List<customerOrderData> order = List();
String docID = "";
int totalPrice = 0;
String tableID = "";
GlobalKey<ScaffoldState> scffoldState;

class FoodOrder extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;
  FoodOrder(this.documentSnapshot);
  @override
  Widget build(BuildContext context) {
    return FoodOrderScreen(documentSnapshot);
  }
}

class FoodOrderScreen extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  FoodOrderScreen(this.documentSnapshot);
  @override
  _OrderState createState() {
    return _OrderState();
  }
}

class _OrderState extends State<FoodOrderScreen> {
  @override
  void initState() {
    super.initState();
    tableID = widget.documentSnapshot.documentID;
    tableData = widget.documentSnapshot.data;
    CollectionReference collectionReference =
        Firestore.instance.collection("menu");
    collectionReference.getDocuments().then((document) {
      document.documents.forEach((doc) {
        this.setState(() {
          menu.add(new menuItem(doc.documentID, doc['name'], doc['price']));
        });
      });
    });
    collectionReference = Firestore.instance.collection("tables");
    collectionReference.getDocuments().then((document) {
      document.documents.forEach((doc) {
        if (doc.documentID == tableID) {
          if (doc['status'] == "empty" || doc['status'] == "reserved") {
            DocumentReference documentReference =
                Firestore.instance.collection("tables").document(tableID);
            tableData['status'] = "active";
            documentReference.updateData(tableData).whenComplete(() {
              CollectionReference cr = Firestore.instance.collection("orders");
              Map<String, dynamic> initialOrder = {
                "floor": tableData['floorID'],
                "items": [],
                "table": tableID,
                "totalPrice": 0
              };
              cr.add(initialOrder).whenComplete(() {}).catchError((error) {
                print(error);
              });
            }).catchError((error) {
              print(error);
            });
          }
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    menu.clear();
    totalPrice = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        key: scffoldState,
        appBar: AppBar(
          title: Text(
            "${widget.documentSnapshot['name']}",
            style: TextStyle(fontSize: 30.0, fontFamily: "Ost"),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add_circle_outline),
              onPressed: () async {
                await showSearch(context: context, delegate: SearchMenu());
              },
            )
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(30.0),
            child: Chip(
              backgroundColor: colorScheme().body1,
              label: Text(
                "Total: $totalPrice",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "mon",
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection("orders")
              .where("table", isEqualTo: widget.documentSnapshot.documentID)
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
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: ListView(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            children: snapshot.data.documents
                                .map((DocumentSnapshot document) {
                              orderData = document.data;
                              docID = document.documentID;
                              return OrderItems(
                                  document['items'], document['totalPrice']);
                            }).toList()),
                      ),
                    ],
                  );
            }
          },
        ),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              child: Icon(Icons.update),
              onPressed: () {
                if (docID != "") {
                  DocumentReference documentReference =
                      Firestore.instance.collection("orders").document(docID);
                  documentReference.updateData(orderData).then((someData) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("Adding New Item"),
                    ));
                  }).whenComplete(() {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("Updated"),
                    ));
                  }).catchError((error) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("$error"),
                    ));
                  });
                } else {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("No Items Added."),
                  ));
                }
              },
            );
          },
        ),
      ),
    );
  }
}

class OrderItems extends StatefulWidget {
  final List<dynamic> items;
  final int price;
  OrderItems(this.items, this.price);
  @override
  _OrderItemsState createState() {
    return _OrderItemsState();
  }
}

class _OrderItemsState extends State<OrderItems> {
  @override
  void initState() {
    super.initState();
    this.setState(() {
      totalPrice = widget.price;
    });
    widget.items.forEach((item) {
      order.add(new customerOrderData(
          item['name'], item['price'], item['quantity'], item['totalPrice']));
    });
  }

  @override
  void dispose() {
    super.dispose();
    order.clear();
    orderData.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        orderData['items'].isEmpty
            ? Container(
                padding: EdgeInsets.all(15.0),
                child: Center(
                  child: Text(
                    "No Orders yet!",
                    style: TextStyle(
                        fontFamily: "Lobster",
                        fontSize: 30.0,
                        color: Colors.black54),
                  ),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: order.length,
                physics: ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Dismissible(
                    background: new Container(
                      color: Colors.red,
                      margin: EdgeInsets.only(bottom: 12.5, top: 12.5),
                      child: Center(
                        child: Text(
                          "Deleting Item",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Lobster",
                              fontSize: 45.0),
                        ),
                      ),
                    ),
                    key: Key(order.elementAt(index).name),
                    onDismissed: (direction) {
                      this.setState(() {
                        totalPrice -= order.elementAt(index).totalPrice;
                        order.removeAt(index);
                        orderData['items'] =
                            order.map<dynamic>((f) => f.toJson()).toList();
                        orderData['totalPrice'] = totalPrice;
                        print(totalPrice);
                      });
                    },
                    child: itemCard.itemsCard(
                      itemName: order.elementAt(index).name,
                      itemPrice: order.elementAt(index).price,
                      itemQty: order.elementAt(index).qty,
                      onChanged: (int value) {
                        if (value > 0) {
                          this.setState(() {
                            totalPrice =
                                totalPrice - order.elementAt(index).totalPrice;
                          });
                          this.setState(() {
                            order.elementAt(index).qty = value;
                            order.elementAt(index).totalPrice =
                                order.elementAt(index).qty *
                                    order.elementAt(index).price;
                          });
                          this.setState(() {
                            totalPrice =
                                totalPrice + order.elementAt(index).totalPrice;
                          });
                          this.setState(() {
                            orderData['items'] =
                                order.map<dynamic>((f) => f.toJson()).toList();
                            orderData['totalPrice'] = totalPrice;
                          });
                        } else {
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content:
                                  Text("Do you want to remove the item?")));
                        }
                      },
                    ),
                  );
                },
              )
      ],
    );
  }
}

class SearchMenu extends SearchDelegate<String> {
  List<String> menuItemsNames = menu.map((item) => item.name).toList();
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
          showSuggestions(context);
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final newItem = menu.where((item) => item.name == query);
    Widget finalWidget;
    if (order.map((f) => f.name).toList().contains(newItem.elementAt(0).name) ==
        false) {
      order.add(new customerOrderData(newItem.elementAt(0).name,
          newItem.elementAt(0).price, 1, newItem.elementAt(0).price));
      orderData['items'] = order.map<dynamic>((f) => f.toJson()).toList();
      totalPrice += newItem.elementAt(0).price;
      orderData['totalPrice'] = totalPrice;
      DocumentReference documentReference =
          Firestore.instance.collection("orders").document(docID);
      documentReference.updateData(orderData);
      close(context, query);
    }else{
      finalWidget = Center(
        child: Text("Item Not Added."),
      );
    }
    return finalWidget;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestionList = query.isEmpty
        ? menuItemsNames
        : menuItemsNames.where((p) => p.toLowerCase().contains(query)).toList();
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
            onTap: () {
              query = suggestionList.elementAt(index);
              showResults(context);
            },
            leading: Icon(Icons.fastfood),
            title: RichText(
                text: TextSpan(
                    text: suggestionList
                        .elementAt(index)
                        .substring(0, query.length),
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                  TextSpan(
                      text: suggestionList
                          .elementAt(index)
                          .substring(query.length),
                      style: TextStyle(
                        color: Colors.grey,
                      ))
                ])));
      },
    );
  }
}
