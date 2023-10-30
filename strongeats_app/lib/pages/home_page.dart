import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:strongeats/nav_bar/home.dart';
import 'package:strongeats/nav_bar/meals.dart';
import 'package:strongeats/nav_bar/profile.dart';
import 'package:strongeats/nav_bar/workouts.dart';
// import 'package:google_nav_bar/google_nav_bar.dart';

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

  final List<Widget> _pages = [
    UserHome(),
    UserWorkouts(),
    UserMeals(),
    UserProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          user.email!,
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              FirebaseAuth.instance.signOut();
            },
            child: Icon(Icons.logout),
          ),
        ],
      ),
      // drawer: Drawer(
      //   backgroundColor: Colors.grey[300],
      //   child: Column(
      //     children: [
      //       // drawer header
      //       DrawerHeader(child: Icon(Icons.menu)),

      //       // home title
      //       ListTile(
      //         leading: Icon(Icons.home),
      //       )
      //     ],
      //   ),
      // ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
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

      // GOOGLE NAV BAR
      // bottomNavigationBar: Container(
      //   color: Colors.black,
      //   child: Padding(
      //     padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
      //     child: GNav(
      //       backgroundColor: Colors.black,
      //       color: Colors.grey,
      //       activeColor: Colors.white,
      //       gap: 10,
      //       padding: EdgeInsets.all(16),
      //       onTabChange: (index) {},
      //       tabs: const [
      //         GButton(
      //           icon: Icons.home,
      //           text: 'Home',
      //         ),
      //         GButton(
      //           icon: Icons.history,
      //           text: 'Workout Plan',
      //         ),
      //         GButton(
      //           icon: Icons.fastfood,
      //           text: 'Meal Plan',
      //         ),
      //         GButton(
      //           icon: Icons.settings,
      //           text: 'Settings',
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
