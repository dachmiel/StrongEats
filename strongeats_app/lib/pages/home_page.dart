import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:strongeats/nav_bar/home.dart';
import 'package:strongeats/nav_bar/meals.dart';
import 'package:strongeats/nav_bar/profile.dart';
import 'package:strongeats/nav_bar/workouts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final user = FirebaseAuth.instance.currentUser!;
  void _nagivateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<String> _pageTitles = [
    'Home',
    'Workouts',
    'Meals',
    'Profile',
  ];

  final List<Widget> _pages = [
    UserHome(),
    UserWorkouts(),
    UserMeals(),
    UserProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            _pageTitles[_selectedIndex],
            style: TextStyle(fontSize: 20),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                FirebaseAuth.instance.signOut();
              },
              child: Icon(Icons.logout),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey[600],
            ),
          )),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[900],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[600],
        currentIndex: _selectedIndex,
        onTap: _nagivateBottomBar,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Workouts'),
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: 'Meals'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Profile'),
        ],
      ),
    );
  }
}
