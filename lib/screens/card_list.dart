import 'package:flutter/material.dart';

class CardList extends StatefulWidget {
  const CardList({Key key}) : super(key: key);

  @override
  _CardListState createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF2562),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text("Card List"),
      ),
      body: Container(
        child: ListView.builder(
            itemCount: 5,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text("Card Number:",style: TextStyle(fontSize: 15),),
                     SizedBox(height: 5,),
                     Text("Card Vender:",style: TextStyle(fontSize: 15),),
                     SizedBox(height: 5,),
                     Text("Amount:",style: TextStyle(fontSize: 15),),
                     SizedBox(height: 5,),
                     Divider(thickness: 2,)
                   ],
                  )
                ),
              );
            }),
      ),
    );
  }
}
