import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sikesdes/DataAnak.dart';
import 'package:sikesdes/DetailAnak_page.dart';
import 'package:sikesdes/FormAnak_page.dart';
import 'package:sikesdes/service/AnakService.dart';
import 'package:sikesdes/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quickalert/quickalert.dart';
import 'package:sikesdes/utils/format_date.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AnakPage extends StatefulWidget {
  final VoidCallback login;
  final bool searchActive;
  final String searchQuery;
  final VoidCallback clearTextSearch;
  const AnakPage({Key? key, required this.login, required this.searchActive, required this.searchQuery, required this.clearTextSearch}) : super(key: key);

  @override
  State<AnakPage> createState() => _AnakPageState();
}

class _AnakPageState extends State<AnakPage> {
  bool isLoading = true;
  String? role;
  bool formperkembangan = false;

  List ListAnak = [];
  List ShowListAnak = [];

  _getUser() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString("access_token") != null) {
      setState(() {
        role = preferences.getString("role");
        if(role == "desa"){
          formperkembangan = true;
        }else{
          formperkembangan = false;
        }
      });
    }else{
      setState(() {
        widget.login();
      });
    }
  }

  Future _getListAnak() async{
    setState(() {
      isLoading = true;
    });
    var response = await AnakService().getListAnak();
    if(response != null && response != 401) {
      setState((){
        isLoading = false;
        ListAnak = response;
        ShowListAnak = ListAnak;
      });
    }else if(response != null && response == 401){
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.clear();
      setState(() {
        isLoading = false;
        widget.login();
      });
    }else{
      showMessage(false,"Gagal Terhubung Keserver");
    }
  }

  Future onRefresh() async{
    widget.clearTextSearch();
    await _getListAnak();
  }

  @override
  void initState() {
    super.initState();
    _getUser();
    _getListAnak();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      if(widget.searchActive == true && widget.searchQuery.isNotEmpty){
        ShowListAnak = ListAnak.where((item) => item.nik.toString().contains(widget.searchQuery) || item.nama.toLowerCase().contains(widget.searchQuery.toLowerCase())).toList();
      }else{
        ShowListAnak = ListAnak;
      }
    });
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
                  itemCount: ShowListAnak.length,
                  itemBuilder: (context, i) {
                    String jeniskelamin="", tanggallahir="", umur="";
                    if(ShowListAnak[i].jenis_kelamin == "l"){
                      jeniskelamin = "Laki-Laki";
                    }else{
                      jeniskelamin = "Perempuan";
                    }
                    if(ShowListAnak[i].tanggal_lahir != null){
                      DateTime dateTime = DateTime.parse(ShowListAnak[i].tanggal_lahir);
                      tanggallahir =  FormatDate().formatTglIndo(DateFormat('yyyy-MM-dd').format(dateTime));
                      umur=calculateAge(dateTime);
                    }
                    return Card(
                      color: Colors.white.withOpacity(0.7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: InkWell(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailAnakPage(
                                    login: widget.login,
                                    formperkembangan: formperkembangan,
                                    nik: ShowListAnak[i].nik.toString(),
                                    nama: ShowListAnak[i].nama,
                                    jenis_kelamin: jeniskelamin,
                                    tanggal_lahir: tanggallahir,
                                    umur: umur,
                                    nik_keluarga: ShowListAnak[i].nik_keluarga,
                                    nama_orang_tua: ShowListAnak[i].nama_orang_tua,
                                    berat_badan: ShowListAnak[i].berat_badan.toString(),
                                    tinggi_badan: ShowListAnak[i].tinggi_badan.toString(),
                                  )
                              )
                          );
                        },
                        child: Slidable(
                          key: Key(i.toString()),
                          startActionPane: ActionPane(
                            motion: StretchMotion(),
                            children: [
                              SlidableAction(
                                onPressed: ((context){
                                  showAlertHapus(context,ShowListAnak[i].nik.toString());
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
                                        Text("${ShowListAnak[i].nik}",
                                            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600)
                                        ),
                                        Text("${ShowListAnak[i].nama}",
                                            style: TextStyle(fontSize: 15.0)
                                        ),
                                        Text("${jeniskelamin}",
                                            style: TextStyle(fontSize: 15.0, color: Colors.black.withOpacity(0.5))
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Wrap(
                                          spacing: 5.0,
                                          runSpacing: 5.0,
                                          children: [
                                            if(ShowListAnak[i].tinggi_badan_akhir != null)...[
                                              Container(
                                                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                                  decoration: BoxDecoration(
                                                    color: primaryColor,
                                                    borderRadius: BorderRadius.circular(8.0), // Atur radius sudut di sini
                                                  ),
                                                  child: Text("Tinggi Badan ${ShowListAnak[i].tinggi_badan_akhir} cm", style: TextStyle(fontSize: 13.0, color: Colors.white),)
                                              ),
                                            ]else...[
                                              Container(
                                                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                                  decoration: BoxDecoration(
                                                    color: primaryColor,
                                                    borderRadius: BorderRadius.circular(8.0), // Atur radius sudut di sini
                                                  ),
                                                  child: Text("Tinggi Badan ${ShowListAnak[i].tinggi_badan} cm", style: TextStyle(fontSize: 13.0, color: Colors.white),)
                                              ),
                                            ],
                                            if(ShowListAnak[i].berat_badan_akhir != null)...[
                                              Container(
                                                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                                  decoration: BoxDecoration(
                                                    color: primaryColor,
                                                    borderRadius: BorderRadius.circular(8.0), // Atur radius sudut di sini
                                                  ),
                                                  child: Text("Berat Badan ${ShowListAnak[i].berat_badan_akhir} kg", style: TextStyle(fontSize: 13.0, color: Colors.white),)
                                              ),
                                            ]else...[
                                              Container(
                                                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                                  decoration: BoxDecoration(
                                                    color: primaryColor,
                                                    borderRadius: BorderRadius.circular(8.0), // Atur radius sudut di sini
                                                  ),
                                                  child: Text("Berat Badan ${ShowListAnak[i].berat_badan} kg", style: TextStyle(fontSize: 13.0, color: Colors.white),)
                                              ),
                                            ]
                                          ],
                                        )
                                      ],
                                    )
                                ),
                              )
                            ],
                          ),
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
                    builder: (context) => FormAnakPage(getReloadAnak: onRefresh,login: widget.login)));
          },
          child: const Icon(Icons.add, color: Colors.white,),
        )
        : null
    );
  }

  String calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    final age = now.difference(birthDate);

    final years = age.inDays ~/ 365;
    final months = (age.inDays % 365) ~/ 30;
    if(years == 0){
      return '$months Bulan';
    }else{
      return '$months Bulan, $years Tahun';
    }
  }

  Widget dataEmpty() {
    if(ShowListAnak.length == 0){
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
              Text("Data Anak Kosong")
            ],
          )
      );
    }else{
      return Container();
    }
  }

  showAlertHapus(BuildContext context, String nik) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Hapus', style: const TextStyle(fontFamily: 'poppins'),),
            content: Text('Anda yakin ingin menghapus anak NIK ${nik}?', style: const TextStyle(fontFamily: 'poppins'),),
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
                    var response = await AnakService().deleteAnak(nik);
                    if(response == 1){
                      Navigator.pop(context);
                      showMessage(true,"Menghapus anak NIK ${nik}");
                      onRefresh();
                    }else if(response == 2){
                      Navigator.pop(context);
                      showMessage(false,"Menghapus anak NIK ${nik}");
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
