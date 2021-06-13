import 'package:flutter/material.dart';
import 'package:sparepart_mobil/services/database.dart';

class FormSpare extends StatefulWidget {
  final String nama;
  final int harga;
  final int stok;
  final String docId;
  FormSpare(this.nama, this.harga, this.stok, this.docId);
  @override
  FormSpareState createState() =>
      FormSpareState(this.nama, this.harga, this.stok, docId);
}

//class controller
class FormSpareState extends State<FormSpare> {
  String nama;
  int harga;
  int stok;
  String docId;
  FormSpareState(this.nama, this.harga, this.stok, this.docId);
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController stockController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //kondisi
    if (nama != null) {
      nameController.text = nama;
      priceController.text = harga.toString();
      stockController.text = stok.toString();
    }
    //rubah
    return Scaffold(
      appBar: AppBar(
        title: Text('Isi Data Spare Part'),
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
                  labelText: 'Nama Barang',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (value) {
                  //
                },
              ),
            ),
            // harga
            Padding(
              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Harga',
                  hintText: 'Rupiah',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (value) {
                  //
                },
              ),
            ),
            //stock
            Padding(
              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: TextField(
                controller: stockController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Stock',
                  hintText: 'Pcs',
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
                      child: Icon(Icons.save_rounded),
                      onPressed: () {
                        if (nama == null) {
                          // tambah data
                          Database.addItem(
                              nama: nameController.text,
                              harga: int.parse(priceController.text),
                              stok: int.parse(stockController.text));
                        } else {
                          // ubah data
                          Database.updateItem(
                              nama: nameController.text,
                              harga: int.parse(priceController.text),
                              stok: int.parse(stockController.text),
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
                      child: Icon(Icons.cancel_rounded),
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
