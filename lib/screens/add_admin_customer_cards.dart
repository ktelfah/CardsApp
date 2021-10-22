import 'package:cards_app/bloc/cards_bloc.dart';
import 'package:cards_app/bloc/cards_event.dart';
import 'package:cards_app/bloc/cards_state.dart';
import 'package:cards_app/main.dart';
import 'package:cards_app/models/customers.dart';
import 'package:cards_app/repository/cards_api.dart';
import 'package:cards_app/repository/cards_repository.dart';
import 'package:cards_app/screens/add_admin.dart';
import 'package:cards_app/screens/add_cards.dart';
import 'package:cards_app/screens/add_customer.dart';
import 'package:cards_app/screens/add_subcategory.dart';
import 'package:cards_app/screens/add_vendor.dart';
import 'package:cards_app/screens/customer_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'add_category.dart';

class AddAdminCustomerCards extends StatefulWidget {
  AddAdminCustomerCards({this.isSuperAdmin = false});
  bool isSuperAdmin;

  @override
  _AddAdminCustomerCardsState createState() => _AddAdminCustomerCardsState();
}

class _AddAdminCustomerCardsState extends State<AddAdminCustomerCards> {
  String decryptedS;
  String EncrytoDecryPassword;
  String adminId;
  String customerId;
  String name;
  String address;
  int balance;
  bool isadmin;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<FirebaseBloc>(context).add(ResetFetchCustomer());
    isadmin = widget.isSuperAdmin;
  }

  Future passwordDecrypted() async {
    decryptedS = await cryptor.decrypt(EncrytoDecryPassword, key);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        SystemNavigator.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFFF2562),
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text("ADD"),
        ),
        body: BlocBuilder<FirebaseBloc, FirebaseState>(
          builder: (context, state) {
            if (state is FetchCustomerEmpty) {
              BlocProvider.of<FirebaseBloc>(context).add(FetchCustomer());
            }

            if (state is FetchCustomerError) {
              return Center(
                child: Text("Failed to fetch data"),
              );
            }

            if (state is FetchCustomerLoaded) {
              var customerList = state.customer;
              return body(customerList);
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  Widget body(List<Customer> customerList) {
    return Container(
      child: Column(
        children: [
          Spacer(),
          SizedBox(
            height: 5,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                children: [
                  //=========================================================================================//
                  isadmin
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => BlocProvider.value(
                                        value: BlocProvider.of<FirebaseBloc>(
                                            context),
                                        child: AddCategory())));
                              },
                              child: Container(
                                height: 40,
                                width: 130,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xFFFF2562),
                                ),
                                child: Center(child: Text("ADD CATEGORY")),
                              ),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => BlocProvider.value(
                                        value: BlocProvider.of<FirebaseBloc>(
                                            context),
                                        child: AddSubCategory())));
                              },
                              child: Container(
                                height: 40,
                                width: 130,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xFFFF2562),
                                ),
                                child: Center(
                                    child: Text(
                                  "ADD SUBCATEGORY",
                                  style: TextStyle(fontSize: 13),
                                )),
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  // ========================================================================================//
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isadmin == false
                          ? GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => BlocProvider.value(
                                        value: BlocProvider.of<FirebaseBloc>(
                                            context),
                                        child: CustomersList())));
                              },
                              child: Container(
                                height: 40,
                                width: 130,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xFFFF2562),
                                ),
                                child: Center(child: Text("Customers List")),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isadmin == false
                          ? GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => BlocProvider.value(
                                        value: BlocProvider.of<FirebaseBloc>(
                                            context),
                                        child: AddCustomer())));
                              },
                              child: Container(
                                height: 40,
                                width: 130,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xFFFF2562),
                                ),
                                child: Center(child: Text("ADD CUSTOMER")),
                              ),
                            )
                          : Container(),
                      SizedBox(
                        width: 30,
                      ),
                      isadmin == false
                          ? GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => BlocProvider.value(
                                        value: BlocProvider.of<FirebaseBloc>(
                                            context),
                                        child: AddCard())));
                              },
                              child: Container(
                                height: 40,
                                width: 130,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xFFFF2562),
                                ),
                                child: Center(child: Text("ADD CARD")),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              isadmin
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                    value:
                                        BlocProvider.of<FirebaseBloc>(context),
                                    child: AddAdmin())));
                          },
                          child: Container(
                            height: 40,
                            width: 130,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFFFF2562),
                            ),
                            child: Center(child: Text("ADD ADMIN")),
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                    value:
                                        BlocProvider.of<FirebaseBloc>(context),
                                    child: AddVendor())));
                          },
                          child: Container(
                            height: 40,
                            width: 130,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFFFF2562),
                            ),
                            child: Center(child: Text("ADD VENDOR")),
                          ),
                        ),
                      ],
                    )
                  : Container(),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  showAlert(context);
                },
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width - 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFFFF2562),
                  ),
                  child: Center(
                      child: Text(
                    "Logout",
                    style: TextStyle(color: Colors.white),
                  )),
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ],
      ),
    );
  }

  showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text("Are you sure you want to logout?"),
          actions: <Widget>[
            FlatButton(
              child: Text("YES"),
              onPressed: () {
                // Navigator.of(context).pop();
                final FirebaseRepository repository = FirebaseRepository(
                  firebaseApiClient: FirebaseApiClient(
                    httpClient: http.Client(),
                  ),
                );
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (_) => MyApp(
                              repository: repository,
                            )),
                    (route) => false);
                // Navigator.of(context).push(MaterialPageRoute(
                //     builder: (_) => MyApp(
                //           repository: repository,
                //         )));
              },
            ),
            FlatButton(
              child: Text("NO"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
