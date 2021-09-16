import 'package:cards_app/bloc/cards_bloc.dart';
import 'package:cards_app/bloc/cards_event.dart';
import 'package:cards_app/bloc/cards_state.dart';
import 'package:cards_app/main.dart';
import 'package:cards_app/models/cards.dart';
import 'package:cards_app/repository/cards_api.dart';
import 'package:cards_app/repository/cards_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

var minusCustomerBalance;
String addCardIds;
List<String> arrayCardIDs;

class CardList extends StatefulWidget {
  const CardList({Key key}) : super(key: key);

  @override
  _CardListState createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  int count = 0;
  int checkedAmount = 0;
  int checkCardAmount;
  String cardSelectedId;
  List<String> buyCardsArray = [];
  Timestamp now = Timestamp.now();

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
      // body: body(),
      body: BlocBuilder<FirebaseBloc, FirebaseState>(builder: (context, state) {
        if (state is FetchCardEmpty) {
          BlocProvider.of<FirebaseBloc>(context).add(FetchCards());
        }

        if (state is FetchCardError) {
          return Center(
            child: Text("Failed to fetch data"),
          );
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
        Column(
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
                                      color: Colors.black,
                                    )
                                  ],
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    cardSelectedId = cardList[index].cardId;
                                    buyCardsArray.add(cardSelectedId);
                                    checkCardAmount = cardList[index].amount;
                                    buyCard();
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
                                    cardSelectedId = cardList[index].cardId;
                                    checkCardAmount = cardList[index].amount;
                                    if (value == true) {
                                      count = count + 1;
                                      buyCardsArray.add(cardSelectedId);
                                      checkedAmount =
                                          checkedAmount + checkCardAmount;

                                      if (count >= 2) {}
                                    } else {
                                      count = count - 1;
                                      buyCardsArray.remove(cardSelectedId);
                                      checkedAmount =
                                          checkedAmount - checkCardAmount;

                                      if (count >= 2) {}
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
        ),
        count >= 2
            ? Positioned(
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
                      buyAllCards();
                    },
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Buy All",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFF2562),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : SizedBox(
                height: 0.1,
                width: 0.1,
              ),
      ],
    );
  }

  ///Buy Only One Cards
  void buyCard() {
    addCardIds = buyCardsArray.join(', ');
    arrayCardIDs = addCardIds.split(",");
    if (customerAmountGet >= checkCardAmount) {
      minusCustomerBalance = customerAmountGet - checkCardAmount;
      BlocProvider.of<FirebaseBloc>(context).add(FetchAddOrders(
        addCardIds,
        adminIdGet,
        '',
        now,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
  }

  ///Buy More than One Cards
  void buyAllCards() {
    addCardIds = buyCardsArray.join(',');
    arrayCardIDs = addCardIds.split(",");
    if (checkedAmount <= customerAmountGet) {
      minusCustomerBalance = customerAmountGet - checkedAmount;
      print("Both  are same");
      BlocProvider.of<FirebaseBloc>(context).add(FetchAddOrders(
        addCardIds,
        adminIdGet,
        '',
        now,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
  }

  ///Show Alert for LogOut
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
