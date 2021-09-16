import 'package:cards_app/bloc/cards_bloc.dart';
import 'package:cards_app/bloc/cards_event.dart';
import 'package:cards_app/bloc/cards_state.dart';
import 'package:cards_app/models/cards.dart';
import 'package:cards_app/models/orders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderList extends StatefulWidget {
  const OrderList({Key key}) : super(key: key);

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<FirebaseBloc>(context).add(ResetFetchOrdersListByOrders());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF2562),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text("Order List"),
      ),
      body: BlocBuilder<FirebaseBloc, FirebaseState>(builder: (context, state) {
        print("STATE:${state}");

        if (state is FetchOrdersListByOrdersEmpty) {
          BlocProvider.of<FirebaseBloc>(context).add(FetchOrdersListByOrders());
        }

        if (state is FetchOrdersListByOrdersError) {
          return Center(
            child: Text("Failed to fetch data"),
          );
        }

        if (state is FetchOrdersListByOrdersLoaded) {
          var orderList = state.orders;
          return body(orderList);
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }

  Widget body(List<Orders> orderList) {
    return Stack(
      children: [
        Container(
            child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                  itemCount: orderList.length <= 0 ? 0 : orderList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Order Id:",
                                      style:
                                          TextStyle(color: Colors.pinkAccent),
                                    ),
                                    SizedBox(
                                      width: 7,
                                    ),
                                    Text(orderList[index].orderId),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Card Id:",
                                      style:
                                          TextStyle(color: Colors.pinkAccent),
                                    ),
                                    SizedBox(
                                      width: 7,
                                    ),
                                    Flexible(child:
                                    Text(orderList[index].cardId)
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Transaction Date:",
                                      style:
                                          TextStyle(color: Colors.pinkAccent),
                                    ),
                                    SizedBox(
                                      width: 7,
                                    ),

                                    Text(orderList[index]
                                        .transactionDate
                                        .toDate()
                                        .toString()),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Divider(
                                  thickness: 1,
                                  color: Colors.black,
                                )
                              ],
                            ),
                          )),
                    );
                  }),
            ),
            SizedBox(
              height: 40,
            ),
          ],
        )),
      ],
    );
  }
}
