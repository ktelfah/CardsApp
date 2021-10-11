import 'package:cards_app/bloc/cards_bloc.dart';
import 'package:cards_app/bloc/cards_event.dart';
import 'package:cards_app/bloc/cards_state.dart';
import 'package:cards_app/helper/custom_text_form_field.dart';
import 'package:cards_app/main.dart';
import 'package:cards_app/screens/add_admin.dart';
import 'package:cards_app/screens/add_admin_customer_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCustomer extends StatefulWidget {
  const AddCustomer({Key key}) : super(key: key);

  @override
  _AddCustomerState createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  final formKey = GlobalKey<FormState>();
  final nameNode = FocusNode();
  final passwordNode = FocusNode();
  final addressNode = FocusNode();
  final balanceNode = FocusNode();
  num balance = 0;
  String name = "", password = "", address = "";
  String passwordEncrypted;
  String encryptedS, decryptedS;

  @override
  void initState() {
    BlocProvider.of<FirebaseBloc>(context).add(ResetAddCustomer());
    super.initState();
  }

  Future Encrypt() async {
    password = password;
    encryptedS = await cryptor.encrypt(password, key);
  }

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
          title: Text("Add Customer"),
        ),
        //body: body(context)
        body:
            BlocBuilder<FirebaseBloc, FirebaseState>(builder: (context, state) {
          print("STATE:$state");
          if (state is AddCustomerEmpty) {
            return Container(
              child: body(context),
            );
          }

          if (state is AddCustomerError) {
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

          if (state is AddCustomerLoaded) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text(
                  "Customer Added Successfully",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: Colors.black,
              ));
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                      value: BlocProvider.of<FirebaseBloc>(context),
                      child: AddAdminCustomerCards())));
            });
          }

          return Center(
            child: CircularProgressIndicator(),
          );

          return Container();
        }),
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
                "Add Customer",
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
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          CustomTextFormField(
            obscureText: false,
            textEditingController: TextEditingController(text: name),
            hintText: 'Name',
            icon: Icons.person,
            onFieldSubmitted: (String value) {},
            cursorColor: Color(0xFFFF2562),
            onChanged: (String value) {
              name = value;
            },
            keyboardType: TextInputType.name,
            focusNode: nameNode,
            nextNode: addressNode,
            textInputAction: TextInputAction.next,
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please Enter customer name';
              }
            },
          ),
          SizedBox(
            height: 20,
          ),
          CustomTextFormField(
            obscureText: false,
            textEditingController: TextEditingController(text: address),
            hintText: 'Address',
            icon: Icons.location_city,
            onFieldSubmitted: (String value) {},
            cursorColor: Color(0xFFFF2562),
            onChanged: (String value) {
              address = value;
            },
            keyboardType: TextInputType.name,
            focusNode: addressNode,
            nextNode: balanceNode,
            textInputAction: TextInputAction.next,
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please Enter customer address';
              }
            },
          ),
          SizedBox(
            height: 20,
          ),
          CustomTextFormField(
            obscureText: false,
            textEditingController:
                TextEditingController(text: balance.toString()),
            hintText: 'Balance',
            icon: Icons.wallet_giftcard,
            onFieldSubmitted: (String value) {},
            cursorColor: Color(0xFFFF2562),
            onChanged: (String value) {
              balance = num.parse(value);
            },
            keyboardType: TextInputType.name,
            focusNode: balanceNode,
            nextNode: passwordNode,
            textInputAction: TextInputAction.next,
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please Enter Balance';
              }
            },
          ),
          SizedBox(
            height: 20,
          ),
          CustomTextFormField(
            obscureText: true,
            textEditingController: TextEditingController(text: password),
            hintText: 'Password',
            icon: Icons.lock,
            onFieldSubmitted: (String value) {},
            cursorColor: Color(0xFFFF2562),
            onChanged: (String value) {
              password = value;
            },
            keyboardType: TextInputType.text,
            focusNode: passwordNode,
            nextNode: passwordNode,
            textInputAction: TextInputAction.done,
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please Enter Password.';
              }
            },
          ),
          SizedBox(
            height: 70,
          ),
          addCustomerButton(context),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget addCustomerButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Encrypt().whenComplete(() {
          passwordEncrypted = encryptedS;
        });
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
          BlocProvider.of<FirebaseBloc>(context).add(FetchAddCustomer(
              '', getAdminIdUser, balance, name, address, passwordEncrypted));
        }
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            color: Color(0xFFFF2562),
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Center(
          child: Text(
            'ADD CUSTOMER',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
          ),
        ),
      ),
    );
  }
}
