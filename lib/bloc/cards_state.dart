import 'package:cards_app/models/admin.dart';
import 'package:cards_app/models/cards.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class FirebaseState extends Equatable{
  const FirebaseState();

  @override
  List<Object> get props => [];
}

//LOGIN
class LoginEmpty extends FirebaseState {}

class LoginLoading extends FirebaseState {}

class LoginLoaded extends FirebaseState {
  final Admin? admin;

  const LoginLoaded({required this.admin});
  //: assert(login != null);
  // : assert(login != null);

  @override
  List<Object> get props => [];
}

class LoginError extends FirebaseState {}


//Add Admin
class AddAdminEmpty extends FirebaseState {}

class AddAdminLoading extends FirebaseState {}

class AddAdminLoaded extends FirebaseState {
  final Admin? admin;

  const AddAdminLoaded({required this.admin});
  //: assert(login != null);
  // : assert(login != null);

  @override
  List<Object> get props => [];
}

class AddAdminError extends FirebaseState {}


//Add Card
class AddCardEmpty extends FirebaseState {}

class AddCardLoading extends FirebaseState {}

class AddCardLoaded extends FirebaseState {
  final Cards? card;

  const AddCardLoaded({required this.card});
  //: assert(login != null);
  // : assert(login != null);

  @override
  List<Object> get props => [];
}

class AddCardError extends FirebaseState {}
















