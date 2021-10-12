import 'package:cards_app/bloc/cards_bloc.dart';
import 'package:cards_app/repository/cards_api.dart';
import 'package:cards_app/repository/cards_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'mainscreen.dart';

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
  TextEditingController controller = TextEditingController();
  var amount;
  bool navigate = false;

  // void navigate(BuildContext context) {
  //   Navigator.of(context).push(
  //     MaterialPageRoute<FirebaseBloc>(
  //       builder: (_) => BlocProvider.value(
  //         value: BlocProvider.of<FirebaseBloc>(context),
  //         child: MainScreen(),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop();
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFFFF2562),
            automaticallyImplyLeading: true,
            centerTitle: true,
            title: Text("Cart"),
          ),
          body: body(ctx: context)
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
          ),
    );
  }

  Widget body({BuildContext ctx}) {
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
                    Text(
                      "Add Balance",
                      style: TextStyle(color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                actions: [
                                  FlatButton(
                                      onPressed: () async {
                                        customerAmountGet = customerAmountGet +
                                            int.parse(amount);
                                        FirebaseRepository fb =
                                            FirebaseRepository(
                                          firebaseApiClient: FirebaseApiClient(
                                            httpClient: http.Client(),
                                          ),
                                        );
                                        var customerPasswordEncrypted;
                                        CollectionReference customer =
                                            FirebaseFirestore.instance
                                                .collection('customers');
                                        var customerGetPasswordEncrypted =
                                            await customer
                                                .where("name",
                                                    isEqualTo: customerNameGet)
                                                .get();
                                        customerPasswordEncrypted =
                                            await customerGetPasswordEncrypted
                                                .docs[0]
                                                .get('password');

                                        fb.updateCustomer(
                                            customerIdGet,
                                            adminIdGet,
                                            customerNameGet,
                                            customerAmountGet,
                                            customerPasswordEncrypted,
                                            customerAddressGet);
                                        Navigator.of(context).pop();
                                        setState(() {});
                                      },
                                      child: Text("Add"))
                                ],
                                title: Text('Add Balance'),
                                content: TextField(
                                  onChanged: (value) {
                                    amount = value;
                                  },
                                  controller: controller,
                                  decoration:
                                      InputDecoration(hintText: "Enter amount"),
                                ),
                              );
                            });
                      },
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
                  //Text("Zain"),
                  //Text("Mix"),
                  Text("Price"),
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
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      actionsPadding: EdgeInsets.only(right: 10.0),
                      content: Text(
                        "Are you sure you want to buy ${widget.plan} card with ${quantity} quantity?",
                        style: TextStyle(fontSize: 15.0),
                      ),
                      title: Text(
                        "Please confirm",
                        style: TextStyle(fontSize: 15.0),
                      ),
                      actions: [
                        GestureDetector(
                          onTap: () async {
                            FirebaseRepository fb = FirebaseRepository(
                              firebaseApiClient: FirebaseApiClient(
                                httpClient: http.Client(),
                              ),
                            );

                            var customerPasswordEncrypted;
                            if (quantity != 0) {
                              if (quantity <= int.parse(widget.quantity) &&
                                  customerAmountGet >=
                                      int.parse(widget.price)) {
                                try {
                                  var finalBalance = customerAmountGet -
                                      int.parse(widget.price);
                                  var finalQuantity =
                                      int.parse(widget.quantity) - quantity;
                                  print('Final Balance = $finalBalance');
                                  print('Final Balance = $finalQuantity');
                                  CollectionReference customer =
                                      FirebaseFirestore.instance
                                          .collection('customers');
                                  var customerGetPasswordEncrypted =
                                      await customer
                                          .where("name",
                                              isEqualTo: customerNameGet)
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
                                          .update({
                                        "quantity":
                                            '${finalQuantity.toString()}'
                                      });
                                      DateTime i = DateTime.now();
                                      // DateFormat(format.toString(), i.toString());
                                      var t = Timestamp.fromDate(i);
                                      print('TIME  === $t');
                                      FirebaseRepository(
                                        firebaseApiClient: FirebaseApiClient(
                                          httpClient: http.Client(),
                                        ),
                                      ).addOrders('', customerIdGet, '', t);
                                    },
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Card bought successfully.',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  );
                                  // Navigator.of(context).pop();

                                  //============================================================================//

                                  Navigator.of(ctx)
                                      .push(
                                    MaterialPageRoute<FirebaseBloc>(
                                      builder: (_) => BlocProvider.value(
                                        value:
                                            BlocProvider.of<FirebaseBloc>(ctx),
                                        child: MainScreen(),
                                      ),
                                    ),
                                  )
                                      .then((value) {
                                    setState(() {
                                      print(
                                          "=================== DONE ==============");
                                    });
                                  });

                                  //===========================================================================//
                                } catch (e) {
                                  print('ERROR IN CUSTOMER UPDATE =$e');
                                }
                              } else {
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        content: Text(
                                  'Please Check Balance',
                                  style: TextStyle(color: Colors.white),
                                )));
                              }
                            } else {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                      content: Text(
                                'Quantity Is Over',
                                style: TextStyle(color: Colors.white),
                              )));
                            }
                          },
                          child: Text(
                            "Buy",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Cancel",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                      ],
                    );
                  },
                );
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
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                // Navigator.of(context).push(
                //   MaterialPageRoute<FirebaseBloc>(
                //     builder: (_) => BlocProvider.value(
                //       value: BlocProvider.of<FirebaseBloc>(context),
                //       child: MainScreen(),
                //     ),
                //   ),
                // );
                // showModalBottomSheet(
                //     context: context,
                //     builder: (BuildContext context) {
                //       return Center(
                //         child: Column(
                //           children: [
                //             Container(
                //               child: Text("I am Bottom Sheet"),
                //             ),
                //             ElevatedButton(
                //                 onPressed: () {
                //                   Navigator.of(context).push(
                //                     MaterialPageRoute<FirebaseBloc>(
                //                       builder: (_) => BlocProvider.value(
                //                         value: BlocProvider.of<FirebaseBloc>(
                //                             context),
                //                         child: MainScreen(),
                //                       ),
                //                     ),
                //                   );
                //                 },
                //                 child: Text("Close")),
                //           ],
                //         ),
                //       );
                //     });
              },
              child: Container(
                width: 250,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.yellowAccent,
                ),
                child: Center(
                  child: Text("Buy new"),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
