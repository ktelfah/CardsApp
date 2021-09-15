import 'package:cards_app/models/admin.dart';
import 'package:cards_app/models/cards.dart';
import 'package:cards_app/models/customers.dart';
import 'package:cards_app/models/orders.dart';
import 'package:cards_app/repository/cards_api.dart';
import 'package:flutter/material.dart';

class FirebaseRepository {
  final FirebaseApiClient firebaseApiClient;

  FirebaseRepository({this.firebaseApiClient})
      : assert(firebaseApiClient != null);

  //LOGIN
  Future<Admin> fetchLogin(String email, String password) async {
    return await firebaseApiClient.fetchLogin(email, password);
  }

  //AddAdmin
  Future<Admin> addAdmin(String email, String name, String password,
      String phno, String isSuperAdmin) async {
    return await firebaseApiClient.addAdmin(
        email, name, password, phno, isSuperAdmin);
  }

  //AddCard
  Future<Cards> addCard(String adminId, String cardId, int amount,
      String cardNumber, String cardVender, String status) async {
    return await firebaseApiClient.addCard(
        adminId, cardId, amount, cardNumber, cardVender, status);
  }

  //AddCustomer
  Future<Customer> addCustomer(String customerId, String adminId,
      String balance, String name, String password) async {
    return await firebaseApiClient.addCustomer(
        customerId, adminId, balance, name, password);
  }

  //Fetch Cards
  Future<List<Cards>> fetchCards() async {
    return await firebaseApiClient.fetchCards();
  }

  //AddOrders
  Future<Orders> addOrders(String cardId, String customerId,
      String orderId, String transactionDate) async {
    return await firebaseApiClient.addOrders(cardId, customerId, orderId, transactionDate);
  }
}
