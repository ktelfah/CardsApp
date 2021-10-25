import 'package:cards_app/bloc/cards_bloc.dart';
import 'package:cards_app/bloc/cards_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({
    Key key,
  }) : super(key: key);

  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final formKey = GlobalKey<FormState>();
  final nameNode = FocusNode();
  final emailNode = FocusNode();
  final passwordNode = FocusNode();
  final phoneNode = FocusNode();
  num amount = 0;
  var categories;
  TextEditingController controller = TextEditingController();
  String cardNumber = "", cardVender = "", status = "NEW";
  var getAdminId;
  List dd = [];
  List ddd = [];
  String venid;
  final firestoreInstance = FirebaseFirestore.instance;

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
    data();
    super.initState();
  }

  void data() {
    setState(() {
      firestoreInstance
          .collection("categories")
          // .where("vendorId", isEqualTo: "fQsKDiB3jJJfRZafZw6w")
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((result) {
          ddd.add(result.get('categoryName'));
          setState(() {});
          print(ddd.length);
        });
      });
    });
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
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.pink,
            child: Icon(Icons.add),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      actions: [
                        TextButton(
                          onPressed: () {
                            BlocProvider.of<FirebaseBloc>(context)
                                .add(FetchAddCategory(
                              controller.text,
                            ));
                            Navigator.pop(context);
                            setState(() {
                              if (ddd.isNotEmpty) {
                                ddd.clear();
                                data();
                              } else {
                                data();
                              }
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              behavior: SnackBarBehavior.floating,
                              content: Text(
                                "Category Added Successfully",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                              backgroundColor: Colors.black,
                            ));
                          },
                          child: Text("Enter"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Cancel"),
                        ),
                      ],
                      content: TextField(
                        onChanged: (value) {
                          categories = value;
                        },
                        controller: controller,
                        decoration: InputDecoration(hintText: "Enter Category"),
                      ),
                    );
                  });
            }),
        appBar: AppBar(
          backgroundColor: Color(0xFFFF2562),
          title: Text("Add Category"),
        ),
        //body: body(context)
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Column(
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: ddd.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(top: 15.0),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(5)),
                          height: 50,
                          child: Center(
                              child: Text(
                            ddd[index],
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          )),
                        );
                      }),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
