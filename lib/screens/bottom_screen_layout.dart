import 'package:flutter/material.dart';
import 'package:rentease/screens/bottom_screen/bookings_screen.dart';
import 'package:rentease/screens/bottom_screen/favorites_screen.dart';
import 'package:rentease/screens/bottom_screen/home_screen.dart';
import 'package:rentease/screens/bottom_screen/profile_screen.dart';

class BottomScreenLayout extends StatefulWidget {
  const BottomScreenLayout({super.key});

  @override
  State<BottomScreenLayout> createState() => _BottomScreenLayoutState();
}

class _BottomScreenLayoutState extends State<BottomScreenLayout> {
  int _selectedIndex = 0;

  List<Widget> lstBottomScreen = [
    HomeScreen(),
    BookingsScreen(),
    FavoritesScreen(),
    ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bottom Navigation"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: lstBottomScreen[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: "Bookings",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "favorites"),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
        backgroundColor: Color(0xff142725),
        selectedItemColor: Colors.white,
        unselectedItemColor: Color(0xff99DAB3),
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
