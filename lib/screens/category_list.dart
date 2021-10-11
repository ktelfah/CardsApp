import 'package:cards_app/bloc/cards_bloc.dart';
import 'package:cards_app/bloc/cards_event.dart';
import 'package:cards_app/bloc/cards_state.dart';
import 'package:cards_app/models/categories.dart';
import 'package:cards_app/screens/sub_category_list.dart';
import 'package:cards_app/screens/vendors_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

var getSelectedCategoryId;

class CategoryList extends StatefulWidget {
  const CategoryList({Key key}) : super(key: key);

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  void initState() {
    super.initState();
    BlocProvider.of<FirebaseBloc>(context).add(ResetFetchCategory());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        BlocProvider.of<FirebaseBloc>(context).add(ResetFetchVendors());
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFFF2562),
          // automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(getSelectedVendorName),
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
                BlocProvider.of<FirebaseBloc>(context).add(ResetFetchVendors());
              },
              child: Icon(Icons.arrow_back)),
        ),
        body:
            BlocBuilder<FirebaseBloc, FirebaseState>(builder: (context, state) {
          if (state is FetchCategoryEmpty) {
            BlocProvider.of<FirebaseBloc>(context).add(FetchCategory());
          }

          if (state is FetchCategoryError) {
            return Center(
              child: Text("Failed to fetch data"),
            );
          }

          if (state is FetchCategoryLoaded) {
            var categoryList = state.category;
            return body(categoryList);
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        }),
      ),
    );
  }

  Widget body(List<Category> categoryList) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 6.0,
                  mainAxisSpacing: 6.0,
                  childAspectRatio: MediaQuery.of(context).size.width /
                      (MediaQuery.of(context).size.height / 5.1),
                ),
                itemCount: categoryList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      getSelectedCategoryId = categoryList[index].categoryId;
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                              value: BlocProvider.of<FirebaseBloc>(context),
                              child: SubCategoryList())));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.red[500],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                      child: Center(
                        child: Text(
                          categoryList[index].categoryName,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
