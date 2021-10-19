import 'package:cards_app/models/admin.dart';
import 'package:cards_app/models/cards.dart';
import 'package:cards_app/models/categories.dart';
import 'package:cards_app/models/customers.dart';
import 'package:cards_app/models/orders.dart';
import 'package:cards_app/models/subCategory.dart';
import 'package:cards_app/models/vendors.dart';
import 'package:cards_app/screens/add_admin.dart';
import 'package:cards_app/screens/card_list.dart';
import 'package:cards_app/screens/category_list.dart';
import 'package:cards_app/screens/mainscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

var adminIdGet;
var customerAdminIdGet;
var customerIdGet;
var customerNameGet;
var customerAddressGet;
var customerPasswordGet;
int customerAmountGet;
bool isCard = false;

class FirebaseApiClient {
  final http.Client httpClient;

  FirebaseApiClient({
    this.httpClient,
  });

  FirebaseFirestore database = FirebaseFirestore.instance;

  // LOGIN
  CollectionReference admin = FirebaseFirestore.instance.collection('admin');

  // CARD
  CollectionReference cards = FirebaseFirestore.instance.collection('cards');

  // CUSTOMER
  CollectionReference customer =
      FirebaseFirestore.instance.collection('customers');

  // ORDERS
  CollectionReference orders = FirebaseFirestore.instance.collection('orders');

  // VENDOR
  CollectionReference vendors =
      FirebaseFirestore.instance.collection('vendors');

  // CATEGORIES
  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');

  // SUB-CATEGORIES
  CollectionReference subCategories =
      FirebaseFirestore.instance.collection('subCategories');

  // LOGIN
  Future<Admin> fetchLogin(String email, String password) async {
    var data;
    var passwordEncrypted;
    var newpasswordEncrypted;
    var customerPasswordEncrypted;
    // var customerGetPasswordEncrypted;
    String decryptedS;
    var key =
        "5621seeF+hm7eBsv6eDl2g==:VQP0A2rHM4F7aafVngOq5fL950nC1F6ElNPUP9lUTnY=";

    var getPasswordEncrypted = await admin
        .where("email", isEqualTo: email)
        // .where("isSuperAdmin", isEqualTo: "true")
        .get();

    // customerGetPasswordEncrypted =
    //     await customer.where("name", isEqualTo: email).get();

    if (getPasswordEncrypted.docs.length <= 0) {
      var customerGetPasswordEncrypted =
          await customer.where("name", isEqualTo: email).get();

      customerPasswordEncrypted =
          await customerGetPasswordEncrypted.docs[0].get('password');
      decryptedS = await cryptor.decrypt(customerPasswordEncrypted, key);
      if (decryptedS == password) {
        data = customerGetPasswordEncrypted.docs[0];
        isCard = true;
        adminIdGet = customerGetPasswordEncrypted.docs[0].id;
        customerAmountGet = customerGetPasswordEncrypted.docs[0].get('balance');
        customerIdGet = customerGetPasswordEncrypted.docs[0].get('customerId');
        customerAdminIdGet =
            customerGetPasswordEncrypted.docs[0].get('adminId');
        customerNameGet = customerGetPasswordEncrypted.docs[0].get('name');
        customerAddressGet =
            customerGetPasswordEncrypted.docs[0].get('address');
        customerPasswordGet = decryptedS;
        //customerPasswordGet = customerGetPasswordEncrypted.docs[0].get('password');
      }
    } else if (getPasswordEncrypted.docs.length <= 0) {
      var normalAdminGetPasswordEncrypted = await admin
          .where("name", isEqualTo: email)
          .where("isSuperAdmin", isEqualTo: "false")
          .get();
      newpasswordEncrypted =
          await normalAdminGetPasswordEncrypted.docs[0].get('password');
      print("*********************** Normal Admin ******************");
      // passwordEncrypted = await getPasswordEncrypted.docs[0].get('isSuperAdmin');
      decryptedS = await cryptor.decrypt(newpasswordEncrypted, key);
      if (decryptedS == password) {
        data = normalAdminGetPasswordEncrypted.docs[0];
        isCard = false;
        adminIdGet = normalAdminGetPasswordEncrypted.docs[0].id;
      }
    } else {
      passwordEncrypted = await getPasswordEncrypted.docs[0].get('password');
      print("*********************** Super Admin ******************");
      // passwordEncrypted = await getPasswordEncrypted.docs[0].get('isSuperAdmin');
      decryptedS = await cryptor.decrypt(passwordEncrypted, key);
      if (decryptedS == password) {
        data = getPasswordEncrypted.docs[0];
        isCard = false;
        adminIdGet = getPasswordEncrypted.docs[0].id;
      }
    }
    return Admin.fromJson(data.data());
  }

