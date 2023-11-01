import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sikesdes/DataAnak.dart';
import 'package:sikesdes/Perkembangan2_page.dart';
import 'package:sikesdes/Perkembangan_page.dart';
import 'package:sikesdes/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailAnakPage extends StatefulWidget {
  VoidCallback? login;
  final bool formperkembangan;
  final String nik, nama, jenis_kelamin, tanggal_lahir, umur, nik_keluarga, nama_orang_tua, berat_badan,tinggi_badan;
  DetailAnakPage({Key? key, this.login, required this.formperkembangan, required this.nik, required this.nama, required this.jenis_kelamin, required this.tanggal_lahir, required this.umur, required this.nik_keluarga, required this.nama_orang_tua, required this.berat_badan, required this.tinggi_badan}) : super(key: key);

  @override
  State<DetailAnakPage> createState() => _DetailAnakPageState();
}

class _DetailAnakPageState extends State<DetailAnakPage> with SingleTickerProviderStateMixin {
  String? role;
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

  _getUser() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString("access_token") != null) {
      setState(() {
        role = preferences.getString("role");
      });
    }else{
      // setState(() {
      //   widget.login();
      // });
    }
  }
  
  @override
  void initState() {
    super.initState();
    _getUser();
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
            DataAnak(
              nik: widget.nik,
              nama: widget.nama,
              jenis_kelamin: widget.jenis_kelamin,
              tanggal_lahir: widget.tanggal_lahir,
              umur: widget.umur,
              nik_keluarga: widget.nik_keluarga,
              nama_orang_tua: widget.nama_orang_tua,
              berat_badan: widget.berat_badan,
              tinggi_badan: widget.tinggi_badan,
            ),
            if(widget.formperkembangan == true)...[
              Perkembangan2Page(login: login, nik: widget.nik, nama: widget.nama)
            ]else...[
              PerkembanganPage(nik: widget.nik)
            ]
          ]),
    );
  }

  Future login() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    Navigator.pop(context);
    setState(() {
      widget.login!();
    });
  }
}
