import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('spare');
final CollectionReference _secondCollection = _firestore.collection('supplier');

class Database {
  // static String userUid;

  static Future<void> addItem({
    String nama,
    int harga,
    int stok,
  }) async {
    DocumentReference documentReferencer =
        _mainCollection.doc('spare').collection('spare').doc();

    Map<String, dynamic> data = <String, dynamic>{
      "nama": nama,
      "harga": harga,
      "stok": stok,
    };

    await documentReferencer
        .set(data)
        .whenComplete(() => print("Note item added to the database"))
        .catchError((e) => print(e));
  }

  static Future<void> updateItem({
    String nama,
    int harga,
    int stok,
    String docId,
  }) async {
    DocumentReference documentReferencer =
        _mainCollection.doc('spare').collection('spare').doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "nama": nama,
      "harga": harga,
      "stok": stok,
    };

    await documentReferencer
        .update(data)
        .whenComplete(() => print("Note item updated in the database"))
        .catchError((e) => print(e));
  }

  static Stream<QuerySnapshot> readItems() {
    CollectionReference notesItemCollection =
        _mainCollection.doc('spare').collection('spare');

    return notesItemCollection.snapshots();
  }

  static Future<void> deleteItem({
    String docId,
  }) async {
    DocumentReference documentReferencer =
        _mainCollection.doc('spare').collection('spare').doc(docId);

    await documentReferencer
        .delete()
        .whenComplete(() => print('Note item deleted from the database'))
        .catchError((e) => print(e));
  }

  static Future<void> addSup({
    String namaSup,
    String alamat,
    String notelp,
  }) async {
    DocumentReference documentReferencer =
        _secondCollection.doc('supplier').collection('supplier').doc();

    Map<String, dynamic> data = <String, dynamic>{
      "namaSup": namaSup,
      "alamat": alamat,
      "notelp": notelp,
    };

    await documentReferencer
        .set(data)
        .whenComplete(() => print("Note item added to the database"))
        .catchError((e) => print(e));
  }

  static Future<void> updateSup({
    String namaSup,
    String alamat,
    String notelp,
    String docId,
  }) async {
    DocumentReference documentReferencer =
        _secondCollection.doc('supplier').collection('supplier').doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "namaSup": namaSup,
      "alamat": alamat,
      "notelp": notelp,
    };

    await documentReferencer
        .update(data)
        .whenComplete(() => print("Note item updated in the database"))
        .catchError((e) => print(e));
  }

  static Stream<QuerySnapshot> readSup() {
    CollectionReference supplierCollection =
        _secondCollection.doc('supplier').collection('supplier');

    return supplierCollection.snapshots();
  }

  static Future<void> deleteSup({
    String docId,
  }) async {
    DocumentReference documentReferencer =
        _secondCollection.doc('supplier').collection('supplier').doc(docId);

    await documentReferencer
        .delete()
        .whenComplete(() => print('Note item deleted from the database'))
        .catchError((e) => print(e));
  }
}
