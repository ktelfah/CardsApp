import 'package:cards_app/models/admin.dart';
import 'package:cards_app/models/cards.dart';
import 'package:cards_app/models/customers.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

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
