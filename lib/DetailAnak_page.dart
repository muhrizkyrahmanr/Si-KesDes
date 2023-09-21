import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sikesdes/DataAnak.dart';
import 'package:sikesdes/PerkembanganPage.dart';
import 'package:sikesdes/utils/colors.dart';

class DetailAnakPage extends StatefulWidget {
  const DetailAnakPage({Key? key}) : super(key: key);

  @override
  State<DetailAnakPage> createState() => _DetailAnakPageState();
}

class _DetailAnakPageState extends State<DetailAnakPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Tab> myTabs = <Tab>[
    Tab(
      child: Text(
        'Data Anak',
        style: TextStyle(
            fontFamily: 'poppins'
        ),
      ),
    ),
    Tab(
      child: Text(
        'Perkembangan Anak',
        style: TextStyle(
            fontFamily: 'poppins'
        ),
      ),
    ),
  ];

  @override
  void initState() {
    _tabController = new TabController(vsync: this, length: myTabs.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Si-KesDes"),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: primaryColor,
          labelColor: Colors.white,
          tabs: myTabs,
        ),
      ),
      body:TabBarView(
          controller: _tabController,
          children: <Widget>[
            DataAnak(),
            PerkembanganPage()
          ]),
    );
  }
}
