import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../classes/menu_items.dart';
import '../classes/order.dart';

import "../widgets/itemsCard.dart" as itemCard;

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
  void addItem(List<menuItem> item) {
    this.setState(() {
      order.add(new customerOrderData(item.elementAt(0).name,
          item.elementAt(0).price, 1, item.elementAt(0).price));
      orderData['items'] = order.map((f) => f.toJson()).toList();
    });
  }

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
              cr.add(initialOrder).whenComplete(() {
                print("Initial Order Created");
              }).catchError((error) {
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
              onPressed: () {
                showSearch(context: context, delegate: SearchMenu());
              },
            )
          ],
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
                  return ListView(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      children: snapshot.data.documents
                          .map((DocumentSnapshot document) {
                        orderData = document.data;
                        docID = document.documentID;
                        return OrderItems(
                            document['items'], document['totalPrice']);
                      }).toList());
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
                  documentReference.updateData(orderData).whenComplete(() {
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
                  return itemCard.itemsCard(
                    itemName: order.elementAt(index).name,
                    itemPrice: order.elementAt(index).price,
                    itemQty: order.elementAt(index).qty,
                    onChanged: (int value) {
                      if (value >= 0) {
                        this.setState(() {
                          order.elementAt(index).qty = value;
                        });
                        this.setState(() {
                          orderData['items'] =
                              order.map<dynamic>((f) => f.toJson()).toList();
                        });
                      } else {
                        this.setState(() {
                          order.removeAt(index);
                          orderData['items'] =
                              order.map<dynamic>((f) => f.toJson()).toList();
                        });
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text("Item is not available")));
                      }
                    },
                  );
                },
              )
      ],
    );
  }
}

class SearchMenu extends SearchDelegate<String> {
  var menuItemsNames = getMenuItems(menu);
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = "",
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
    bool canAdd = true;
    bool isComplete = false;
    bool hasErrors = false;
    String errorMsg = "";
    order.forEach((orders) {
      if (orders.name == newItem.elementAt(0).name) {
        canAdd = false;
        return;
      }
    });
    if (canAdd == true) {
      order.add(new customerOrderData(newItem.elementAt(0).name,
          newItem.elementAt(0).price, 1, newItem.elementAt(0).price));
      orderData['items'] = order.map<dynamic>((f) => f.toJson()).toList();
      totalPrice += newItem.elementAt(0).price;
      DocumentReference documentReference =
          Firestore.instance.collection("orders").document(docID);
      documentReference.updateData(orderData).whenComplete(() {
        return Container(
          child: Text("Addded"),
        );
      }).catchError((error) {
        hasErrors = true;
      });
    } else {
      errorMsg = "Can't be added";
    }
    return Container(
        child: (isComplete != true && hasErrors == false && canAdd == true)
            ? Text("Added")
            : Text("$errorMsg"));
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

List<String> getMenuItems(List<menuItem> menus) {
  List<String> items = List<String>();
  items = menus.map((menu) {
    print(menu.name);
    return menu.name;
  }).toList();
  return items;
}
