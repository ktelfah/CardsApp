import 'package:cards_app/bloc/cards_bloc.dart';
import 'package:cards_app/bloc/cards_event.dart';
import 'package:cards_app/bloc/cards_state.dart';
import 'package:cards_app/models/vendors.dart';
import 'package:cards_app/repository/cards_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'category_list.dart';

var getSelectedVendorId;
var getSelectedVendorName;

class VendorList extends StatefulWidget {
  const VendorList({Key key}) : super(key: key);

  @override
  _VendorListState createState() => _VendorListState();
}

class _VendorListState extends State<VendorList> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<FirebaseBloc>(context).add(ResetFetchVendors());
  }

  @override
  Widget build(BuildContext context) {
    print("name$customerNameGet");
    print("name$customerAmountGet");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF2562),
        automaticallyImplyLeading: true,
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
          SizedBox(
            height: 20,
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 6.0,
                    mainAxisSpacing: 6.0),
                itemCount: vendorsList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      getSelectedVendorId = vendorsList[index].vendorId;
                      getSelectedVendorName = vendorsList[index].name;
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                              value: BlocProvider.of<FirebaseBloc>(context),
                              child: CategoryList())));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.red[500],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                      child: Image.network(
                        vendorsList[index].icon,
                        height: 300,
                        width: 300,
                        fit: BoxFit.fill,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
