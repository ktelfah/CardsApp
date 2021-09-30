import 'package:cards_app/bloc/cards_bloc.dart';
import 'package:cards_app/bloc/cards_event.dart';
import 'package:cards_app/bloc/cards_state.dart';
import 'package:cards_app/models/subCategory.dart';
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
        title: Text("Select Data pack"),
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
      padding: const EdgeInsets.only(top: 20, left: 10,right: 10),
      child: ListView.builder(
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10))),
                    height: 60,
                   // width: MediaQuery.of(context).size.width - 300,
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                    height: 60,
                    //width: MediaQuery.of(context).size.width - 130,
                    child: Text("tititititiiiit"),
                    //width: MediaQuery.of(context).size.width - 700,
                  ),
                )
              ],
            );
          }),
    ));
  }
}
