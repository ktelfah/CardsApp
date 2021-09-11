import 'package:cards_app/bloc/cards_event.dart';
import 'package:cards_app/bloc/cards_state.dart';
import 'package:cards_app/models/admin.dart';
import 'package:cards_app/models/cards.dart';
import 'package:cards_app/models/customers.dart';
import 'package:cards_app/repository/cards_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FirebaseBloc extends Bloc<FirebaseEvent, FirebaseState> {
  final FirebaseRepository repository;

  FirebaseBloc({this.repository})
      : assert(repository != null),
        super(LoginEmpty());

  @override
  FirebaseState get initialState => LoginEmpty();

  Stream<FirebaseState> mapEventToState(FirebaseEvent event) async* {
    //LOGIN
    if (event is ResetLogin) {
      yield LoginEmpty();
    }

    if (event is FetchLogin) {
      yield LoginLoading();

      try {
        final Admin admin =
            await repository.fetchLogin(event.email, event.password);
        yield LoginLoaded(admin: admin);
      } catch (e) {
        print(e);
        yield LoginError();
      }
    }

    //Add Admin
    if (event is ResetAddAdmin) {
      yield AddAdminEmpty();
    }

    if (event is FetchAddAdmin) {
      yield AddAdminLoading();

      try {
        final Admin admin = await repository.addAdmin(event.email, event.name,
            event.password, event.phno, event.isSuperAdmin);
        yield AddAdminLoaded(admin: admin);
      } catch (e) {
        print(e);
        yield AddAdminError();
      }
    }

    //Add Card
    if (event is ResetAddCard) {
      yield AddCardEmpty();
    }

    if (event is FetchAddCard) {
      yield AddCardLoading();

      try {
        final Cards card = await repository.addCard(event.adminId, event.cardId,
            event.amount, event.cardNumber, event.cardVender, event.status);
        yield AddCardLoaded(card: card);
      } catch (e) {
        print(e);
        yield AddCardError();
      }
    }

    //Add Customer
    if (event is ResetAddCustomer) {
      yield AddCustomerEmpty();
    }

    if (event is FetchAddCustomer) {
      yield AddCustomerLoading();

      try {
        final Customer customer = await repository.addCustomer(event.customerId,
            event.adminId, event.balance, event.name, event.password);
        yield AddCustomerLoaded(customer: customer);
      } catch (e) {
        print(e);
        yield AddCustomerError();
      }
    }
  }
}
