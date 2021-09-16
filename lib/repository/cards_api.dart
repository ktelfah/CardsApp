import 'package:cards_app/models/admin.dart';
import 'package:cards_app/models/cards.dart';
import 'package:cards_app/models/customers.dart';
import 'package:cards_app/models/orders.dart';
import 'package:cards_app/screens/card_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

var adminIdGet;
int customerAmountGet;
bool isCard = false;

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

  //ORDERS
  CollectionReference orders = FirebaseFirestore.instance.collection('orders');

  //LOGIN
  Future<Admin> fetchLogin(String email, String password) async {
    var data;
    var res = await admin
        .where("email", isEqualTo: email)
        .where("password", isEqualTo: password)
        .get();
    if (res.docs.length <= 0) {
      var resCustomer = await customer
          .where("name", isEqualTo: email)
          .where("password", isEqualTo: password)
          .get();

      data = resCustomer.docs[0];
      isCard = true;
      adminIdGet = resCustomer.docs[0].id;
      customerAmountGet = resCustomer.docs[0].get('balance');
    } else {
      data = res.docs[0];
      isCard = false;
      adminIdGet = res.docs[0].id;
    }

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

    return Admin(
        adminId: res.id,
        adminName: name,
        phoneNo: phno,
        email: email,
        password: password,
        isSuperAdmin: isSuperAdmin);
  }

  //Add Card
  Future<Cards> addCard(String adminId, String cardId, int amount,
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

    return Customer(
        customerId: customerId,
        adminId: adminId,
        balance: balance,
        name: name,
        password: password);
  }

  //Fetch Cards
  Future<List<Cards>> fetchCards() async {
    List<Cards> cardData = [];
    var res = await cards.where("status", isEqualTo: "NEW").get();

    res.docs.forEach((element) {
      cardData.add(Cards.fromJson(element.data()));
    });

    return cardData;
  }

  //Add Orders
  Future<Orders> addOrders(String cardId, String customerId, String orderId,
      Timestamp transactionDate) async {
    var res = await orders.add({
      "cardId": cardId,
      "customerId": customerId,
      "orderId": orderId,
      "transactionDate": transactionDate
    });

    await res.get();
    orders.doc(res.id).update({"orderId": res.id});
    orders.doc(res.id).update({"customerId": adminIdGet});
    orders.doc(res.id).update({"cardId": addCardIds});
    arrayCardIDs.forEach((element) {
      cards.doc(element).update({"status": "USED"});
    });
    customer.doc(adminIdGet).update({"balance": minusCustomerBalance});

    return Orders(
        cardId: cardId,
        customerId: customerId,
        orderId: orderId,
        transactionDate: transactionDate);
  }

  //Fetch OrdersList
  Future<List<Cards>> fetchOrdersList() async {
    List<Cards> cardData = [];
    var res = await cards.where("status", isEqualTo: "USED").get();

    res.docs.forEach((element) {
      cardData.add(Cards.fromJson(element.data()));
    });

    return cardData;
  }

  //Fetch OrdersList By OrderTable
  Future<List<Orders>> fetchOrdersListByOrder() async {
    List<Orders> ordersData = [];
    var res = await orders.where("customerId", isEqualTo: adminIdGet).get();

    res.docs.forEach((element) {
      ordersData.add(Orders.fromJson(element.data()));
    });

    return ordersData;
  }
}
