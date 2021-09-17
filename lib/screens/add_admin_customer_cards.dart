import 'package:cards_app/bloc/cards_bloc.dart';
import 'package:cards_app/main.dart';
import 'package:cards_app/repository/cards_api.dart';
import 'package:cards_app/repository/cards_repository.dart';
import 'package:cards_app/screens/add_admin.dart';
import 'package:cards_app/screens/add_cards.dart';
import 'package:cards_app/screens/add_customer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class AddAdminCustomerCards extends StatefulWidget {
  const AddAdminCustomerCards({Key key}) : super(key: key);

  @override
  _AddAdminCustomerCardsState createState() => _AddAdminCustomerCardsState();
}

class _AddAdminCustomerCardsState extends State<AddAdminCustomerCards> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFFF2562),
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text("ADD"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
            ),
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
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFFFF2562),
                    ),
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
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFFFF2562),
                ),
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
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFFFF2562),
                ),
                child: Center(child: Text("ADD CUSTOMER")),
              ),
            ),
            Spacer(),
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
