import 'package:flutter/material.dart';
import 'package:sikesdes/NavBar.dart';
import 'package:sikesdes/Perkembangan_page.dart';
import 'package:sikesdes/utils/colors.dart';
import 'package:sikesdes/utils/material_colors.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AppState();
  }
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      theme: ThemeData(
        primarySwatch: colorPrimary,
        fontFamily: 'poppins',
      ),
      home: NavBar(),
      debugShowCheckedModeBanner: false,
    );
  }
}
