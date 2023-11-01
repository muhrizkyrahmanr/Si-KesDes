import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sikesdes/DataAnak.dart';
import 'package:sikesdes/DetailAnak_page.dart';
import 'package:sikesdes/FormAnak_page.dart';
import 'package:sikesdes/FormPerkembangan_page.dart';
import 'package:sikesdes/service/AnakService.dart';
import 'package:sikesdes/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quickalert/quickalert.dart';
import 'package:sikesdes/utils/format_date.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Perkembangan2Page extends StatefulWidget {
  final VoidCallback login;
  final String nik;
  final String nama;
  const Perkembangan2Page({Key? key, required this.login, required this.nik, required this.nama}) : super(key: key);

  @override
  State<Perkembangan2Page> createState() => _Perkembangan2PageState();
}

class _Perkembangan2PageState extends State<Perkembangan2Page> {
  bool isLoading = true;
  String? role;

  List ListPerkembangan = [];
  List ShowPerkembangan = [];

  _getUser() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString("access_token") != null) {
      setState(() {
        role = preferences.getString("role");
      });
    }else{
      setState(() {
        widget.login();
      });
    }
  }

  Future _getListPerkembangan() async{
    setState(() {
      isLoading = true;
    });
    var response = await AnakService().getPerkembangan(widget.nik);
    if(response != null) {
      if(response.length > 0){
        setState((){
          isLoading = false;
          ListPerkembangan = response;
          ShowPerkembangan = ListPerkembangan;
        });
      }else{
        setState((){
          isLoading = false;
          ListPerkembangan.clear();
          ShowPerkembangan = ListPerkembangan;
        });
      }
    }else{
      showMessage(false,"Gagal Terhubung Keserver");
    }
  }

  Future onRefresh() async{
    await _getListPerkembangan();
  }

  @override
  void initState() {
    super.initState();
    _getUser();
    _getListPerkembangan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(15.0),
        child: RefreshIndicator(
          onRefresh: onRefresh,
          child: isLoading
             ? Center(child: CircularProgressIndicator(color: primaryColor),)
             : Stack(
            children: [
              ListView.builder(
                  itemCount: ShowPerkembangan.length,
                  itemBuilder: (context, i) {
                    return Card(
                      color: Colors.white.withOpacity(0.7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Slidable(
                        key: Key(i.toString()),
                        startActionPane: ActionPane(
                          motion: StretchMotion(),
                          children: [
                            SlidableAction(
                              onPressed: ((context){
                                showAlertHapus(context,ShowPerkembangan[i].id.toString(), ShowPerkembangan[i].tanggal);
                              }),
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: "Hapus",
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomLeft: Radius.circular(8)),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                  padding: EdgeInsets.all(18.0),
                                  child:  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("${ShowPerkembangan[i].tanggal}",
                                          style: TextStyle(fontSize: 15.0, color: Colors.black.withOpacity(0.5))
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text("Tinggi Badan ${ShowPerkembangan[i].tinggi_badan} Cm",
                                          style: TextStyle(fontSize: 15.0)
                                      ),
                                      Text("Berat Badan ${ShowPerkembangan[i].berat_badan} Kg",
                                          style: TextStyle(fontSize: 15.0)
                                      ),
                                    ],
                                  )
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }
              ),
              dataEmpty()
            ],
          )
        )
      ),
      floatingActionButton: role == "desa"
        ? FloatingActionButton(
          backgroundColor: primaryColor,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FormPerkembangan(login: widget.login, nik: widget.nik, nama: widget.nama, getReloadPerkembangan: onRefresh)));
          },
          child: const Icon(Icons.add, color: Colors.white,),
        )
        : null
    );
  }

  Widget dataEmpty() {
    if(ShowPerkembangan.length == 0){
      return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 50,
                color: primaryColor,
              ),
              SizedBox(
                height: 5.0,
              ),
              Text("Kosong",style: TextStyle(fontWeight: FontWeight.bold),),
              Text("Data Perkembangan Kosong")
            ],
          )
      );
    }else{
      return Container();
    }
  }

  showAlertHapus(BuildContext context, String id, String tanggal) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Hapus', style: const TextStyle(fontFamily: 'poppins'),),
            content: Text('Anda yakin ingin menghapus Perkembangan tanggal ${tanggal}?', style: const TextStyle(fontFamily: 'poppins'),),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Batal',
                    style: TextStyle(color: Colors.grey),
                  )),
              TextButton(
                  onPressed: () async{
                    (context);
                    var response = await AnakService().deletePerkembangan(id);
                    if(response == 1){
                      Navigator.pop(context);
                      showMessage(true,"Menghapus anak Perkembangan tanggal ${tanggal}");
                      onRefresh();
                    }else if(response == 2){
                      Navigator.pop(context);
                      showMessage(false,"Menghapus anak Perkembangan tanggal ${tanggal}");
                    }else if(response == 3){
                      Navigator.pop(context);
                      SharedPreferences preferences = await SharedPreferences.getInstance();
                      preferences.clear();
                      setState(() {
                        widget.login();
                      });
                    }else{
                      Navigator.pop(context);
                      showMessage(false,"Gagal Terhubung Keserver");
                    }
                  },
                  child: const Text('Ya', style: const TextStyle(fontFamily: 'poppins'),))
            ],
          );
        });
  }

  showAlertDialogLoading(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(
            color: primaryColor,
          ),
          Container(
              margin: const EdgeInsets.only(left: 15),
              child: const Text(
                "Loading...",
                style: const TextStyle(fontFamily: 'poppins'),
              )),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: alert,
        );
      },
    );
  }

  showMessage(bool success, String text) async{
    await Future.delayed(Duration(seconds: 0));
    return QuickAlert.show(
      context: context,
      type: success == true ? QuickAlertType.success : QuickAlertType.error,
      confirmBtnColor: primaryColor,
      title: success == true ? "Sukses" : "Gagal",
      text: '${text}',
    );
  }
}
