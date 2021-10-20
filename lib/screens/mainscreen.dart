import 'package:cards_app/bloc/cards_bloc.dart';
import 'package:cards_app/bloc/cards_event.dart';
import 'package:cards_app/bloc/cards_state.dart';
import 'package:cards_app/models/vendors.dart';
import 'package:cards_app/repository/cards_api.dart';
import 'package:cards_app/repository/cards_repository.dart';
import 'package:cards_app/screens/category_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

var getSelectedVendorId;
var getSelectedVendorName;

class MainScreen extends StatefulWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  num amm;
  String icons;
  var amount;
  bool prepaid = true;
  bool direct = false;
  List directs = [];
  List directvendorid = [];
  List directvendorname = [];
  List prepaids = [];
  List prepaidvendorid = [];
  List prepaidvendorname = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<FirebaseBloc>(context).add(ResetFetchVendors());

    FirebaseFirestore.instance
        .collection("customers")
        .where("name", isEqualTo: "$customerNameGet")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        amm = result.get('balance');
        print(amm);
      });
    });
  }

  @override
  void setState(VoidCallback fn) {
    customerAmountGet;
    super.setState(fn);
  }

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_statements
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF2562),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text("Hello, ${customerNameGet}"),
      ),
      //body: body(vendorsList),
      body: BlocBuilder<FirebaseBloc, FirebaseState>(builder: (context, state) {
        FirebaseFirestore.instance
            .collection("vendors")
            .where("type", isEqualTo: "Prepaid")
            .get()
            .then((querySnapshot) {
          if (prepaids.isEmpty) {
            querySnapshot.docs.forEach((result) {
              prepaids.add(result.get('icon'));

              print(prepaids);
            });
          } else {
            prepaids.clear();
            querySnapshot.docs.forEach((result) {
              prepaids.add(result.get('icon'));
              prepaidvendorid.add(result.get('vendorId'));
              prepaidvendorname.add(result.get('name'));
              print(prepaids);
            });
          }
        });

        FirebaseFirestore.instance
            .collection("vendors")
            .where("type", isEqualTo: "Direct")
            .get()
            .then((querySnapshot) {
          if (directs.isEmpty) {
            querySnapshot.docs.forEach((result) {
              directs.add(result.get('icon'));
              print(directs);
            });
          } else {
            directs.clear();
            querySnapshot.docs.forEach((result) {
              directs.add(result.get('icon'));
              directvendorid.add(result.get('vendorId'));
              directvendorname.add(result.get('name'));
              print(directs);
            });
          }
        });

        if (state is FetchVendorsEmpty) {
          BlocProvider.of<FirebaseBloc>(context).add(FetchVendors());
        }

        if (state is FetchVendorsError) {
          return Center(
            child: Text("Failed to fetch data"),
          );
        }

        if (state is FetchVendorsLoaded) {
          var vendorsList = state.vendors;
          return body(vendorsList);
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }

  Widget body(List<Vendors> vendorsList) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.black),
                  child: Icon(
                    Icons.monetization_on_rounded,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Your Balance",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text("$amm", style: TextStyle(color: Colors.white)),
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
                                        amm = customerAmountGet +
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
                                            amm,
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
                      icon: Icon(
                        Icons.add_circle_outline_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    prepaid = true;
                    direct = false;
                  });

                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (_) => BlocProvider.value(
                  //         value: BlocProvider.of<FirebaseBloc>(context),
                  //         child: VendorList())));
                },
                child: Container(
                    margin: EdgeInsets.only(top: 20.0),
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25)),
                            child: Image.asset(
                              "assets/prepaid.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            decoration: BoxDecoration(
                              color: prepaid ? Colors.indigo : Colors.grey,
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(25),
                                  bottomLeft: Radius.circular(25)),
                            ),
                            height: 50,
                            width: 200,
                            child: Center(
                              child: Text(
                                "Prepaid Cards",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    prepaid = false;
                    direct = true;
                  });
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (_) => BlocProvider.value(
                  //         value: BlocProvider.of<FirebaseBloc>(context),
                  //         child: VendorList())));
                  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  //   content: Text('This option is not available right now.'),
                  // ));
                },
                child: Container(
                    margin: EdgeInsets.only(top: 20.0),
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25)),
                            child: Image.asset(
                              "assets/direct1.jpg",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            decoration: BoxDecoration(
                              color: direct ? Colors.indigo : Colors.grey,
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(25),
                                  bottomLeft: Radius.circular(25)),
                            ),
                            height: 50,
                            width: 200,
                            child: Center(
                              child: Text(
                                "Direct",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          prepaid
              ? Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 6.0,
                          mainAxisSpacing: 6.0),
                      itemCount: prepaids.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            getSelectedVendorId = prepaidvendorid[index];
                            getSelectedVendorName = prepaidvendorname[index];
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                    value:
                                        BlocProvider.of<FirebaseBloc>(context),
                                    child: CategoryList())));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.red[500],
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6))),
                            child: SvgPicture.network(
                              prepaids[index],
                              height: 300,
                              width: 300,
                              fit: BoxFit.fill,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              : direct
                  ? Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 6.0,
                                  mainAxisSpacing: 6.0),
                          itemCount: directs.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                getSelectedVendorId = directvendorid[index];
                                getSelectedVendorName = directvendorname[index];
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => BlocProvider.value(
                                        value: BlocProvider.of<FirebaseBloc>(
                                            context),
                                        child: CategoryList())));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.red[500],
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6))),
                                child: SvgPicture.network(
                                  directs[index],
                                  // vendorsList[index].icon,
                                  height: 300,
                                  width: 300,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : Container(
                      child: Text("Please Select"),
                    ),
        ],
      ),
    );
  }
}
