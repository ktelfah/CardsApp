import 'package:cards_app/bloc/cards_bloc.dart';
import 'package:cards_app/bloc/cards_event.dart';
import 'package:cards_app/bloc/cards_state.dart';
import 'package:cards_app/main.dart';
import 'package:cards_app/models/customers.dart';
import 'package:cards_app/repository/cards_api.dart';
import 'package:cards_app/repository/cards_repository.dart';
import 'package:cards_app/screens/add_admin.dart';
import 'package:cards_app/screens/update_customer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class CustomersList extends StatefulWidget {
  @override
  _CustomersListState createState() => _CustomersListState();
}

class _CustomersListState extends State<CustomersList> {
  String decryptedS;
  String EncrytoDecryPassword;
  String adminId;
  String customerId;
  String name;
  String address;
  int balance;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<FirebaseBloc>(context).add(ResetFetchCustomer());
  }

  Future passwordDecrypted() async {
    decryptedS = await cryptor.decrypt(EncrytoDecryPassword, key);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF2562),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text("Customer List"),
      ),
      body: BlocBuilder<FirebaseBloc, FirebaseState>(builder: (context, state) {
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
      }),
    );
  }

  Widget body(List<Customer> customerList) {
    return Container(
        child: Column(
      children: [
        Flexible(
          child: ListView.builder(
            itemCount: customerList.length,
            itemBuilder: (BuildContext context, int index) {
              adminId = customerList[index].adminId;
              customerId = customerList[index].customerId;
              name = customerList[index].name;
              balance = customerList[index].balance;
              address = customerList[index].address;
              EncrytoDecryPassword = customerList[index].password;
              passwordDecrypted().whenComplete(() {});
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Dismissible(
                          key: Key(customerList[index].toString()),
                          child: Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width - 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blueGrey[50],
                            ),
                            child: Center(
                                child: Text(
                              customerList[index].name,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            )),
                          ),
                          background: slideLeftBackground(),
                          confirmDismiss: (direction) async {
                            if (direction == DismissDirection.endToStart) {
                              final bool res = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return updateDialog(
                                        context,
                                        customerList[index].adminId,
                                        customerList[index].customerId,
                                        customerList[index].name,
                                        customerList[index].balance,
                                        customerList[index].address,
                                        decryptedS);
                                  });
                              return res;
                            } else {
                              final bool res = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return updateDialog(
                                        context,
                                        customerList[index].adminId,
                                        customerList[index].customerId,
                                        customerList[index].name,
                                        customerList[index].balance,
                                        customerList[index].address,
                                        decryptedS);
                                  });
                              return res;
                            }
                          }),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ));
  }

  Widget updateDialog(
      BuildContext mainContext,
      String adminId,
      String customerId,
      String name,
      int balance,
      String address,
      String decryptedS) {
    return AlertDialog(
      content: Text("Are you sure you want to edit '' ?"),
      actions: <Widget>[
        FlatButton(
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () {
            Navigator.of(mainContext).pop();
          },
        ),
        FlatButton(
          child: Text(
            "Edit",
            style: TextStyle(color: Colors.green),
          ),
          onPressed: () async {
            Navigator.of(mainContext).pop();
            var value = Navigator.of(mainContext).push(MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                    value: BlocProvider.of<FirebaseBloc>(context),
                    child: UpdateCustomers(
                      adminId: adminId,
                      customerId: customerId,
                      name: name,
                      balance: balance,
                      address: address,
                      password: decryptedS,
                    ))));
            //Navigator.of(mainContext).pop();
            print("RES UDPAED:$value");
          },
        ),
      ],
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.edit,
              color: Colors.white,
            ),
            Text(
              " Edit",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
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
