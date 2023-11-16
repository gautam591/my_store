import 'package:flutter/material.dart';
import 'dart:convert';
import 'shared_prefs.dart';
import 'screens/notification_tab.dart';
import 'screens/sales_tab.dart';
import 'screens/purchase_tab.dart';
import 'screens/summary_tab.dart';
import 'package:my_store_app/login_screen.dart';

class HomeScreen extends StatefulWidget {
  Map<String, dynamic> user;

  HomeScreen({
    super.key,
    required this.user
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late List<Widget> _pages;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> setUserData() async {
    setState(() {
      Map<String, dynamic> user = widget.user;
      _pages = [
        SummaryTab(user: widget.user,),
        SalesTab(user: widget.user,),
        PurchaseTab(user: widget.user,),
        NotificationTab(),
      ];
    });
  }

  @override
  void initState() {
    super.initState();
    setUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
        title: const Text('Store Home'),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.green,
              ),
              child:
                Text(
                  widget.user['display_name'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                Future.delayed(const Duration(seconds: 0), () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (BuildContext context) => const LoginRegisterPage(),
                    ),
                  );
                });
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black),
            label: 'Home',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.track_changes, color: Colors.black),
            label: 'Sales',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_shopping_cart, color: Colors.black),
            label: 'Purchase',
            backgroundColor: Colors.green,
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active, color: Colors.black),
            label: 'Notification',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black,
      ),
    );
  }
}
