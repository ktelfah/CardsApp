import 'package:cards_app/bloc/cards_bloc.dart';
import 'package:cards_app/bloc/cards_event.dart';
import 'package:cards_app/bloc/cards_state.dart';
import 'package:cards_app/models/vendors.dart';
import 'package:cards_app/repository/cards_api.dart';
import 'package:cards_app/repository/cards_repository.dart';
import 'package:cards_app/screens/vendors_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

var getSelectedVendorId;
var getSelectedVendorName;

class MainScreen extends StatefulWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<FirebaseBloc>(context).add(ResetFetchVendors());
  }

  TextEditingController controller = TextEditingController();
  var amount;
  @override
  Widget build(BuildContext context) {
    print("name$customerNameGet");
    print("name$customerAmountGet");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF2562),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text("Hello, ${customerNameGet}"),
      ),
      //body: body(vendorsList),
      body: BlocBuilder<FirebaseBloc, FirebaseState>(builder: (context, state) {
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
          // Container(
          //   height: 80,
          //   // width: MediaQuery.of(context).size.width - 20,
          //   decoration: BoxDecoration(
          //     color: Colors.blueGrey,
          //     borderRadius: BorderRadius.all(
          //       Radius.circular(6),
          //     ),
          //   ),
          //   child: Padding(
          //     padding: const EdgeInsets.all(12.0),
          //     child: Row(
          //       children: [
          //         Text(
          //           "Your Balance: ${customerAmountGet}",
          //           style: TextStyle(fontSize: 20),
          //         ),
          //         Spacer(),
          //         Icon(
          //           Icons.add,
          //           size: 30,
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
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
                        print("press");
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
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                          value: BlocProvider.of<FirebaseBloc>(context),
                          child: VendorList())));
                },
                child: Container(
                    margin: EdgeInsets.only(top: 20.0),
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Container(),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.indigo,
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(25),
                                  bottomLeft: Radius.circular(25)),
                            ),
                            height: 50,
                            width: 200,
                            child: Center(
                              child: Text(
                                "Prepaid cards",
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
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                          value: BlocProvider.of<FirebaseBloc>(context),
                          child: VendorList())));
                },
                child: Container(
                    margin: EdgeInsets.only(top: 20.0),
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Container(),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.indigo,
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
          // Flexible(
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: GridView.builder(
          //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //           crossAxisCount: 2,
          //           crossAxisSpacing: 6.0,
          //           mainAxisSpacing: 6.0),
          //       itemCount: vendorsList.length,
          //       itemBuilder: (BuildContext context, int index) {
          //         return GestureDetector(
          //           onTap: () {
          //             getSelectedVendorId = vendorsList[index].vendorId;
          //             getSelectedVendorName = vendorsList[index].name;
          //             Navigator.of(context).push(MaterialPageRoute(
          //                 builder: (_) => BlocProvider.value(
          //                     value: BlocProvider.of<FirebaseBloc>(context),
          //                     child: CategoryList())));
          //           },
          //           child: Container(
          //             decoration: BoxDecoration(
          //                 border: Border.all(
          //                   color: Colors.red[500],
          //                 ),
          //                 borderRadius: BorderRadius.all(Radius.circular(6))),
          //             child: Image.network(
          //               vendorsList[index].icon,
          //               height: 300,
          //               width: 300,
          //               fit: BoxFit.fill,
          //             ),
          //           ),
          //         );
          //       },
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
