import 'package:cards_app/bloc/cards_bloc.dart';
import 'package:cards_app/bloc/cards_event.dart';
import 'package:cards_app/bloc/cards_state.dart';
import 'package:cards_app/main.dart';
import 'package:cards_app/models/cards.dart';
import 'package:cards_app/repository/cards_api.dart';
import 'package:cards_app/repository/cards_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class CardList extends StatefulWidget {
  const CardList({Key key}) : super(key: key);

  @override
  _CardListState createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  @override
  void initState() {
    BlocProvider.of<FirebaseBloc>(context).add(ResetFetchCards());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF2562),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text("Card List"),
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
    return Container(
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
                        child: Column(
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
                              thickness: 2,
                            )
                          ],
                        )),
                  );
                }),
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
             showAlert(context);
            },
            child: Container(
              height: 40,
              width: MediaQuery.of(context).size.width - 20,
              color: Color(0xFFFF2562),
              child: Center(
                  child: Text(
                    "Logout",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
          ),
          SizedBox(
            height: 8,
          ),
        ],
      )
    );
  }

  showAlert(BuildContext context) {
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
                Navigator.of(context).push(MaterialPageRoute(builder: (_)=>MyApp(repository: repository,)));
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
