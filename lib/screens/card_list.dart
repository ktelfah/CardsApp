import 'package:cards_app/bloc/cards_bloc.dart';
import 'package:cards_app/bloc/cards_event.dart';
import 'package:cards_app/bloc/cards_state.dart';
import 'package:cards_app/main.dart';
import 'package:cards_app/models/cards.dart';
import 'package:cards_app/models/orders.dart';
import 'package:cards_app/repository/cards_api.dart';
import 'package:cards_app/repository/cards_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

var fetchCardId;
var minusCustomerBalance;

class CardList extends StatefulWidget {
  const CardList({Key key}) : super(key: key);

  @override
  _CardListState createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  int count = 0;
  int checkedAmount = 0;
  int checkCardAmount;
  List<Orders> arrayBuyCards = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<FirebaseBloc>(context).add(ResetFetchCards());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF2562),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text("Card List"),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              showAlert(context);
            },
            child: Icon(Icons.logout),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.pinkAccent,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border, color: Color(0xFFFF2562)),
            label: "OrdersList",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_travel_sharp, color: Color(0xFFFF2562)),
            label: "CardsList",
          ),
        ],
      ),
      // body: body(),
      body: BlocBuilder<FirebaseBloc, FirebaseState>(builder: (context, state) {
        print("STATE:${state}");
        if (state is FetchCardEmpty) {
          BlocProvider.of<FirebaseBloc>(context).add(FetchCards());
        }

        if (state is FetchCardError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                "Invalid Data",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    height: 3.0,
                    fontSize: 20),
              ),
              backgroundColor: Colors.red,
            ));
          });
        }

        if (state is FetchCardLoaded) {
          var cardList = state.cards;
          return body(cardList);
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }

  Widget body(List<Cards> cardList) {
    return Stack(
      children: [
        Container(
            child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                  itemCount: cardList.length <= 0 ? 0 : cardList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Container(
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Card Number: ${cardList[index].cardNumber}",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Card Vender: ${cardList[index].cardVender}",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Amount: ${cardList[index].amount}",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Divider(
                                      thickness: 7,
                                    )
                                  ],
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    print(
                                        "Card Amount:::${cardList[index].amount}");
                                    print(
                                        "CUSTOMER TOTAL BALANCES:::${customerAmountget}");
                                    if (customerAmountget >=
                                        cardList[index].amount) {
                                      minusCustomerBalance = customerAmountget -
                                          cardList[index].amount;
                                      print(
                                          "MINUS***********${minusCustomerBalance}");
                                      print("*******BOTH ARE SAME******");
                                      fetchCardId = cardList[index].cardId;
                                      BlocProvider.of<FirebaseBloc>(context)
                                          .add(FetchAddOrders(
                                        fetchCardId,
                                        adminIdget,
                                        '',
                                        DateFormat("dd-MM-yyyy hh:mm a")
                                            .format(DateTime.now()),
                                      ));
                                    } else {
                                      print("*********NOT SAME********");
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        content: Text(
                                          "Your Balance is less than card amount",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                          ),
                                        ),
                                        backgroundColor: Colors.black,
                                      ));
                                    }
                                  },
                                  child: Container(
                                    height: 25,
                                    width: 40,
                                    child: Center(child: Text("Buy")),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color(0xFFFF2562),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Checkbox(
                                  checkColor: Colors.black,
                                  activeColor: Colors.pink,
                                  value: cardList[index].isChecked,
                                  onChanged: (value) {
                                    checkCardAmount = cardList[index].amount;
                                    print("Selected value:************${value}");
                                    print("Card Amount:::${cardList[index].amount}");
                                    print("CUSTOMER TOTAL BALANCES:::${customerAmountget}");
                                    print("Customer ID:::${adminIdget}");
                                    if (value == true) {
                                      count = count + 1;
                                      checkedAmount  = checkedAmount + cardList[index].amount;
                                      print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^${checkedAmount}");

                                      if (count >= 2) {
                                        print("true*********");
                                      }
                                    } else {
                                      count = count - 1;
                                      checkedAmount  = checkedAmount - cardList[index].amount;
                                      print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^${checkedAmount}");
                                      if (count >= 2) {
                                        print("true*********");
                                      }
                                    }
                                    setState(() {
                                      cardList[index].isChecked = value;
                                    });
                                  },
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
        if (count >= 2)
          Positioned(
            bottom: 48.0,
            left: 10.0,
            right: 10.0,
            child: Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: GestureDetector(
                onTap: () {
                  print("Buy All Checked Amount${checkedAmount}");
                  print("Buy All Checked  Card Amount${customerAmountget}");
                  if (checkedAmount <= customerAmountget) {
                    print("Both  are same");

                    // BlocProvider.of<FirebaseBloc>(context)
                    //     .add(FetchAddOrders(
                    //   fetchCardId,
                    //   adminIdget,
                    //   '',
                    //   DateFormat("dd-MM-yyyy hh:mm a")
                    //       .format(DateTime.now()),
                    // ));
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text(
                        "Your Balance is less than card amount",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Colors.black,
                    ));
                    print("Both not same");
                  }
                } ,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Buy All",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  void showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text("Are You Sure You Want To Logout?"),
          actions: <Widget>[
            FlatButton(
              child: Text("YES"),
              onPressed: () {
                Navigator.of(context).pop();
                final FirebaseRepository repository = FirebaseRepository(
                  firebaseApiClient: FirebaseApiClient(
                    httpClient: http.Client(),
                  ),
                );
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => MyApp(
                          repository: repository,
                        )));
                // Navigator.of(context).push(MaterialPageRoute(
                //     builder: (_) => BlocProvider.value(
                //         value: BlocProvider.of<FirebaseBloc>(context),
                //         child: HomePage())));
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
