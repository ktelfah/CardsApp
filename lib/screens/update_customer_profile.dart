import 'package:cards_app/bloc/cards_bloc.dart';
import 'package:cards_app/bloc/cards_event.dart';
import 'package:cards_app/bloc/cards_state.dart';
import 'package:cards_app/helper/pages.dart';
import 'package:cards_app/main.dart';
import 'package:cards_app/repository/cards_api.dart';
import 'package:cards_app/repository/cards_repository.dart';
import 'package:cards_app/screens/add_admin.dart';
import 'package:cards_app/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class UpdateCustomerProfile extends StatefulWidget {
  final adminId;
  final customerId;
  final name;
  final password;
  final address;

  const UpdateCustomerProfile(
      {Key key,
      this.adminId,
      this.customerId,
      this.name,
      this.password,
      this.address})
      : super(key: key);

  @override
  _UpdateCustomerProfileState createState() =>
      _UpdateCustomerProfileState(adminId, customerId, name, password, address);
}

class _UpdateCustomerProfileState extends State<UpdateCustomerProfile> {
  final formKey = GlobalKey<FormState>();
  String adminId, customerId, name, password, address;
  String oldPassword;
  String newPassword;
  String confirmPassword;
  String passwordEncrypted;
  String encryptedS;

  _UpdateCustomerProfileState(
      this.adminId, this.customerId, this.name, this.password, this.address);

  @override
  void initState() {
    name = customerNameGet;
    address = customerAddressGet;
    passwordEncrypted = customerPasswordGet;
    BlocProvider.of<FirebaseBloc>(context).add(ResetUpdateCustomer());
    super.initState();
  }

  Future Encrypt() async {
    print(password);
    password = customerPasswordGet;
    encryptedS = await cryptor.encrypt(confirmPassword, key);
    print(encryptedS);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      actions: [
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                              final FirebaseRepository repository =
                                  FirebaseRepository(
                                firebaseApiClient: FirebaseApiClient(
                                  httpClient: http.Client(),
                                ),
                              );
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => MyApp(
                                        repository: repository,
                                      )));
                            },
                            child: Text("Ok"))
                      ],
                    );
                  });
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                      value: BlocProvider.of<FirebaseBloc>(context),
                      child: HomePage())));
            },
            icon: Icon(Icons.logout),
          )
        ],
        backgroundColor: Color(0xFFFF2562),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text("Profile"),
      ),
      body: BlocBuilder<FirebaseBloc, FirebaseState>(builder: (context, state) {
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
            customerNameGet = name;
            customerAddressGet = address;
            customerPasswordGet = passwordEncrypted;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(
                "Customer Profile Updated Successfully",
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
                    child: Pages())));
          });
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      }),
      //body(context),
    );
  }

  Widget body(BuildContext context) {
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
              SizedBox(
                height: 40.0,
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                initialValue: customerNameGet,
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
                initialValue: customerAddressGet,
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
                initialValue: "",
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.pinkAccent, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey, width: 2.0),
                  ),
                  hintText: "Enter OldPassword",
                  labelText: "OldPassword",
                ),
                onChanged: (val) => password = val,
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                initialValue: "",
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.pinkAccent, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey, width: 2.0),
                  ),
                  hintText: "Enter NewPassword",
                  labelText: "NewPassword",
                ),
                onChanged: (val) => newPassword = val,
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                initialValue: "",
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.pinkAccent, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey, width: 2.0),
                  ),
                  hintText: "Enter ConfirmPassword",
                  labelText: "ConfirmPassword",
                ),
                onChanged: (val) => confirmPassword = val,
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

    if (newPassword == confirmPassword) {
      if (customerPasswordGet == password) {
        await Encrypt().whenComplete(() {
          passwordEncrypted = encryptedS;
        });
        if (Form.validate()) {
          Form.save();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            BlocProvider.of<FirebaseBloc>(context).add(UpdateCustomer(
                customerIdGet,
                customerAdminIdGet,
                name,
                customerAmountGet,
                passwordEncrypted,
                address));
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            "Please enter your correct old password",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.black,
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          "Please Confirm your NewPassword and ConfirmPassword",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ));
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
            'UPDATE CUSTOMER PROFILE',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
          ),
        ),
      ),
    );
  }
}
