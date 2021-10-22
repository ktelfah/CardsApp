import 'package:cards_app/models/admin.dart';
import 'package:cards_app/models/cards.dart';
import 'package:cards_app/models/categories.dart';
import 'package:cards_app/models/customers.dart';
import 'package:cards_app/models/orders.dart';
import 'package:cards_app/models/subCategory.dart';
import 'package:cards_app/models/vendors.dart';
import 'package:cards_app/repository/cards_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseRepository {
  final FirebaseApiClient firebaseApiClient;

  FirebaseRepository({this.firebaseApiClient})
      : assert(firebaseApiClient != null);

  // LOGIN
  Future<Admin> fetchLogin(String email, String password) async {
    return await firebaseApiClient.fetchLogin(email, password);
  }

  // Add Admin
  Future<Admin> addAdmin(String email, String name, String password,
      String phno, String isSuperAdmin) async {
    return await firebaseApiClient.addAdmin(
        email, name, password, phno, isSuperAdmin);
  }

  // Add Card
  Future<Cards> addCard(String adminId, String cardId, num amount,
      String cardNumber, String cardVender, String status) async {
    return await firebaseApiClient.addCard(
        adminId, cardId, amount, cardNumber, cardVender, status);
  }

  // Add Customer
  Future<Customer> addCustomer(String customerId, String adminId, num balance,
      String name, String address, String password) async {
    return await firebaseApiClient.addCustomer(
        customerId, adminId, balance, name, address, password);
  }

  //=============================================================================//
  // Add SubCategory
  Future<SubCategory> addSubCategory(String categoryId, String name,
      String price, String quantity, String description) async {
    return await firebaseApiClient.addSubCategory(
        categoryId, name, price, quantity, description);
  }

  //=============================================================================//
  // ADD CATEGORY
  Future<Category> addCategory(String categoryName) async {
    return await firebaseApiClient.addCategory(categoryName);
  }

  //=============================================================================//

  // Fetch Cards
  Future<List<Cards>> fetchCards() async {
    return await firebaseApiClient.fetchCards();
  }

  // AddOrders
  Future<Orders> addOrders(String cardId, String customerId, String orderId,
      Timestamp transactionDate) async {
    return await firebaseApiClient.addOrders(
        cardId, customerId, orderId, transactionDate);
  }

  // Fetch Orders List
  Future<List<Cards>> fetchOrdersList() async {
    return await firebaseApiClient.fetchOrdersList();
  }

  // Fetch Orders List By OrderList
  Future<List<Orders>> fetchOrdersListByOrder() async {
    return await firebaseApiClient.fetchOrdersListByOrder();
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
    String type,
  ) async {
    return await firebaseApiClient.addVendor(vendorId, adminId, name, icon,
        address1, address2, zipcode, county, type);
  }

  // Fetch Customer
  Future<List<Customer>> fetchCustomer() async {
    return await firebaseApiClient.fetchCustomers();
  }

  // Update Customer
  Future<bool> updateCustomer(
    String customerId,
    String adminId,
    String name,
    int balance,
    String password,
    String address,
  ) async {
    return await firebaseApiClient.updateCustomer(
        customerId, adminId, name, balance, password, address);
  }

  // Fetch Vendors
  Future<List<Vendors>> fetchVendors() async {
    return await firebaseApiClient.fetchVendors();
  }

  // Fetch Category
  Future<List<Category>> fetchCategory() async {
    return await firebaseApiClient.fetchCategory();
  }

  // Fetch SubCategory
  Future<List<SubCategory>> fetchSubCategory() async {
    return await firebaseApiClient.fetchSubCategory();
  }
}
