import 'package:cards_app/models/admin.dart';
import 'package:cards_app/models/cards.dart';
import 'package:cards_app/models/customers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

var adminIdget;

class FirebaseApiClient {
  final http.Client httpClient;

  FirebaseApiClient({
    this.httpClient,
  });

  FirebaseFirestore database = FirebaseFirestore.instance;

  //LOGIN
  CollectionReference admin = FirebaseFirestore.instance.collection('admin');

  //CARD
  CollectionReference cards = FirebaseFirestore.instance.collection('cards');

  //CUSTOMER
  CollectionReference customer =
      FirebaseFirestore.instance.collection('customers');

  //LOGIN
  Future<Admin> fetchLogin(String email, String password) async {
    print("EMAIL:${email}");
    print("PASSWORD:${password}");
    var res = await admin
        .where("email", isEqualTo: email)
        .where("password", isEqualTo: password)
        .get();
    var data = res.docs[0];
    adminIdget = res.docs[0].id;
    //print(data.data());
    // final json = jsonDecode();
    return Admin.fromJson(data.data());
  }

//Add Admin
  Future<Admin> addAdmin(String email, String name, String password,
      String phno, String isSuperAdmin) async {
    var res = await database.collection('admin').add({
      "email": email,
      "name": name,
      "password": password,
      "phoneNo": phno,
      "isSuperAdmin": isSuperAdmin
    });
    await res.get();
    admin.doc(res.id).update({"adminID": res.id});
    print("admin ID:::::${res.id}");
    return Admin(
        adminId: res.id,
        adminName: name,
        phoneNo: phno,
        email: email,
        password: password,
        isSuperAdmin: isSuperAdmin);
  }

  //Add Card
  Future<Cards> addCard(String adminId, String cardId, String amount,
      String cardNumber, String cardVender, String status) async {
    var res = await cards.add({
      "amount": amount,
      "cardNumber": cardNumber,
      "cardVender": cardVender,
      "status": status,
    });
    await res.get();
    cards.doc(res.id).update({"adminId": adminId});
    cards.doc(res.id).update({"cardId": res.id});
    print("card ID:::::${res.id}");
    return Cards(
        adminId: adminId,
        cardId: res.id,
        amount: amount,
        cardNumber: cardNumber,
        cardVender: cardVender,
        status: status);
  }

  //Add Customer
  Future<Customer> addCustomer(String customerId, String adminId,
      String balance, String name, String password) async {
    var res = await customer.add({
      "customerId": customerId,
      "adminId": adminId,
      "balance": balance,
      "name": name,
      "password": password,
    });
    await res.get();
    customer.doc(res.id).update({"customerId": res.id});
    customer.doc(res.id).update({"adminId": adminId});

    print("card ID:::::${res.id}");
    return Customer(
        customerId: customerId,
        adminId: adminId,
        balance: balance,
        name: name,
        password: password);
  }
}
