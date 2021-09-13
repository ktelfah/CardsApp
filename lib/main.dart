import 'package:cards_app/bloc/cards_bloc.dart';
import 'package:cards_app/bloc/cards_state.dart';
import 'package:cards_app/repository/cards_api.dart';
import 'package:cards_app/repository/cards_repository.dart';
import 'package:cards_app/screens/add_admin_customer_cards.dart';
import 'package:cards_app/screens/card_list.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'bloc/cards_event.dart';
import 'helper/custom_text_form_field.dart';

var getAdminIdUser;

class CardsBlocObserer extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    print(event);
    super.onEvent(bloc, event);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    print(change);
    super.onChange(bloc, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print(transition);
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print(error);
    super.onError(bloc, error, stackTrace);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final FirebaseRepository repository = FirebaseRepository(
    firebaseApiClient: FirebaseApiClient(
      httpClient: http.Client(),
    ),
  );
  runApp(MyApp(
    repository: repository,
  ));
}

class MyApp extends StatefulWidget {
  final FirebaseRepository repository;

  const MyApp({Key key, this.repository}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: BlocProvider(
      create: (context) => FirebaseBloc(repository: widget.repository),
      child: HomePage(),
    ));
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final formKey = GlobalKey<FormState>();
  final userNameNode = FocusNode();
  final passwordNode = FocusNode();
  //String email = "kt\$@sss.com", password = "123";
  //String email = "Zimba", password = "12345";
  String email = "", password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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

        if (state is LoginLoaded) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            print("BOOLEAN VALUE:${isCard}");
            getAdminIdUser = state.admin.adminId;
            if(isCard == false){
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                      value: BlocProvider.of<FirebaseBloc>(context),
                      child: AddAdminCustomerCards())));
            }else{
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                      value: BlocProvider.of<FirebaseBloc>(context),
                      child: CardList())));
            }
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
