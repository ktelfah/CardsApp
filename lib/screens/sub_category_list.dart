import 'package:cards_app/bloc/cards_bloc.dart';
import 'package:cards_app/bloc/cards_event.dart';
import 'package:cards_app/bloc/cards_state.dart';
import 'package:cards_app/models/subCategory.dart';
import 'package:cards_app/screens/cart_list.dart';
import 'package:cards_app/screens/mainscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubCategoryList extends StatefulWidget {
  final String selectedCategory;
  SubCategoryList({Key key, this.selectedCategory}) : super(key: key);

  @override
  _SubCategoryListState createState() => _SubCategoryListState();
}

class _SubCategoryListState extends State<SubCategoryList> {
  final firestoreInstance = FirebaseFirestore.instance;
  var vendorname;
  List subCategory = [];
  List<Map> data = [];

  void initState() {
    getsubcategories();
    super.initState();
    BlocProvider.of<FirebaseBloc>(context).add(ResetFetchSubCategory());
  }

  bool isload = false;
  Future<void> getsubcategories() async {
    setState(() {
      isload = true;
    });
    await firestoreInstance
        .collection("vendors")
        .where("vendorId", isEqualTo: getSelectedVendorId)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((element) {
        vendorname = element.get("name");
        // print("vendorname ========================== ${vendorname}");
      });
    }).then((value) async {
      await firestoreInstance
          .collection("cards")
          .where("cardVender", isEqualTo: vendorname)
          .where("category", isEqualTo: widget.selectedCategory)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          subCategory.add(element.get("subCategory"));
          // print("subcategory ========================== ${subCategory}");
        });
      }).then((value) async {
        // print("subcategory ========================== ${subCategory}");
        List.generate(subCategory.length, (index) async {
          await firestoreInstance
              .collection("subCategories")
              .where("uniqid", isEqualTo: subCategory[index])
              .get()
              .then((value) {
            value.docs.forEach((element) {
              data.add(element.data());
              // print("======== DATA ==== ${data}");
            });
          });
        });
        setState(() {
          isload = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        BlocProvider.of<FirebaseBloc>(context).add(ResetFetchCategory());
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFFF2562),
          // automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text("Select Data Pack"),
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
                BlocProvider.of<FirebaseBloc>(context)
                    .add(ResetFetchCategory());
              },
              child: Icon(Icons.arrow_back)),
        ),
        body: isload == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : BlocBuilder<FirebaseBloc, FirebaseState>(
                builder: (context, state) {
                  if (state is FetchSubCategoryEmpty) {
                    BlocProvider.of<FirebaseBloc>(context)
                        .add(FetchSubCategory());
                  }

                  if (state is FetchSubCategoryError) {
                    return Center(
                      child: Text("Failed to fetch data"),
                    );
                  }

                  if (state is FetchSubCategoryLoaded) {
                    var subCategoryList = state.subCategory;
                    return body(subCategoryList);
                  }

                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
      ),
    );
  }

  Widget body(List<SubCategory> subCategoryList) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
        child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: BlocProvider.of<FirebaseBloc>(context),
                        child: CartList(
                          price: data[index]['price'],
                          vendor: data[index]['name'],
                          plan: data[index]['name'],
                          quantity: data[index]['quantity'],
                          uniqid: data[index]['uniqid'],
                        ),
                      ),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 6,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.yellow,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: 60,
                            //width: MediaQuery.of(context).size.width - 130,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                data == null
                                    ? CircularProgressIndicator()
                                    : Text('${data[index]['name']}'),
                                Text('${data[index]['price']}',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            //width: MediaQuery.of(context).size.width - 700,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
