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
  final password;

  FetchAddCustomer(
      this.customerId, this.adminId, this.balance, this.name, this.password);

  List<Object> get props => [];
}

class ResetAddCustomer extends FirebaseEvent {
  const ResetAddCustomer();

  @override
  List<Object> get props => [];
}
