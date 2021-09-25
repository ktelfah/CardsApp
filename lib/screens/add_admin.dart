import 'package:cards_app/bloc/cards_bloc.dart';
import 'package:cards_app/bloc/cards_event.dart';
import 'package:cards_app/bloc/cards_state.dart';
import 'package:cards_app/helper/custom_text_form_field.dart';
import 'package:cards_app/screens/add_admin_customer_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_string_encryption/flutter_string_encryption.dart';

var key = "5621seeF+hm7eBsv6eDl2g==:VQP0A2rHM4F7aafVngOq5fL950nC1F6ElNPUP9lUTnY=";
PlatformStringCryptor cryptor = PlatformStringCryptor();


class AddAdmin extends StatefulWidget {
  const AddAdmin({Key key}) : super(key: key);

  @override
  _AddAdminState createState() => _AddAdminState();
}

class _AddAdminState extends State<AddAdmin> {
  final formKey = GlobalKey<FormState>();
  final nameNode = FocusNode();
  final emailNode = FocusNode();
  final passwordNode = FocusNode();
  final phoneNode = FocusNode();
  String email = "", name = "", password = "", phoneNo = "";
  String passwordEncrypted;
  String encryptedS,decryptedS;


  @override
  void initState() {
    BlocProvider.of<FirebaseBloc>(context).add(ResetAddAdmin());
    super.initState();
  }

  Future Encrypt() async {
    password = password;
    encryptedS = await cryptor.encrypt(password, key);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF2562),
        title: Text("Add Admin"),
      ),
      //body: body(context)
      body: BlocBuilder<FirebaseBloc, FirebaseState>(builder: (context, state) {
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
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(
                "Admin Added Successfully",
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
                "Add Admin",
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
            textEditingController: TextEditingController(text: email),
            hintText: 'Useremail',
            icon: Icons.mail,
            onFieldSubmitted: (String value) {},
            cursorColor: Color(0xFFFF2562),
            onChanged: (String value) {
              email = value;
            },
            keyboardType: TextInputType.name,
            focusNode: emailNode,
            nextNode: nameNode,
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
          CustomTextFormField(
            obscureText: false,
            textEditingController: TextEditingController(text: name),
            hintText: 'Username',
            icon: Icons.person,
            onFieldSubmitted: (String value) {},
            cursorColor: Color(0xFFFF2562),
            onChanged: (String value) {
              name = value;
            },
            keyboardType: TextInputType.name,
            focusNode: nameNode,
            nextNode: passwordNode,
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
            nextNode: phoneNode,
            textInputAction: TextInputAction.done,
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please Enter your Password.';
              }
            },
          ),
          SizedBox(
            height: 20,
          ),
          CustomTextFormField(
            obscureText: false,
            textEditingController: TextEditingController(text: phoneNo),
            hintText: 'PhoneNo',
            icon: Icons.phone,
            onFieldSubmitted: (String value) {},
            cursorColor: Color(0xFFFF2562),
            onChanged: (String value) {
              phoneNo = value;
            },
            keyboardType: TextInputType.text,
            focusNode: phoneNode,
            nextNode: phoneNode,
            textInputAction: TextInputAction.done,
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please Enter your PhoneNo.';
              }
            },
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
       await Encrypt().whenComplete(() {
          passwordEncrypted = encryptedS;
        });
       if (formKey.currentState.validate()) {
          formKey.currentState.save();
          BlocProvider.of<FirebaseBloc>(context)
              .add(FetchAddAdmin(email, name, passwordEncrypted, phoneNo, 'false'));
        }
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            color: Color(0xFFFF2562),
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Center(
          child: Text(
            'ADD ADMIN',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
          ),
        ),
      ),
    );
  }
}
