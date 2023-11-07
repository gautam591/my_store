import 'package:flutter/material.dart';
import 'dart:convert';
import '../shared_prefs.dart';
import 'notification.dart';
import 'purchase_history_screen.dart';
import 'stoke_screen.dart';
import 'home.dart';
import 'package:my_store_app/login_register.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  Map<String, dynamic> user = {'uid': 'Loading...'};
  bool dataFetched = false;

  _HomeScreenState() {
    setUserData();
  }

  final List<Widget> _pages = [
    home(),
    purchase(),
    stoke(),
    notification(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> setUserData() async {
    String userRaw = await getLocalData('user') as String;
    setState(() {
      user = json.decode(userRaw);
      dataFetched = true; // Set the flag to indicate data has been fetched.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Store Home'),
        actions: <Widget>[
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              );
            },
          ),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.green,
              ),
              child: dataFetched?
                Text(
                  user['display_name'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ) : const CircularProgressIndicator(),
            ),
            ListTile(
              title: const Text('Edit Profile'),
              onTap: () {
                // Navigate to the home page or perform an action
                Future.delayed(const Duration(seconds: 0), () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (BuildContext context) => HomeScreen(),
                    ),
                  );
                });
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                Future.delayed(Duration(seconds: 0), () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (BuildContext context) =>LoginRegisterPage(),
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
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black),
            label: 'Home',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_shopping_cart, color: Colors.black),
            label: 'Purchase',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.track_changes, color: Colors.black),
            label: 'Stoke',
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