  // Add Admin
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

  // Add Card
  Future<Cards> addCard(String adminId, String cardId, num amount,
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

  // Add Customer
  Future<Customer> addCustomer(String customerId, String adminId, num balance,
      String name, String address, String password) async {
    var res = await customer.add({
      "customerId": customerId,
      "adminId": adminId,
      "balance": balance,
      "name": name,
      "address": address,
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
        address: address,
        password: password);
  }

  // Fetch Cards
  Future<List<Cards>> fetchCards() async {
    List<Cards> cardData = [];
    var res = await cards.where("status", isEqualTo: "NEW").get();

    res.docs.forEach((element) {
      cardData.add(Cards.fromJson(element.data()));
    });

    return cardData;
  }

  // Add Orders
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

  // Fetch OrdersList
  Future<List<Cards>> fetchOrdersList() async {
    List<Cards> cardData = [];
    var res = await cards.where("status", isEqualTo: "USED").get();

    res.docs.forEach((element) {
      cardData.add(Cards.fromJson(element.data()));
    });

    return cardData;
  }

  // Fetch OrdersList By OrderTable
  Future<List<Orders>> fetchOrdersListByOrder() async {
    List<Orders> ordersData = [];
    var res = await orders.where("customerId", isEqualTo: adminIdGet).get();

    res.docs.forEach((element) {
      ordersData.add(Orders.fromJson(element.data()));
    });

    return ordersData;
  }

  // Add Vendor
  Future<Vendors> addVendor(
      String vendorId,
      String adminId,
      String name,
      String icon,
      String address1,
      String address2,
      String zipcode,
      String county,
      String type) async {
    var res = await vendors.add({
      "vendorId": vendorId,
      "name": name,
      "icon": icon,
      "address1": address1,
      "address2": address2,
      "zipcode": zipcode,
      "county": county,
      "type": type,
    });

    await res.get();
    vendors.doc(res.id).update({"vendorId": res.id});
    vendors.doc(res.id).update({"adminId": adminId});

    return Vendors(
      vendorId: vendorId,
      adminId: adminId,
      name: name,
      icon: icon,
      address1: address1,
      address2: address2,
      zipcode: zipcode,
      county: county,
      type: type,
    );
  }

  // Fetch Customers
  Future<List<Customer>> fetchCustomers() async {
    List<Customer> customerData = [];
    var res = await customer.where("adminId", isEqualTo: adminIdGet).get();

    res.docs.forEach((element) {
      customerData.add(Customer.fromJson(element.data()));
    });

    return customerData;
  }

  // Update Customer
  Future<bool> updateCustomer(String customerId, String adminId, String name,
      int balance, String password, String address) async {
    await customer.doc(customerIdGet).update({
      "customerId": customerId,
      "adminId": adminId,
      "name": name,
      "balance": balance,
      "password": password,
      "address": address
    });

    var data = await customer.doc(customerId).get();
    return data.data() != null;
  }

  // Fetch Vendors List
  Future<List<Vendors>> fetchVendors() async {
    List<Vendors> vendorsData = [];
    var res = await vendors.get();

    res.docs.forEach((element) {
      vendorsData.add(Vendors.fromJson(element.data()));
    });

    return vendorsData;
  }

  // Fetch Category List
  Future<List<Category>> fetchCategory() async {
    List<Category> categoryData = [];
    var res = await categories
        .where("vendorId", isEqualTo: getSelectedVendorId)
        .get();

    res.docs.forEach((element) {
      categoryData.add(Category.fromJson(element.data()));
    });

    return categoryData;
  }

  // Fetch SubCategory List
  Future<List<SubCategory>> fetchSubCategory() async {
    List<SubCategory> subCategoryData = [];
    var res = await subCategories
        .where("categoryId", isEqualTo: getSelectedCategoryId)
        .get();

    res.docs.forEach((element) {
      subCategoryData.add(SubCategory.fromJson(element.data()));
    });

    return subCategoryData;
  }
}
