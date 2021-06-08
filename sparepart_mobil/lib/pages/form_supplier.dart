import 'package:flutter/material.dart';
import 'package:sparepart_mobil/services/database.dart';

class FormSpare extends StatefulWidget {
  final String namaSup;
  final String alamat;
  final String notelp;
  final String docId;
  FormSpare(this.namaSup, this.alamat, this.notelp, this.docId);
  @override
  FormSpareState createState() =>
      FormSpareState(this.namaSup, this.alamat, this.notelp, docId);
}

//class controller
class FormSpareState extends State<FormSpare> {
  String namaSup;
  String alamat;
  String notelp;
  String docId;
  FormSpareState(this.namaSup, this.alamat, this.notelp, this.docId);
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController notlpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //kondisi
    if (namaSup != null) {
      nameController.text = namaSup;
      addressController.text = alamat;
      notlpController.text = notelp;
    }
    //rubah
    return Scaffold(
      appBar: AppBar(
        title: Text('Isi Data Supplier'),
        leading: Icon(Icons.keyboard_arrow_left),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: ListView(
          children: <Widget>[
            // nama
            Padding(
              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: TextField(
                controller: nameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Nama Supplier',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (value) {
                  //
                },
              ),
            ),
            // alamat
            Padding(
              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: TextField(
                controller: addressController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Alamat',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (value) {
                  //
                },
              ),
            ),
            // no telpon
            Padding(
              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: TextField(
                controller: notlpController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'No Telepon',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (value) {
                  //
                },
              ),
            ),
            // tombol button
            Padding(
              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: Row(
                children: <Widget>[
                  // tombol simpan
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        'Save',
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        if (namaSup == null) {
                          // tambah data
                          Database.addSup(
                              namaSup: nameController.text,
                              alamat: addressController.text,
                              notelp: notlpController.text);
                        } else {
                          // ubah data
                          Database.updateSup(
                              namaSup: nameController.text,
                              alamat: addressController.text,
                              notelp: notlpController.text,
                              docId: docId);
                        }
                        // kembali ke layar sebelumnya dengan membawa objek item
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Container(
                    width: 5.0,
                  ),
                  // tombol batal
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        'Cancel',
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
