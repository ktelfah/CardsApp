import 'package:cards_app/bloc/cards_bloc.dart';
import 'package:cards_app/bloc/cards_event.dart';
import 'package:cards_app/bloc/cards_state.dart';
import 'package:cards_app/helper/custom_text_form_field.dart';
import 'package:cards_app/main.dart';
import 'package:cards_app/models/vendors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCard extends StatefulWidget {
  final adminIdget;

  const AddCard({Key key, this.adminIdget}) : super(key: key);

  @override
  _AddCardState createState() => _AddCardState(adminIdget);
}

class _AddCardState extends State<AddCard> {
  final adminIdget;
  final formKey = GlobalKey<FormState>();
  final nameNode = FocusNode();
  final emailNode = FocusNode();
  // final passwordNode = FocusNode();
  final phoneNode = FocusNode();
  num amount = 0;
  String cardNumber = "", cardVender = "Apple", status = "NEW";
  String category = "Internet";
  String subcategory = "Internet";
  // String value;
  var getAdminId;
  List dd = [];
  List ddd = [];
  List subcategorylist = [];
  List select = [];
  String venid;
  String categoryId;
  String subcatid;
  List<String> data = ['SelectCategory'];
  final firestoreInstance = FirebaseFirestore.instance;

  _AddCardState(this.adminIdget);

  @override
  void initState() {
    BlocProvider.of<FirebaseBloc>(context).add(ResetAddCard());
    firestoreInstance.collection("vendors").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        dd.add(result.get('name'));
        setState(() {});
        print(dd);
      });
    });
    setState(() {
      firestoreInstance.collection("categories").get().then((querySnapshot) {
        querySnapshot.docs.forEach((result) {
          ddd.add(result.get('categoryName'));
          setState(() {});
          print(ddd);
        });
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        Navigator.of(context).pop();
        BlocProvider.of<FirebaseBloc>(context).add(ResetFetchCustomer());
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFFF2562),
          title: Text("Add Card"),
        ),
        //body: body(context)
        body: BlocBuilder<FirebaseBloc, FirebaseState>(
          builder: (context, state) {
            print("STATE:$state");

            if (state is FetchVendorsEmpty) {
              BlocProvider.of<FirebaseBloc>(context).add(FetchVendors());
            }

            if (state is FetchVendorsLoaded) {
              var vendorsList = state.vendors;
              return body(vendorsList: vendorsList);
            }

            if (state is AddCardEmpty) {
              return Container(
                child: body(context: context),
              );
            }

            if (state is AddCardError) {
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
              return Container(
                child: body(context: context),
              );
            }

            if (state is AddCardLoaded) {
              WidgetsBinding.instance.addPostFrameCallback(
                (_) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: Text(
                      "Card Added Successfully",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Colors.black,
                  ));

                  Navigator.of(context).pop();
                  BlocProvider.of<FirebaseBloc>(context)
                      .add(ResetFetchCustomer());
                },
              );
            }

            return Center(
              child: CircularProgressIndicator(),
            );

            return Container();
          },
        ),
      ),
    );
  }

  Widget body({BuildContext context, List<Vendors> vendorsList}) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Column(
            children: [
              const SizedBox(height: 40.0),
              Text(
                "Add Card",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20.0),
              form(context, vendorsList),
              const SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  form(BuildContext context, List<Vendors> vendorsList) {
    return Column(
      children: [
        Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              CustomTextFormField(
                obscureText: false,
                textEditingController: TextEditingController(text: cardNumber),
                hintText: 'CardNumber',
                icon: Icons.person,
                onFieldSubmitted: (String value) {},
                cursorColor: Color(0xFFFF2562),
                onChanged: (String value) {
                  cardNumber = value;
                },
                keyboardType: TextInputType.name,
                focusNode: nameNode,
                // nextNode: passwordNode,
                textInputAction: TextInputAction.next,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please Enter your CardNumber';
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              CustomTextFormField(
                obscureText: false,
                textEditingController:
                    TextEditingController(text: amount.toString()),
                hintText: 'Amount',
                icon: Icons.monetization_on,
                onFieldSubmitted: (String value) {},
                cursorColor: Color(0xFFFF2562),
                onChanged: (value) {
                  amount = num.parse(value);
                },
                keyboardType: TextInputType.number,
                focusNode: emailNode,
                nextNode: nameNode,
                textInputAction: TextInputAction.next,
                // ignore: missing_return
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please Enter your amount';
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              DropdownButtonFormField(
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.person,
                    size: 20,
                  ),
                  hintText: "Vendor",
                ),
                // focusNode: passwordNode,
                onChanged: (value) {
                  setState(() {
                    cardVender = value;
                  });
                  print(dd.length);
                },
                value: cardVender,
                items: dd.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
              ),
              SizedBox(
                height: 20,
              ),
              DropdownButtonFormField(
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.person,
                    size: 20,
                  ),
                  hintText: "Category",
                ),
                // focusNode: passwordNode,
                items: ddd.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    category = value;
                    firestoreInstance
                        .collection("categories")
                        .where("categoryName", isEqualTo: category)
                        .get()
                        .then((querySnapshot) {
                      querySnapshot.docs.forEach((result) {
                        categoryId = result.get('categoryID');
                      });
                    }).then((value) {
                      firestoreInstance
                          .collection("subCategories")
                          .where("categoryId", isEqualTo: categoryId)
                          .get()
                          .then((querySnapshot) {
                        if (subcategorylist.isNotEmpty) {
                          subcategorylist.clear();
                          querySnapshot.docs.forEach((result) {
                            subcategorylist.add(result.get('name'));
                          });
                          setState(() {});
                        } else {
                          querySnapshot.docs.forEach((result) {
                            subcategorylist.add(result.get('name'));
                          });
                          setState(() {});
                        }
                      });
                    });
                    print('Sub Cat ====== ${subcategorylist}');
                  });
                  setState(() {});
                },
                value: ddd[0],
              ),
              SizedBox(
                height: 20,
              ),
              //
              subcategorylist.isNotEmpty
                  ? DropdownButtonFormField(
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.person,
                          size: 20,
                        ),
                        hintText: "SubCategory",
                      ),
                      //  focusNode: passwordNode,
                      items: subcategorylist.map((val) {
                        return DropdownMenuItem(
                          value: val,
                          child: Text(val),
                        );
                      }).toList(growable: true),
                      onChanged: (value) {
                        setState(() {
                          subcategory = value;
                          print('SELECTED D2 ONCHANGE==$subcategory');
                          print('SELECTED D2 ONCHANGE==$value');
                          firestoreInstance
                              .collection("subCategories")
                              .where("name", isEqualTo: subcategory)
                              .get()
                              .then((value) {
                            value.docs.forEach((element) {
                              subcatid = element.get("uniqid");
                            });
                          });
                        });
                      },
                      value: subcategorylist[0],
                    )
                  : Container(),
              SizedBox(
                height: 70,
              ),
              addAdminButton(context),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget addAdminButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        DateTime i = DateTime.now();
        var t = Timestamp.fromDate(i);
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
          BlocProvider.of<FirebaseBloc>(context).add(FetchAddCard(
            getAdminIdUser,
            '',
            amount,
            cardNumber,
            cardVender,
            category,
            subcatid,
            'NEW',
            t,
          ));
        }
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            color: Color(0xFFFF2562),
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Center(
          child: Text(
            'ADD CARD',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
          ),
        ),
      ),
    );
  }
}
