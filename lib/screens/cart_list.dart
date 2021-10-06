import 'package:cards_app/bloc/cards_bloc.dart';
import 'package:cards_app/repository/cards_api.dart';
import 'package:cards_app/repository/cards_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'order_list.dart';

class CartList extends StatefulWidget {
  const CartList(
      {Key key, this.price, this.quantity, this.plan, this.vendor, this.uniqid})
      : super(key: key);

  final String vendor;
  final String quantity;
  final String plan;
  final String price;
  final String uniqid;

  @override
  _CartListState createState() => _CartListState();
}

class _CartListState extends State<CartList> {
  var format = new DateFormat('yyyy-MM-dd HH:mm a');

  //
  // @override
  // void initState() {
  //   super.initState();
  //   BlocProvider.of<FirebaseBloc>(context).add(ResetFetchOrdersListByOrders());
  // }

  int quantity = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFFF2562),
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text("Cart"),
        ),
        body: body()
        // BlocBuilder<FirebaseBloc, FirebaseState>(builder: (context, state) {
        //   print("STATE:${state}");
        //
        //   if (state is FetchOrdersListByOrdersEmpty) {
        //     BlocProvider.of<FirebaseBloc>(context).add(FetchOrdersListByOrders());
        //   }
        //
        //   if (state is FetchOrdersListByOrdersError) {
        //     return Center(
        //       child: Text("Failed to fetch data"),
        //     );
        //   }
        //
        //   if (state is FetchOrdersListByOrdersLoaded) {
        //     var orderList = state.orders;
        //     return body();
        //   }
        //
        //   return Center(
        //     child: CircularProgressIndicator(),
        //   );
        // }),
        );
  }

  Widget body() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.indigo,
            ),
            margin: EdgeInsets.all(10.0),
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.black),
                ),
                Column(
                  children: [
                    Text(
                      "Balance",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text("$customerAmountGet",
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
                Spacer(),
                Column(
                  children: [
                    Text("Add Balance", style: TextStyle(color: Colors.white)),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.add_circle_outline_outlined),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Column(
                children: [
                  Text("Zain"),
                  Text("Mix"),
                  Text("price"),
                ],
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.indigo,
                  ),
                  margin: EdgeInsets.all(10.0),
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(widget.plan,
                                style: TextStyle(color: Colors.white)),
                          ]),
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        Text("price: ${widget.price}",
                            style: TextStyle(color: Colors.white)),
                      ]),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text("Quantity"),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12, width: 1)),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                if (quantity > 0) {
                                  quantity--;
                                }
                              });
                            },
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.black,
                            )),
                        Text("$quantity"),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                quantity++;
                              });
                            },
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black,
                            ))
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: GestureDetector(
              onTap: () async {
                FirebaseRepository fb = FirebaseRepository(
                  firebaseApiClient: FirebaseApiClient(
                    httpClient: http.Client(),
                  ),
                );

                var customerPasswordEncrypted;
                if (quantity != 0) {
                  if (quantity <= int.parse(widget.quantity) &&
                      customerAmountGet >= int.parse(widget.price)) {
                    try {
                      var finalBalance =
                          customerAmountGet - int.parse(widget.price);
                      var finalQuantity = int.parse(widget.quantity) - quantity;
                      print('Final Balance = $finalBalance');
                      print('Final Balance = $finalQuantity');
                      CollectionReference customer =
                          FirebaseFirestore.instance.collection('customers');
                      var customerGetPasswordEncrypted = await customer
                          .where("name", isEqualTo: customerNameGet)
                          .get();
                      customerPasswordEncrypted =
                          await customerGetPasswordEncrypted.docs[0]
                              .get('password');

                      fb
                          .updateCustomer(
                              customerIdGet,
                              adminIdGet,
                              customerNameGet,
                              finalBalance,
                              customerPasswordEncrypted,
                              customerAddressGet)
                          .then(
                        (value) {
                          fb.firebaseApiClient.subCategories
                              .doc(widget.uniqid)
                              .update(
                                  {"quantity": '${finalQuantity.toString()}'});
                          DateTime i = DateTime.now();
                          // DateFormat(format.toString(), i.toString());
                          var t = Timestamp.fromDate(i);
                          print('TIME  === $t');
                          FirebaseRepository(
                            firebaseApiClient: FirebaseApiClient(
                              httpClient: http.Client(),
                            ),
                          ).addOrders('', customerIdGet, '', t);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: BlocProvider.of<FirebaseBloc>(context),
                                child: OrderList(),
                              ),
                            ),
                          );
                        },
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Balance buy successfully',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    } catch (e) {
                      print('ERROR IN CUSTOMER UPDATE =$e');
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                      'Error Occurred',
                      style: TextStyle(color: Colors.white),
                    )));
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                    'Select Proper Quantity',
                    style: TextStyle(color: Colors.white),
                  )));
                }
              },
              child: Container(
                width: 250,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.yellowAccent,
                ),
                child: Center(
                  child: Text("Buy"),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
