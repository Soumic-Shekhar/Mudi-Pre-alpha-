import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as prefix0;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mudi_grocery_app/ui/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ListPage extends StatefulWidget {
  ListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  Future _data;
  String _ID = Random().nextInt(10000).toString();
  Future<int> Quantity;

  @override
  void initState() {
    _data = getItems();
    super.initState();
  }

  void refreshList() {
    _data = getItems();
  }

  void increment(int count) {
    count++;
  }

  final Directory tempDir = Directory.systemTemp;

  @override
  Widget build(BuildContext context) {
    final makeBottom = Container(
      height: 55.0,
      child: BottomAppBar(
        color: Color.fromRGBO(21, 0, 217, 1.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.blur_on, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.hotel, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.account_box, color: Colors.white),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
    final topAppBar = AppBar(
      elevation: 0.1,
      backgroundColor: Color.fromRGBO(21, 0, 217, 1.0),
      title: Text(widget.title),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.list),
          onPressed: () {},
        )
      ],
    );

    return Scaffold(
        backgroundColor: Color.fromRGBO(255, 255, 255, 1.0),
        appBar: topAppBar,
        body: Container(
          child: FutureBuilder(
              future: getItems(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: Text("Loading..."));
                } else {
                  return Container(
                      child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (_, index) {
                      int count;
                      return Card(
                        elevation: 8.0,
                        margin: new EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 6.0),
                        child: new InkWell(
                          onTap: () {
                            void inputData() async {
                              final FirebaseUser user =
                                  await FirebaseAuth.instance.currentUser();
                              final uid = user.uid;
                              print(uid);

                              String item_ID =
                                  snapshot.data[index].data["Name"];

                              // here you write the codes to input the data into firestore

                              Firestore.instance
                                  .collection("Order")
                                  .document(_ID)
                                  .setData({
                                "Order_No": _ID,
                                "User_ID": uid,
                              });
                              DocumentReference ref = Firestore.instance
                                  .collection("Order")
                                  .document(_ID)
                                  .collection("Items")
                                  .document(item_ID);

                              ref.get().then((_ref) {
                                if (!_ref.exists) {
                                  Firestore.instance
                                      .collection("Order")
                                      .document(_ID)
                                      .collection("Items")
                                      .document(item_ID)
                                      .setData(
                                          {"Item": item_ID, "Quantity": 1});
                                } else {
                                  String x;

                                  void getData() async {
                                    Quantity = await Firestore.instance
                                        .collection("Order")
                                        .document(_ID)
                                        .collection("Items")
                                        .document(item_ID)
                                        .get()
                                        .then((val) {
                                          print(val["Quantity"]);
                                      Firestore.instance.collection("Order").document(_ID).collection("Items").document(item_ID).updateData({
                                        "Quantity": val["Quantity"] + 1});
                                    });
                                  }

                                  getData();

                                  // Firestore.instance
                                  //     .collection("Order")
                                  //     .document(_ID)
                                  //     .collection("Items")
                                  //     .document(item_ID)
                                  //     .updateData({"Quantity": x});
                                }
                              });
                            }

                            inputData();
                          },
                          child: Row(
                            children: <Widget>[
                              // Left Section
                              Container(
                                height: 70,
                                padding: new EdgeInsets.only(left: 8.0),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  backgroundImage: NetworkImage(
                                      snapshot.data[index].data["Image"]),
                                  radius: 30.0,
                                ),
                              ),
                              //Middle Section
                              Expanded(
                                child: Container(
                                    padding: new EdgeInsets.only(left: 8.0),
                                    decoration: BoxDecoration(
                                        color:
                                            Color.fromRGBO(255, 255, 255, .9)),
                                    child: ListTile(
                                      title: Text(
                                          snapshot.data[index].data["Name"]),
                                    )),
                              ),
                              //Right Secton
                              Container(
                                padding: new EdgeInsets.only(right: 8.0),
                                child: Text("TK " +
                                    (snapshot.data[index].data["Price"])
                                        .toString()),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ));
                }
              }),
        ),
        //bottomNavigationBar: makeBottom,
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text(''),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(21, 0, 217, 1.0),
                ),
              ),
              ListTile(
                title: Text('Log Out'),
                onTap: () {
                  FirebaseAuth.instance.signOut().then((onValue) {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new LoginPage()));
                  });
                },
              ),
              ListTile(
                title: Text('Item 2'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
            ],
          ),
        ));
  }
}

Future getItems() async {
  return await Firestore.instance
      .collection('items')
      .getDocuments()
      .then((doc) {
    print(doc);
    return doc.documents;
  });
}
