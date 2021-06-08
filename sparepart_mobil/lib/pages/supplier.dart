import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sparepart_mobil/pages/form_supplier.dart';
import 'package:sparepart_mobil/services/database.dart';
import 'dart:async';

class Supplier extends StatefulWidget {
  Supplier({this.email});
  final String email;
  @override
  SupplierState createState() => SupplierState();
}

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class SupplierState extends State<Supplier> {
  List<String> listItem = ["Delete", "Update"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Supplier'),
      ),
      body: Column(
        children: [
          Expanded(
            child: fireListView(),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () async {
                var item =
                    await navigateToEntryForm(context, null, null, null, null);
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<Database> navigateToEntryForm(BuildContext context, String namaSup,
      String alamat, String notelp, String docId) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return FormSpare(namaSup, alamat, notelp, docId);
        },
      ),
    );
    return result;
  }

  StreamBuilder fireListView() {
    TextStyle textStyle = Theme.of(context).textTheme.headline5;
    return StreamBuilder<QuerySnapshot>(
      stream: Database.readItems(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            alignment: Alignment.center,
            child: Text(
              'Loading',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        } else if (snapshot.hasData || snapshot.data != null) {
          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              var noteInfo = snapshot.data.docs[index].data();
              String docID = snapshot.data.docs[index].id;
              String namaSup = noteInfo['namaSup'];
              String alamat = noteInfo['alamat'];
              String notelp = noteInfo['notelp'];

              return Card(
                color: Colors.white,
                elevation: 2.0,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Icon(Icons.person),
                  ),
                  title: Text(
                    namaSup,
                    style: textStyle,
                  ),
                  subtitle: Text(notelp),
                  trailing: GestureDetector(
                    child: DropdownButton<String>(
                      underline: SizedBox(),
                      icon: Icon(Icons.menu),
                      items: listItem.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String changeValue) async {
                        if (changeValue == "Delete") {
                          Database.deleteItem(docId: docID);
                        } else if (changeValue == "Update") {
                          await navigateToEntryForm(
                              context, namaSup, alamat, notelp, docID);
                        }
                        ;
                      },
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
