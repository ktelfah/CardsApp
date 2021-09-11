import 'package:cards_app/bloc/cards_bloc.dart';
import 'package:cards_app/screens/add_admin.dart';
import 'package:cards_app/screens/add_cards.dart';
import 'package:cards_app/screens/add_customer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddAdminCustomerCards extends StatefulWidget {
  const AddAdminCustomerCards({Key key}) : super(key: key);

  @override
  _AddAdminCustomerCardsState createState() => _AddAdminCustomerCardsState();
}

class _AddAdminCustomerCardsState extends State<AddAdminCustomerCards> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF2562),
        title: Text("ADD"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                          value: BlocProvider.of<FirebaseBloc>(context),
                          child: AddAdmin())));
                },
                child: Container(
                  height: 40,
                  width: 130,
                  color: Color(0xFFFF2562),
                  child: Center(child: Text("ADD ADMIN")),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                      value: BlocProvider.of<FirebaseBloc>(context),
                      child: AddCard())));
            },
            child: Container(
              height: 40,
              width: 130,
              color: Color(0xFFFF2562),
              child: Center(child: Text("ADD CARD")),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                      value: BlocProvider.of<FirebaseBloc>(context),
                      child: AddCustomer())));
            },
            child: Container(
              height: 40,
              width: 130,
              color: Color(0xFFFF2562),
              child: Center(child: Text("ADD CUSTOMER")),
            ),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
