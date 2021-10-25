import 'package:cards_app/bloc/cards_bloc.dart';
import 'package:cards_app/bloc/cards_event.dart';
import 'package:cards_app/bloc/cards_state.dart';
import 'package:cards_app/helper/custom_text_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// var key =
//     "5621seeF+hm7eBsv6eDl2g==:VQP0A2rHM4F7aafVngOq5fL950nC1F6ElNPUP9lUTnY=";
// PlatformStringCryptor cryptor = PlatformStringCryptor();

class AddSubCategory extends StatefulWidget {
  // const AddSubCategory({Key key}) : super(key: key);

  @override
  _AddSubCategoryState createState() => _AddSubCategoryState();
}

class _AddSubCategoryState extends State<AddSubCategory> {
  final formKey = GlobalKey<FormState>();
  final priceNode = FocusNode();
  final nameNode = FocusNode();
  final quantityNode = FocusNode();
  final descriptionNode = FocusNode();
  String name = "", price = "", quantity = "", description = "", category = "";
  String cat;
  List ddd = [];
  // String passwordEncrypted;
  // String encryptedS, decryptedS;

  final firestoreInstance = FirebaseFirestore.instance;
  @override
  void initState() {
    BlocProvider.of<FirebaseBloc>(context).add(ResetAddAdmin());
    super.initState();
    setState(() {
      firestoreInstance.collection("categories").get().then((querySnapshot) {
        querySnapshot.docs.forEach((result) {
          ddd.add(result.get('categoryName'));
          setState(() {});
          print(ddd);
        });
      });
    });
  }

  // Future Encrypt() async {
  //   password = password;
  //   encryptedS = await cryptor.encrypt(password, key);
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop();
        BlocProvider.of<FirebaseBloc>(context).add(ResetFetchCustomer());
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFFF2562),
          title: Text("Add Sub-Category"),
        ),
        //body: body(context)
        body: BlocBuilder<FirebaseBloc, FirebaseState>(
          builder: (context, state) {
            print("STATE:$state");
            if (state is AddAdminEmpty) {
              return Container(
                child: body(context),
              );
            }

            if (state is AddAdminError) {
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
                child: body(context),
              );
            }

            if (state is AddAdminLoaded) {
              WidgetsBinding.instance.addPostFrameCallback(
                (_) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: Text(
                      "SubCategory Added Successfully",
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
          },
        ),
      ),
    );
  }

  Widget body(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Column(
            children: [
              const SizedBox(height: 40.0),
              Text(
                "Add SubCategory",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20.0),
              form(context),
              const SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Form form(BuildContext context) {
    var value;
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          // ========================================================== NAME ===============================//
          CustomTextFormField(
            obscureText: false,
            textEditingController: TextEditingController(text: name),
            hintText: 'Name',
            icon: Icons.drive_file_rename_outline,
            onFieldSubmitted: (String value) {},
            cursorColor: Color(0xFFFF2562),
            onChanged: (String value) {
              name = value;
            },
            keyboardType: TextInputType.name,
            focusNode: nameNode,
            nextNode: priceNode,
            textInputAction: TextInputAction.next,
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please Enter your usermail';
              }
            },
          ),
          SizedBox(
            height: 20,
          ),
          // ========================================================== PRICE ===============================//
          CustomTextFormField(
            obscureText: false,
            textEditingController: TextEditingController(text: price),
            hintText: 'Price',
            icon: Icons.money,
            onFieldSubmitted: (String value) {},
            cursorColor: Color(0xFFFF2562),
            onChanged: (String value) {
              price = value;
            },
            keyboardType: TextInputType.name,
            focusNode: priceNode,
            nextNode: quantityNode,
            textInputAction: TextInputAction.next,
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please Enter your username';
              }
            },
          ),
          SizedBox(
            height: 20,
          ),
          // ========================================================== QUANTITY ===============================//
          CustomTextFormField(
            obscureText: false,
            textEditingController: TextEditingController(text: quantity),
            hintText: 'Quantity',
            icon: Icons.production_quantity_limits,
            onFieldSubmitted: (String value) {},
            cursorColor: Color(0xFFFF2562),
            onChanged: (String value) {
              quantity = value;
            },
            keyboardType: TextInputType.number,
            focusNode: quantityNode,
            nextNode: descriptionNode,
            textInputAction: TextInputAction.done,
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please Enter Quantity.';
              }
            },
          ),
          SizedBox(
            height: 20,
          ),
          // ========================================================== DESCRIPTION ===============================//
          CustomTextFormField(
            obscureText: false,
            textEditingController: TextEditingController(text: description),
            hintText: 'Description',
            icon: Icons.description_outlined,
            onFieldSubmitted: (String value) {},
            cursorColor: Color(0xFFFF2562),
            onChanged: (String value) {
              description = value;
            },
            keyboardType: TextInputType.text,
            focusNode: descriptionNode,
            nextNode: descriptionNode,
            textInputAction: TextInputAction.done,
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please Enter Description.';
              }
            },
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
            onChanged: (value) {
              setState(() {
                category = value;
                print("==$category==");
                firestoreInstance
                    .collection("categories")
                    .where("categoryName", isEqualTo: category)
                    .get()
                    .then((querySnapshot) {
                  querySnapshot.docs.forEach((result) {
                    cat = result.get('categoryID');
                    print("========$cat========");
                  });
                });
              });
              print(ddd.length);
            },
            value: value,
            items: ddd.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text(category),
              );
            }).toList(),
            // List.generate(
            //     dd.length,
            //     (index) => DropdownMenuItem(
            //           value: dd[index],
            //           child: Text(dd[index]),
            //         )),
          ),
          SizedBox(
            height: 70,
          ),
          addAdminButton(context),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget addAdminButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // await Encrypt().whenComplete(() {
        //   passwordEncrypted = encryptedS;
        // });

        if (formKey.currentState.validate()) {
          formKey.currentState.save();
          BlocProvider.of<FirebaseBloc>(context).add(FetchAddSubCategory(
            cat,
            name,
            price,
            quantity,
            description,
          ));
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(
              "Sub-Category Added Successfully",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.black,
          ));
          Navigator.pop(context);
          BlocProvider.of<FirebaseBloc>(context).add(ResetFetchCustomer());
        }
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            color: Color(0xFFFF2562),
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Center(
          child: Text(
            'ADD SUBCATEGORY',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
          ),
        ),
      ),
    );
  }
}
