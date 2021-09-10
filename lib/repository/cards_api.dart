import 'dart:convert';
import 'package:cards_app/models/admin.dart';
import 'package:cards_app/models/cards.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class FirebaseApiClient {
  //static var shared = FirebaseApiClient(httpClient: null);
  final http.Client httpClient;

  //static var mySingleton = MySingleton();
  FirebaseApiClient({
    required this.httpClient,
  });

  //Global global =  Global();

  //LOGIN
  CollectionReference admin = FirebaseFirestore.instance.collection('admin');

  //CARD
  CollectionReference cards = FirebaseFirestore.instance.collection('cards');


  //LOGIN
  Future<Admin?> fetchLogin(String email, String password) async {
    try {
      print("email::::::::${email}");
      print("password:::::::${password}");
      var res = await admin
          //.where("email", isEqualTo: email)
          // .where("password", isEqualTo: password)
          .get();
      print("data count::${res.docs}");
      print(res.docs[0].id);
      var data = res.docs.map((e) => e.data());
      print(data.first);
      //print(data.data());
      //print(res.docs[0].toString());
    var dataJson = jsonDecode(res.docs[0].data().toString());


      return Admin.fromJson(dataJson);
    } catch (e) {
      print(e);
    }
  }


//Add Admin
  Future<Admin> addAdmin(String email, String name, String password,
      String phno) async {
    //print("IN REGISTRATION");
    var res = await admin
        .add({"email": email,  "name": name,"password": password, "phoneNo": phno});
    await res.get();
    admin.doc(res.id).update({"adminID": res.id});
    //print(res.toString());
    //print(data.data().toString());
    // final json = jsonDecode();
    print("admin ID:::::${res.id}");
    return Admin(
        adminId: res.id,
        adminName: name,
        phoneNo: phno,
        email: email,
        password: password);
  }

  //Add Card
  Future<Cards> addCard(String adminId, String cardId, String amount,
      String cardNumber,String cardVender, String status) async {
    //print("IN REGISTRATION");
    var res = await cards
        .add({"amount": amount, "cardNumber": cardNumber,
      "cardVender": cardVender,  "status": status,
    });
    await res.get();
    cards.doc(res.id).update({"adminId": res.id});
    cards.doc(res.id).update({"cardId": res.id});
    //print(res.toString());
    //print(data.data().toString());
    // final json = jsonDecode();
    print("card ID:::::${res.id}");
    return Cards(
        adminId: adminId,
        cardId: res.id,
        amount: amount,
        cardNumber: cardNumber,
        cardVender: cardVender,
        status: status
    );
  }

}
