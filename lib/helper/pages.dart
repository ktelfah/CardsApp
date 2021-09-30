import 'package:cards_app/screens/card_list.dart';
import 'package:cards_app/screens/order_list.dart';
import 'package:cards_app/screens/update_customer_profile.dart';
import 'package:flutter/material.dart';

class Pages extends StatefulWidget {
  const Pages({Key key}) : super(key: key);

  @override
  _PagesState createState() => _PagesState();
}

class _PagesState extends State<Pages> {
  Widget currentPage = CardList();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentPage,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFFFF2562),
        unselectedItemColor: Color(0xFF414041),
        selectedFontSize: 14,
        unselectedFontSize: 14,
        onTap: (value) {
          setState(() => _currentIndex = value);
          _selectTab(_currentIndex);
        },
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.card_travel),
            label: 'CardList',
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.bookmark_border),
            label: 'OrderList',
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void _selectTab(int tabItem) {
    setState(() {
      switch (tabItem) {
        case 0:
          currentPage = CardList();
          break;
        case 1:
          currentPage = OrderList();
          break;
        case 2:
          currentPage = UpdateCustomerProfile();
          break;
      }
    });
  }
}
