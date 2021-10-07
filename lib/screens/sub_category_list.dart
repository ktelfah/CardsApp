import 'package:cards_app/bloc/cards_bloc.dart';
import 'package:cards_app/bloc/cards_event.dart';
import 'package:cards_app/bloc/cards_state.dart';
import 'package:cards_app/models/subCategory.dart';
import 'package:cards_app/screens/cart_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubCategoryList extends StatefulWidget {
  const SubCategoryList({Key key}) : super(key: key);

  @override
  _SubCategoryListState createState() => _SubCategoryListState();
}

class _SubCategoryListState extends State<SubCategoryList> {
  void initState() {
    super.initState();
    BlocProvider.of<FirebaseBloc>(context).add(ResetFetchSubCategory());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF2562),
        // automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text("Select Data Pack"),
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
              BlocProvider.of<FirebaseBloc>(context).add(ResetFetchCategory());
            },
            child: Icon(Icons.arrow_back)),
      ),
      body: BlocBuilder<FirebaseBloc, FirebaseState>(builder: (context, state) {
        if (state is FetchSubCategoryEmpty) {
          BlocProvider.of<FirebaseBloc>(context).add(FetchSubCategory());
        }

        if (state is FetchSubCategoryError) {
          return Center(
            child: Text("Failed to fetch data"),
          );
        }

        if (state is FetchSubCategoryLoaded) {
          var subCategoryList = state.subCategory;
          return body(subCategoryList);
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }

  Widget body(List<SubCategory> subCategoryList) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
        child: ListView.builder(
            itemCount: subCategoryList.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: BlocProvider.of<FirebaseBloc>(context),
                        child: CartList(
                          price: subCategoryList[index].price,
                          vendor: subCategoryList[index].name,
                          plan: subCategoryList[index].name,
                          quantity: subCategoryList[index].quantity,
                          uniqid: subCategoryList[index].uniqid,
                        ),
                      ),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 6,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.yellow,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: 60,
                            //width: MediaQuery.of(context).size.width - 130,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('${subCategoryList[index].name}'),
                                Text('${subCategoryList[index].price}',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            //width: MediaQuery.of(context).size.width - 700,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
