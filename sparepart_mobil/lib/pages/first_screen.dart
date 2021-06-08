import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sparepart_mobil/pages/login_pages.dart';
import 'package:sparepart_mobil/pages/spare.dart';
import 'package:sparepart_mobil/pages/supplier.dart';
import 'package:sparepart_mobil/services/sign_in.dart';

class FirstScreen extends StatelessWidget {
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
              leading: Icon(Icons.add_circle),
              title: Text("Add Spare Part"),
              onTap: () {
                MaterialPageRoute route = MaterialPageRoute(
                    builder: (_) => Spare(email: emailGoogle));
                Navigator.push(context, route);
              },
            ),
            ListTile(
              leading: Icon(Icons.add_circle),
              title: Text("Add Supplier"),
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
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("mountain")
                  .where("email", isEqualTo: emailGoogle)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData)
                  return new Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                return new MyList(document: snapshot.data.docs);
              },
            ),
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
}

class MyList extends StatelessWidget {
  MyList({this.document});
  final List<DocumentSnapshot> document;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: document.length,
      itemBuilder: (BuildContext context, int i) {
        String nama = document[i].data()['nama'].toString();
        String harga = document[i].data()['harga'].toString();
        String stok = document[i].data()['stok'].toString();

        return Dismissible(
          key: Key(document[i].id),
          onDismissed: (direction) {
            FirebaseFirestore.instance.runTransaction((transaction) async {
              DocumentSnapshot snapshot =
                  await transaction.get(document[i].reference);
              await transaction.delete(snapshot.reference);
            });

            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text("Data has been deleted"),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nama,
                          style: TextStyle(fontSize: 18.0),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(Icons.location_city,
                                  color: Colors.black),
                            ),
                            Text(
                              harga,
                              style: TextStyle(fontSize: 14.0),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(Icons.data_saver_on),
                            ),
                            Text(
                              stok,
                              style: TextStyle(fontSize: 14.0),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // IconButton(
                //   icon: Icon(Icons.edit),
                //   onPressed: () {
                //     MaterialPageRoute route = MaterialPageRoute(
                //       builder: (_) => FormSpare(
                //           nama,
                //           harga,
                //           stok,
                //           document[i].reference),
                //     );
                //     Navigator.push(context, route);
                //   },
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
