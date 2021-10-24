import 'package:cards_app/bloc/cards_bloc.dart';
import 'package:cards_app/bloc/cards_event.dart';
import 'package:cards_app/bloc/cards_state.dart';
import 'package:cards_app/helper/custom_text_form_field.dart';
import 'package:cards_app/helper/pages.dart';
import 'package:cards_app/main.dart';
import 'package:cards_app/repository/cards_api.dart';
import 'package:cards_app/screens/add_admin_customer_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key, this.email}) : super(key: key);
  final String email;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final formKey = GlobalKey<FormState>();
  final userNameNode = FocusNode();
  final passwordNode = FocusNode();

  ///Test User Credentials
  // String email = "kt\$@sss.com", password = "open";
  // String email = "TitiTangi", password = "open";
  // String email = "miral@gmail.com", password = "123";
  String email = "priyal@gmail.com", password = "open";
  // String email = "", password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFFF2562),
        title: Center(child: Text("Cards App")),
      ),
      // body: body(context)
      body: BlocBuilder<FirebaseBloc, FirebaseState>(builder: (context, state) {
        print("STATE:$state");
        if (state is LoginEmpty) {
          return Container(
            child: body(context),
          );
        }

        if (state is LoginError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Invalid User",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      height: 3.0,
                      fontSize: 20),
                ),
                backgroundColor: Colors.red,
              ),
            );
          });
          return Container(
            child: body(context),
          );
        }

        if (state is LoginLoaded) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            getAdminIdUser = adminIdGet;
            if (isCard == "SuperAdmin") {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                      value: BlocProvider.of<FirebaseBloc>(context),
                      child: AddAdminCustomerCards(
                        isSuperAdmin: true,
                      ))));
            } else if (isCard == "NormalAdmin") {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                      value: BlocProvider.of<FirebaseBloc>(context),
                      child: AddAdminCustomerCards(
                        isSuperAdmin: false,
                      ))));
            } else {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                      value: BlocProvider.of<FirebaseBloc>(context),
                      child: Pages())));
            }
          });
        }
        return Center(
          child: CircularProgressIndicator(),
        );
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
              logo(),
              const SizedBox(height: 80.0),
              Text(
                "Sign In",
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

  Row logo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(height: 40.0),
        Container(
            height: 100.0,
            child: Image.asset(
              'assets/demo_logo.png',
            )),
      ],
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
            hintText: 'Username',
            icon: Icons.person,
            onFieldSubmitted: (String value) {},
            cursorColor: Color(0xFFFF2562),
            onChanged: (String value) {
              email = value;
            },
            keyboardType: TextInputType.name,
            focusNode: userNameNode,
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
            nextNode: passwordNode,
            textInputAction: TextInputAction.done,
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please Enter your Password.';
              }
            },
          ),
          SizedBox(
            height: 70,
          ),
          signInButton(context),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget signInButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        print("********************${getAdminIdUser}");
        print("Press Login");
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
          BlocProvider.of<FirebaseBloc>(context)
              .add(FetchLogin(email, password));
        }
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            color: Color(0xFFFF2562),
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Center(
          child: Text(
            'SIGN IN',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
          ),
        ),
      ),
    );
  }
}
