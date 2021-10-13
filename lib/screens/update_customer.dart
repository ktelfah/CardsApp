import 'package:cards_app/bloc/cards_bloc.dart';
import 'package:cards_app/bloc/cards_event.dart';
import 'package:cards_app/bloc/cards_state.dart';
import 'package:cards_app/screens/add_admin.dart';
import 'package:cards_app/screens/add_admin_customer_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateCustomers extends StatefulWidget {
  final adminId;
  final customerId;
  final name;
  final balance;
  final password;
  final address;

  const UpdateCustomers(
      {Key key,
      this.adminId,
      this.customerId,
      this.name,
      this.balance,
      this.password,
      this.address})
      : super(key: key);

  @override
  _UpdateCustomersState createState() => _UpdateCustomersState(
      adminId, customerId, name, balance, password, address);
}

class _UpdateCustomersState extends State<UpdateCustomers> {
  final formKey = GlobalKey<FormState>();
  String adminId, customerId, name, password, address;
  int balance;
  String passwordEncrypted;
  String encryptedS;
  var currentCustomerDetail;

  _UpdateCustomersState(this.adminId, this.customerId, this.name, this.balance,
      this.password, this.address);

  @override
  void initState() {
    BlocProvider.of<FirebaseBloc>(context).add(ResetUpdateCustomer());
    super.initState();
  }

  Future Encrypt() async {
    password = password;
    encryptedS = await cryptor.encrypt(password, key);
  }

  @override
  Widget build(BuildContext mainContext) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop();
        BlocProvider.of<FirebaseBloc>(context).add(ResetFetchCustomer());
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFFF2562),
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text("Update Customer"),
        ),
        body:
            BlocBuilder<FirebaseBloc, FirebaseState>(builder: (context, state) {
          print("STATE:$state");
          if (state is CustomerUpdateEmpty) {
            return Container(
              child: body(context),
            );
          }

          if (state is CustomerUpdateError) {
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

          if (state is CustomerUpdateUpdated) {
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

  Widget body(BuildContext mainContext) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(30),
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextFormField(
                keyboardType: TextInputType.text,
                initialValue: name,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.pinkAccent, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey, width: 2.0),
                  ),
                  hintText: "Enter Name",
                  labelText: "Name",
                ),
                onChanged: (val) => name = val,
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                initialValue: balance.toString(),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.pinkAccent, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey, width: 2.0),
                  ),
                  hintText: "Enter Balance",
                  labelText: "Balance",
                ),
                onChanged: (val) => balance = num.parse(val),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                initialValue: address,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.pinkAccent, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey, width: 2.0),
                  ),
                  hintText: "Enter Address",
                  labelText: "Address",
                ),
                onChanged: (val) => address = val,
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                initialValue: password,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.pinkAccent, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey, width: 2.0),
                  ),
                  hintText: "Enter Password",
                  labelText: "Password",
                ),
                onChanged: (val) => password = val,
              ),
              SizedBox(
                height: 40.0,
              ),
              Container(
                child: GestureDetector(
                    onTap: () {
                      update(context);
                    },
                    child: buttonUI()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void update(BuildContext context) async {
    final Form = formKey.currentState;
    await Encrypt().whenComplete(() {
      passwordEncrypted = encryptedS;
    });
    if (Form.validate()) {
      Form.save();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        BlocProvider.of<FirebaseBloc>(context).add(UpdateCustomer(
            customerId, adminId, name, balance, passwordEncrypted, address));
      });
    }
  }

  Widget buttonUI() {
    return Ink(
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            color: Color(0xFFFF2562),
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Center(
          child: Text(
            'UPDATE CUSTOMER',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
          ),
        ),
      ),
    );
  }
}
