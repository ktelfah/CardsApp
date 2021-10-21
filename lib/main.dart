import 'package:cards_app/bloc/cards_bloc.dart';
import 'package:cards_app/repository/cards_api.dart';
import 'package:cards_app/repository/cards_repository.dart';
import 'package:cards_app/screens/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
  var customerPasswordEncrypted;
  String decryptedS;
  await Firebase.initializeApp();
  final FirebaseRepository repository = FirebaseRepository(
    firebaseApiClient: FirebaseApiClient(
      httpClient: http.Client(),
    ),
  );
  SharedPreferences pref = await SharedPreferences.getInstance();
  var email = pref.getString('email');
  // decryptedS = await cryptor.decrypt(
  //     '4+8pWumiFOeCbv9YZP5XDQ==:XusSxwObdx7UYJn/uVyTp3OdHKn1nzw8xu1VI7P6qLc=:kGllWDFMCcO1zzoLOerXPw==',
  //     "5621seeF+hm7eBsv6eDl2g==:VQP0A2rHM4F7aafVngOq5fL950nC1F6ElNPUP9lUTnY=");
  runApp(MyApp(
    repository: repository,
    email: email,
  ));
}

class MyApp extends StatefulWidget {
  final FirebaseRepository repository;
  final String email;
  const MyApp({Key key, this.repository, this.email}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => FirebaseBloc(repository: widget.repository),
        child: HomePage(email: widget.email),
      ),
    );
  }
}
