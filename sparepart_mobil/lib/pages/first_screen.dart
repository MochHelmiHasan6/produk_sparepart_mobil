import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sparepart_mobil/pages/form_spare.dart';
import 'package:sparepart_mobil/pages/login_pages.dart';
import 'package:sparepart_mobil/pages/spare.dart';
import 'package:sparepart_mobil/pages/supplier.dart';
import 'package:sparepart_mobil/services/database.dart';
import 'package:sparepart_mobil/services/sign_in.dart';

class FirstScreen extends StatelessWidget {
  List<String> listItem = ["Delete", "Update"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 243, 243, 1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          Container(
            margin: EdgeInsets.all(10),
            child: CircleAvatar(
              backgroundImage: NetworkImage(imageUrl),
            ),
          )
        ],
      ),
      drawer: Drawer(
        elevation: 16.0,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey,
                image: DecorationImage(
                  image: NetworkImage(
                      'https://www.google.com/maps/uv?pb=!1s0x2dd629e6f3db1155%3A0x6931be2a55338188!3m1!7e115!4shttps%3A%2F%2Flh5.googleusercontent.com%2Fp%2FAF1QipOCklH1Z9ArlEfBss9J4qRKJoLzXsYATUhwCCof%3Dw213-h160-k-no!5sJaya%20Ac%2C%20Jalan%20Soekarno%20Hatta%2C%20Mojolangu%2C%20Malang%20City%2C%20Jawa%20Timur%20-%20Penelusuran%20Google!15sCgIgAQ&imagekey=!1e2!2smA82PQcL_2kAAAQYVXN6eA&hl=id&sa=X&ved=2ahUKEwiJsZ__zofxAhVbfisKHXRnD84QoiowE3oECEAQAw#'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Container(
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(imageUrl),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: Text(
                      'Hi ' + nameGoogle + ' !',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: Text(
                      emailGoogle,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text("MAIN MENU"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
              onTap: () {
                MaterialPageRoute route =
                    MaterialPageRoute(builder: (_) => FirstScreen());
                Navigator.push(context, route);
              },
            ),
            ListTile(
              leading: Icon(Icons.inventory),
              title: Text("Gudang Spare Part"),
              onTap: () {
                MaterialPageRoute route = MaterialPageRoute(
                    builder: (_) => Spare(email: emailGoogle));
                Navigator.push(context, route);
              },
            ),
            ListTile(
              leading: Icon(Icons.person_add_alt_1_rounded),
              title: Text("My Supplier"),
              onTap: () {
                MaterialPageRoute route = MaterialPageRoute(
                    builder: (_) => Supplier(email: emailGoogle));
                Navigator.push(context, route);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Log Out"),
              onTap: () {
                signOutGoogle();

                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) {
                  return LoginPage();
                }), ModalRoute.withName('/'));
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 160.0),
            child: fireListView(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          MaterialPageRoute route =
              MaterialPageRoute(builder: (_) => Supplier());
          Navigator.push(context, route);
        },
        child: Icon(Icons.navigate_next),
        backgroundColor: Colors.black87,
      ),
    );
  }

  Future<Database> navigateToEntryForm(BuildContext context, String nama,
      int harga, int stok, String docId) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return FormSpare(nama, harga, stok, docId);
        },
      ),
    );
    return result;
  }

  StreamBuilder fireListView() {
    // TextStyle textStyle = Theme.of(context).textTheme.headline5;
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
              String nama = noteInfo['nama'];
              int harga = noteInfo['harga'];
              int stok = noteInfo['stok'];

              return Card(
                color: Colors.white,
                elevation: 2.0,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Icon(Icons.car_repair_rounded),
                  ),
                  title: Text(
                    nama,
                  ),
                  subtitle: Text(stok.toString()),
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
                              context, nama, harga, stok, docID);
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
