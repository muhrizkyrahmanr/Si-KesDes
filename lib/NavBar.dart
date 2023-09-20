import 'package:flutter/material.dart';
import 'package:sikesdes/Home_page.dart';
import 'package:sikesdes/Balita_page.dart';
import 'package:sikesdes/Profil_page.dart';
import 'package:sikesdes/utils/colors.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _currentIndex = 0;

  final List<Widget> _changeSelectedNavBar = [
    HomePage(),
    BalitaPage(),
    ProfilPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Si-KesDes"),
        ),
      ),
      body: _changeSelectedNavBar[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: primaryColor,
        items: [
          BottomNavigationBarItem(
            icon: Container(
                width: 35.0,
                height: 35.0,
                decoration: BoxDecoration(
                  color: _currentIndex == 0 ? Colors.white : Colors.white.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.home, color: primaryColor,)
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Container(
                width: 35.0,
                height: 35.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == 1 ? Colors.white : Colors.white.withOpacity(0.5),
                ),
                child: Icon(Icons.child_care, color: primaryColor,)
            ),
            label: 'Anak',
          ),
          BottomNavigationBarItem(
            icon: Container(
                width: 35.0,
                height: 35.0,
                decoration: BoxDecoration(
                  color: _currentIndex == 2 ? Colors.white : Colors.white.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person, color: primaryColor,)
            ),
            label: 'Profil',
          ),
        ],
        // CurrentIndex mengikuti baris item bottom navigasi yang diklik
        currentIndex: _currentIndex,
        // Warna saat item diklik
        selectedItemColor: Colors.blue,
        // Metode yang dijalankan saat ditap
        // Agar bottom navigation tidak bergerak saat diklik
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
        showSelectedLabels: false,
      ),
    );
  }
}
