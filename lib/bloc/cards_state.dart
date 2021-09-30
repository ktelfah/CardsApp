import 'package:cards_app/models/admin.dart';
import 'package:cards_app/models/cards.dart';
import 'package:cards_app/models/categories.dart';
import 'package:cards_app/models/customers.dart';
import 'package:cards_app/models/orders.dart';
import 'package:cards_app/models/subCategory.dart';
import 'package:cards_app/models/vendors.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class FirebaseState extends Equatable {
  const FirebaseState();

  @override
  List<Object> get props => [];
}

//LOGIN
class LoginEmpty extends FirebaseState {}

class LoginLoading extends FirebaseState {}

class LoginLoaded extends FirebaseState {
  final Admin admin;

  const LoginLoaded({this.admin});

  @override
  List<Object> get props => [];
}

class LoginError extends FirebaseState {}

//Add Admin
class AddAdminEmpty extends FirebaseState {}

class AddAdminLoading extends FirebaseState {}

class AddAdminLoaded extends FirebaseState {
  final Admin admin;

  const AddAdminLoaded({this.admin});

  @override
  List<Object> get props => [];
}

class AddAdminError extends FirebaseState {}

//Add Card
class AddCardEmpty extends FirebaseState {}

class AddCardLoading extends FirebaseState {}

class AddCardLoaded extends FirebaseState {
  final Cards card;

  const AddCardLoaded({this.card});

  @override
  List<Object> get props => [];
}

class AddCardError extends FirebaseState {}

//Add Customer
class AddCustomerEmpty extends FirebaseState {}

class AddCustomerLoading extends FirebaseState {}

class AddCustomerLoaded extends FirebaseState {
  final Customer customer;

  const AddCustomerLoaded({this.customer});

  @override
  List<Object> get props => [];
}

class AddCustomerError extends FirebaseState {}

//Fetch Cards
class FetchCardEmpty extends FirebaseState {}

class FetchCardLoading extends FirebaseState {}

class FetchCardLoaded extends FirebaseState {
  final List<Cards> cards;

  const FetchCardLoaded({this.cards});

  @override
  List<Object> get props => [];
}

class FetchCardError extends FirebaseState {}

//Add Orders
class AddOrdersEmpty extends FirebaseState {}

class AddOrdersLoading extends FirebaseState {}

class AddOrdersLoaded extends FirebaseState {
  final Orders orders;

  const AddOrdersLoaded({this.orders});

  @override
  List<Object> get props => [];
}

class AddOrdersError extends FirebaseState {}

//Fetch Orders
class FetchOrdersListEmpty extends FirebaseState {}

class FetchOrdersListLoading extends FirebaseState {}

class FetchOrdersListLoaded extends FirebaseState {
  final List<Cards> cards;

  const FetchOrdersListLoaded({this.cards});

  @override
  List<Object> get props => [];
}

class FetchOrdersListError extends FirebaseState {}

//Fetch Orders By OrderList
class FetchOrdersListByOrdersEmpty extends FirebaseState {}

class FetchOrdersListByOrdersLoading extends FirebaseState {}

class FetchOrdersListByOrdersLoaded extends FirebaseState {
  final List<Orders> orders;

  const FetchOrdersListByOrdersLoaded({this.orders});

  @override
  List<Object> get props => [];
}

class FetchOrdersListByOrdersError extends FirebaseState {}


//Add Vendor
class AddVendorEmpty extends FirebaseState {}

class AddVendorLoading extends FirebaseState {}

class AddVendorLoaded extends FirebaseState {
  final Vendors vendors;

  const AddVendorLoaded({this.vendors});

  @override
  List<Object> get props => [];
}

class AddVendorError extends FirebaseState {}


//Fetch Customer
class FetchCustomerEmpty extends FirebaseState {}

class FetchCustomerLoading extends FirebaseState {}

class FetchCustomerLoaded extends FirebaseState {
  final List<Customer> customer;

  const FetchCustomerLoaded({this.customer});

  @override
  List<Object> get props => [];
}

class FetchCustomerError extends FirebaseState {}

//Customer Update
class CustomerUpdateEmpty extends FirebaseState {}

class CustomerUpdateLoading extends FirebaseState {}

class CustomerUpdateLoaded extends FirebaseState {
  final Customer customer;

  const CustomerUpdateLoaded({@required this.customer}) : assert(customer != null);

  @override
  List<Object> get props => [];
}

class CustomerUpdateError extends FirebaseState {}

class CustomerUpdateUpdated extends FirebaseState {
  final bool isCustomerUpdated;

  const CustomerUpdateUpdated({@required this.isCustomerUpdated})
      : assert(isCustomerUpdated != null);

  @override
  List<Object> get props => [];
}

class CustomerUpdateFail extends FirebaseState {}

class CustomerUpdateDeleted extends FirebaseState {}


//Fetch Vendors
class FetchVendorsEmpty extends FirebaseState {}

class FetchVendorsLoading extends FirebaseState {}

class FetchVendorsLoaded extends FirebaseState {
  final List<Vendors> vendors;

  const FetchVendorsLoaded({this.vendors});

  @override
  List<Object> get props => [];
}

class FetchVendorsError extends FirebaseState {}

//Fetch Category
class FetchCategoryEmpty extends FirebaseState {}

class FetchCategoryLoading extends FirebaseState {}

class FetchCategoryLoaded extends FirebaseState {
  final List<Category> category;

  const FetchCategoryLoaded({this.category});

  @override
  List<Object> get props => [];
}

class FetchCategoryError extends FirebaseState {}


//Fetch SubCategory
class FetchSubCategoryEmpty extends FirebaseState {}

class FetchSubCategoryLoading extends FirebaseState {}

class FetchSubCategoryLoaded extends FirebaseState {
  final List<SubCategory> subCategory;

  const FetchSubCategoryLoaded({this.subCategory});

  @override
  List<Object> get props => [];
}

class FetchSubCategoryError extends FirebaseState {}