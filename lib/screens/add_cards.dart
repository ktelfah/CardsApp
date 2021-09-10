import 'package:cards_app/bloc/cards_bloc.dart';
import 'package:cards_app/bloc/cards_event.dart';
import 'package:cards_app/bloc/cards_state.dart';
import 'package:cards_app/helper/custom_text_form_field.dart';
import 'package:cards_app/screens/add_admin_customer_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCard extends StatefulWidget {
  const AddCard({Key? key}) : super(key: key);

  @override
  _AddCardState createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  final formKey = GlobalKey<FormState>();
  final nameNode = FocusNode();
  final emailNode = FocusNode();
  final passwordNode = FocusNode();
  final phoneNode = FocusNode();
  String amount = "", cardNumber = "", cardVender = "", status = "";

  @override
  void initState() {
    BlocProvider.of<FirebaseBloc>(context)
        .add(ResetAddCard());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF2562),
        title: Text("Add Card"),
      ),
      //body: body(context)
      body: BlocBuilder<FirebaseBloc, FirebaseState>(builder: (context, state) {
        print("STATE:$state");
        if (state is AddCardEmpty) {
          return Container(
            child: body(context),
          );
        }

        if (state is AddCardError) {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                "Invalid User",
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

        if (state is AddCardLoaded) {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                    value: BlocProvider.of<FirebaseBloc>(context),
                    child: AddAdminCustomerCards(
                    )))
            );
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
                "Add Card",
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
            textEditingController: TextEditingController(),
            hintText: 'Amount',
            icon: Icons.monetization_on,
            onFieldSubmitted: (String value) {},
            cursorColor: Color(0xFFFF2562),
            onChanged: (String value) {
              amount = value;
            },
            keyboardType: TextInputType.name,
            focusNode: emailNode,
            nextNode: nameNode,
            textInputAction: TextInputAction.next,
            validator: (String? value) {
              if (value!.isEmpty) {
                return 'Please Enter your amount';
              }
            },
          ),
          SizedBox(
            height: 20,
          ),
          CustomTextFormField(
            obscureText: false,
            textEditingController: TextEditingController(),
            hintText: 'CardNumber',
            icon: Icons.person,
            onFieldSubmitted: (String value) {},
            cursorColor: Color(0xFFFF2562),
            onChanged: (String value) {
              cardNumber = value;
            },
            keyboardType: TextInputType.name,
            focusNode: nameNode,
            nextNode: passwordNode,
            textInputAction: TextInputAction.next,
            validator: (String? value) {
              if (value!.isEmpty) {
                return 'Please Enter your CardNumber';
              }
            },
          ),
          SizedBox(
            height: 20,
          ),
          CustomTextFormField(
            obscureText: false,
            textEditingController: TextEditingController(),
            hintText: 'CardVender',
            icon: Icons.person,
            onFieldSubmitted: (String value) {

            },
            cursorColor: Color(0xFFFF2562),
            onChanged: (String value) {
              cardVender = value;
            },
            keyboardType: TextInputType.text,
            focusNode: passwordNode,
            nextNode: phoneNode,
            textInputAction: TextInputAction.done,
            validator: (String? value) {
              if (value!.isEmpty) {
                return 'Please Enter your CardVender.';
              }
            },
          ),
          SizedBox(
            height: 20,
          ),
          CustomTextFormField(
            obscureText: false,
            textEditingController: TextEditingController(),
            hintText: 'Status',
            icon: Icons.stacked_bar_chart,
            onFieldSubmitted: (String value) {},
            cursorColor: Color(0xFFFF2562),
            onChanged: (String value) {
              status = value;
            },
            keyboardType: TextInputType.text,
            focusNode: phoneNode,
            nextNode: phoneNode,
            textInputAction: TextInputAction.done,
            validator: (String? value) {
              if (value!.isEmpty) {
                return 'Please Enter your Status.';
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
      onTap: () {
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
          BlocProvider.of<FirebaseBloc>(context)
              .add(FetchAddCard('', '', amount, cardNumber, cardVender, status));

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
