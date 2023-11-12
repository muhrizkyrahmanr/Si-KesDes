import 'package:flutter/material.dart';
import 'package:sikesdes/Anak_page.dart';
import 'package:sikesdes/Home_page.dart';
import 'package:sikesdes/Login_page.dart';
import 'package:sikesdes/Profil_page.dart';
import 'package:sikesdes/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();


}

class _NavBarState extends State<NavBar> {
  int _currentIndex = 0;
  String? token;

  bool searchActive = false;
  String searchQuery = '';

  void updateSearchQuery(bool search, String query) {
    setState(() {
      searchActive = search;
      searchQuery = query;
    });
  }

  clearTextSearch(){
    updateSearchQuery(false, '');
    _controllerSearch.clear();
  }

  final TextEditingController _controllerSearch = TextEditingController();
  final FocusNode _focusSearch = FocusNode();
  Icon cusIcon = Icon(Icons.search);
  Widget cusSearchBar = Text("Si-KesDes");

  @override
  void initState() {
    super.initState();
    login();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _changeSelectedNavBar = [
      HomePage(),
      AnakPage(login: login, searchActive: searchActive, searchQuery: searchQuery, clearTextSearch: clearTextSearch),
      ProfilPage(login: login),
      LoginPage(login: login),
    ];

    return Scaffold(
      appBar: AppBar(
        title: cusSearchBar,
        centerTitle: true,
        actions: [
          if(token != null)...[
            if(_currentIndex == 1)...[
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: IconButton(
                  icon: cusIcon,
                  color: Colors.white,
                  onPressed: () async{
                    if(cusIcon.icon == Icons.search){
                      setState(() {
                        cusIcon = Icon(Icons.cancel);
                        cusSearchBar = TextField(
                          focusNode: _focusSearch,
                          autofocus: true,
                          controller: _controllerSearch,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Masukkan NIK atau Nama Anak",
                            hintStyle: TextStyle(fontSize: 15, color: Colors.white.withOpacity(0.5)),
                          ),
                          onChanged: (value) {
                            updateSearchQuery(true, value);
                          },
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        );
                      });
                    }else{
                      updateSearchQuery(false, '');
                      if(!_controllerSearch.text.isEmpty){
                        _controllerSearch.clear();
                      }else {
                        setState(() {
                          cusIcon = Icon(Icons.search);
                          cusSearchBar = Text("Si-KesDes");
                        });
                      }
                    }
                  },
                ),
              ),
            ]
          ]
        ],
      ),
      body: _currentIndex != 0
           ? token == null
            ? _changeSelectedNavBar[3]
            : _changeSelectedNavBar[_currentIndex]
           : _changeSelectedNavBar[_currentIndex],
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
        onTap: (index) async{
          setState(() {
            updateSearchQuery(false, '');
            if(!_controllerSearch.text.isEmpty){
              _controllerSearch.clear();
            }else {
                cusIcon = Icon(Icons.search);
                cusSearchBar = Text("Si-KesDes");
            }
            _currentIndex = index;
          });
        },
        // Agar bottom navigation tidak bergerak saat diklik
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
        showSelectedLabels: false,
      ),
    );
  }

  Future login() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(preferences.getString("access_token") != null){
      setState(() {
        token = preferences.getString("access_token");
      });
    }else{
      setState(() {
        token = null;
      });
    }
  }
}
