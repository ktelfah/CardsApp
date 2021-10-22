import 'package:cards_app/bloc/cards_event.dart';
import 'package:cards_app/bloc/cards_state.dart';
import 'package:cards_app/models/admin.dart';
import 'package:cards_app/models/cards.dart';
import 'package:cards_app/models/categories.dart';
import 'package:cards_app/models/customers.dart';
import 'package:cards_app/models/orders.dart';
import 'package:cards_app/models/subCategory.dart';
import 'package:cards_app/models/vendors.dart';
import 'package:cards_app/repository/cards_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString('email', event.email);
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
        final Customer customer = await repository.addCustomer(
            event.customerId,
            event.adminId,
            event.balance,
            event.name,
            event.address,
            event.password);
        yield AddCustomerLoaded(customer: customer);
      } catch (e) {
        print(e);
        yield AddCustomerError();
      }
    }
//==============================================================================//
    //Add SubCategory

    if (event is ResetAddSubCategory) {
      yield AddSubCategoryEmpty();
    }

    if (event is FetchAddSubCategory) {
      yield AddSubCategoryLoading();

      try {
        final SubCategory subCategory = await repository.addSubCategory(
          event.categoryId,
          event.name,
          event.price,
          event.quantity,
          event.description,
        );
        yield AddSubCategoryLoaded(subCategory: subCategory);
      } catch (e) {
        print(e);
        yield AddSubCategoryError();
      }
    }
//===============================================================================//
    //Add Category
    if (event is ResetAddCategory) {
      yield AddCategoryEmpty();
    }

    if (event is FetchAddCategory) {
      yield AddCategoryLoading();

      try {
        final Category category = await repository.addCategory(
          event.categoryName,
        );
        yield AddCategoryLoaded(category: category);
      } catch (e) {
        print(e);
        yield AddCategoryError();
      }
    }
//================================================================================//
    //Fetch Cards
    if (event is ResetFetchCards) {
      yield FetchCardEmpty();
    }

    if (event is FetchCards) {
      yield FetchCardLoading();

      try {
        final List<Cards> cards = await repository.fetchCards();
        yield FetchCardLoaded(cards: cards);
      } catch (e) {
        print(e);
        yield FetchCardError();
      }
    }

    //Add Oredrs
    if (event is ResetAddOrders) {
      yield AddOrdersEmpty();
    }

    if (event is FetchAddOrders) {
      yield AddOrdersLoading();

      try {
        final Orders orders = await repository.addOrders(event.cardId,
            event.customerId, event.orderId, event.transactionDate);
        yield AddOrdersLoaded(orders: orders);
      } catch (e) {
        print(e);
        yield AddOrdersError();
      }
    }

    //Fetch OrdersList
    if (event is ResetFetchOrdersList) {
      yield FetchOrdersListEmpty();
    }

    if (event is FetchOrdersList) {
      yield FetchOrdersListLoading();

      try {
        final List<Cards> cards = await repository.fetchOrdersList();
        yield FetchOrdersListLoaded(cards: cards);
      } catch (e) {
        print(e);
        yield FetchOrdersListError();
      }
    }

    //Fetch OrdersList By Orders
    if (event is ResetFetchOrdersListByOrders) {
      yield FetchOrdersListByOrdersEmpty();
    }

    if (event is FetchOrdersListByOrders) {
      yield FetchOrdersListByOrdersLoading();

      try {
        final List<Orders> orders = await repository.fetchOrdersListByOrder();
        yield FetchOrdersListByOrdersLoaded(orders: orders);
      } catch (e) {
        print(e);
        yield FetchOrdersListByOrdersError();
      }
    }

    //Add Vendor
    if (event is ResetAddVendor) {
      yield AddVendorEmpty();
    }

    if (event is FetchAddVendor) {
      yield AddVendorLoading();

      try {
        final Vendors vendors = await repository.addVendor(
          event.vendorId,
          event.adminId,
          event.name,
          event.icon,
          event.address1,
          event.address2,
          event.zipcode,
          event.county,
          event.type,
        );
        yield AddVendorLoaded(vendors: vendors);
      } catch (e) {
        print(e);
        yield AddVendorError();
      }
    }

    //Fetch Customer
    if (event is ResetFetchCustomer) {
      yield FetchCustomerEmpty();
    }

    if (event is FetchCustomer) {
      yield FetchCustomerLoading();

      try {
        final List<Customer> customer = await repository.fetchCustomer();
        yield FetchCustomerLoaded(customer: customer);
      } catch (e) {
        print(e);
        yield FetchCustomerError();
      }
    }

//Customer Updated
    if (event is ResetUpdateCustomer) {
      yield CustomerUpdateEmpty();
    }
    if (event is UpdateCustomer) {
      yield CustomerUpdateLoading();
      try {
        final bool isCustomerUpdated = (await repository.updateCustomer(
            event.customerId,
            event.adminId,
            event.name,
            event.balance,
            event.password,
            event.address));
        yield isCustomerUpdated
            ? CustomerUpdateUpdated(isCustomerUpdated: isCustomerUpdated)
            : CustomerUpdateFail();
      } catch (e) {
        print(e);
        yield CustomerUpdateError();
      }
    }

    //Fetch Vendors
    if (event is ResetFetchVendors) {
      yield FetchVendorsEmpty();
    }

    if (event is FetchVendors) {
      yield FetchVendorsLoading();

      try {
        final List<Vendors> vendors = await repository.fetchVendors();
        yield FetchVendorsLoaded(vendors: vendors);
      } catch (e) {
        print(e);
        yield FetchVendorsError();
      }
    }

    //Fetch Category
    if (event is ResetFetchCategory) {
      yield FetchCategoryEmpty();
    }

    if (event is FetchCategory) {
      yield FetchCategoryLoading();

      try {
        final List<Category> category = await repository.fetchCategory();
        yield FetchCategoryLoaded(category: category);
      } catch (e) {
        print(e);
        yield FetchCategoryError();
      }
    }

    //Fetch SubCategory
    if (event is ResetFetchSubCategory) {
      yield FetchSubCategoryEmpty();
    }

    if (event is FetchSubCategory) {
      yield FetchSubCategoryLoading();

      try {
        final List<SubCategory> subCategory =
            await repository.fetchSubCategory();
        yield FetchSubCategoryLoaded(subCategory: subCategory);
      } catch (e) {
        print(e);
        yield FetchSubCategoryError();
      }
    }
  }
}
