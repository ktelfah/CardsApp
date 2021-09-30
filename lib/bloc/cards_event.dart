import 'package:equatable/equatable.dart';

abstract class FirebaseEvent extends Equatable {
  const FirebaseEvent();
}

//LOGIN
class FetchLogin extends FirebaseEvent {
  final email;
  final password;

  FetchLogin(this.email, this.password);

  @override
  List<Object> get props => [];
}

class ResetLogin extends FirebaseEvent {
  const ResetLogin();

  @override
  List<Object> get props => [];
}

//Add Admin

class FetchAddAdmin extends FirebaseEvent {
  final email;
  final name;
  final password;
  final phno;
  final isSuperAdmin;

  FetchAddAdmin(
      this.email, this.name, this.password, this.phno, this.isSuperAdmin);

  List<Object> get props => [];
}

class ResetAddAdmin extends FirebaseEvent {
  const ResetAddAdmin();

  @override
  List<Object> get props => [];
}

//Add Card

class FetchAddCard extends FirebaseEvent {
  final adminId;
  final cardId;
  final amount;
  final cardNumber;
  final cardVender;
  final status;

  FetchAddCard(this.adminId, this.cardId, this.amount, this.cardNumber,
      this.cardVender, this.status);

  List<Object> get props => [];
}

class ResetAddCard extends FirebaseEvent {
  const ResetAddCard();

  @override
  List<Object> get props => [];
}

//Add Customer
class FetchAddCustomer extends FirebaseEvent {
  final customerId;
  final adminId;
  final balance;
  final name;
  final address;
  final password;

  FetchAddCustomer(this.customerId, this.adminId, this.balance, this.name,
      this.address, this.password);

  List<Object> get props => [];
}

class ResetAddCustomer extends FirebaseEvent {
  const ResetAddCustomer();

  @override
  List<Object> get props => [];
}

//Fetch Cards
class FetchCards extends FirebaseEvent {
  FetchCards();

  @override
  List<Object> get props => [];
}

class ResetFetchCards extends FirebaseEvent {
  const ResetFetchCards();

  @override
  List<Object> get props => [];
}

//Add Orders
class FetchAddOrders extends FirebaseEvent {
  final cardId;
  final customerId;
  final orderId;
  final transactionDate;

  FetchAddOrders(
      this.cardId, this.customerId, this.orderId, this.transactionDate);

  List<Object> get props => [];
}

class ResetAddOrders extends FirebaseEvent {
  const ResetAddOrders();

  @override
  List<Object> get props => [];
}

//Fetch OrderList
class FetchOrdersList extends FirebaseEvent {
  FetchOrdersList();

  @override
  List<Object> get props => [];
}

class ResetFetchOrdersList extends FirebaseEvent {
  const ResetFetchOrdersList();

  @override
  List<Object> get props => [];
}

//Fetch OrderList By OrderList
class FetchOrdersListByOrders extends FirebaseEvent {
  FetchOrdersListByOrders();

  @override
  List<Object> get props => [];
}

class ResetFetchOrdersListByOrders extends FirebaseEvent {
  const ResetFetchOrdersListByOrders();

  @override
  List<Object> get props => [];
}

//Add Vendor

class FetchAddVendor extends FirebaseEvent {
  final vendorId;
  final adminId;
  final name;
  final icon;
  final address1;
  final address2;
  final zipcode;
  final county;

  FetchAddVendor(this.vendorId, this.adminId, this.name, this.icon,
      this.address1, this.address2, this.zipcode, this.county);

  List<Object> get props => [];
}

class ResetAddVendor extends FirebaseEvent {
  const ResetAddVendor();

  @override
  List<Object> get props => [];
}

//Fetch Customer
class FetchCustomer extends FirebaseEvent {
  FetchCustomer();

  @override
  List<Object> get props => [];
}

class ResetFetchCustomer extends FirebaseEvent {
  const ResetFetchCustomer();

  @override
  List<Object> get props => [];
}

//Customer Update

class UpdateCustomer extends FirebaseEvent {
  final customerId;
  final adminId;
  final name;
  final balance;
  final password;
  final address;

  UpdateCustomer(this.customerId, this.adminId, this.name, this.balance,
      this.password, this.address);

  @override
  List<Object> get props => [];
}

class ResetUpdateCustomer extends FirebaseEvent {
  const ResetUpdateCustomer();

  @override
  List<Object> get props => [];
}
