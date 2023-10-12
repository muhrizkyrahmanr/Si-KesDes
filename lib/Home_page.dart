import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sikesdes/DetailAnak_page.dart';
import 'package:sikesdes/service/AnakService.dart';
import 'package:sikesdes/utils/colors.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:sikesdes/utils/format_date.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CarouselController _carouselController = CarouselController();
  int _currentIndexBanner = 0;

  List banner = [
    'assets/banner/banner1.png',
    'assets/banner/banner2.png',
  ];

  FocusNode _textFocusNode = FocusNode();
  final TextEditingController _controllerNIK = TextEditingController();
  bool _validNIK=true, _validKurang16NIK=true;

  String nama="",jeniskelamin="", tanggallahir="", umur="", nik_keluarga="", nama_orang_tua="", berat_badan="", tinggi_badan="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          _sliderBanner(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: banner.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _carouselController.animateToPage(entry.key),
                child: Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : primaryColor).withOpacity(_currentIndexBanner == entry.key ? 0.9 : 0.4)),
                ),
              );
            }).toList(),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5.0, left: 13.0, right: 13.0),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: primaryColor,
                ),
                SizedBox(width: 10.0,),
                Expanded(child: Text("Masukkan NIK Anak untuk melihat Perkembangan Berat & Tinggi Badan", style: TextStyle(color: Colors.black.withOpacity(0.6)),)),
              ],
            )
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0, left: 13.0, right: 13.0),
            child: Card(
              color: Colors.white.withOpacity(0.7),
              child: TextFormField(
                controller: _controllerNIK,
                focusNode: _textFocusNode,
                inputFormatters: [LengthLimitingTextInputFormatter(16)],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.credit_card,
                    color: primaryColor,
                  ),
                  hintText: 'Masukkan NIK Anak',
                  hintStyle: TextStyle(
                      fontSize: 13),
                    suffixIcon: _validNIK == false
                        ? Tooltip(
                      preferBelow: false,
                      decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.9)
                      ),
                      triggerMode: TooltipTriggerMode.tap,
                      message: 'NIK masih kosong',
                      child: Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 20.0,
                      ),
                    )
                        : _validKurang16NIK == false
                        ? Tooltip(
                      preferBelow: false,
                      decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.9)
                      ),
                      triggerMode: TooltipTriggerMode.tap,
                      message: 'NIK kurang dari 16 digit',
                      child: Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 20.0,
                      ),
                    )
                        : null
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5.0, left: 13.0, right: 13.0),
            child: Card(
              color: primaryColor,
              child: InkWell(
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                onTap: () async{
                  if(_controllerNIK.text.isNotEmpty){
                    if(_controllerNIK.text.length == 16){
                      setState(() {
                        _validNIK = true;
                        _validKurang16NIK = true;
                      });
                    }else{
                      setState(() {
                        _validNIK = true;
                        _validKurang16NIK = false;
                      });
                    }
                  }else{
                    setState((){
                      _validNIK = false;
                    });
                  }

                  if(_controllerNIK.text.isNotEmpty && _controllerNIK.text.length == 16) {
                    showAlertDialogLoading(context);
                    var getAnak = await AnakService().getAnak(_controllerNIK.text);
                    if(getAnak != 0 && getAnak != 1){
                      setState(() {
                        nama = getAnak['nama'];
                        if(getAnak['jenis_kelamin'] == "l"){
                          jeniskelamin = "Laki-Laki";
                        }else{
                          jeniskelamin = "Perempuan";
                        }
                        if(getAnak['tanggal_lahir'] != null){
                          DateTime dateTime = DateTime.parse(getAnak['tanggal_lahir']);
                          tanggallahir =  FormatDate().formatTglIndo(DateFormat('yyyy-MM-dd').format(dateTime));
                          umur=calculateAge(dateTime);
                        }
                        nik_keluarga = getAnak['nik_keluarga'];
                        nama_orang_tua = getAnak['nama_orang_tua'];
                        berat_badan = getAnak['berat_badan'].toString();
                        tinggi_badan = getAnak['tinggi_badan'].toString();
                      });
                      Navigator.pop(context);
                    }else if(getAnak == 1){
                      Navigator.pop(context);
                      infoUpdate("NIK ${_controllerNIK.text} Tidak Ditemukan");
                    }else{
                      Navigator.pop(context);
                      infoUpdate("Gagal Terhubung Keserver");
                    }
                  }
                },
                child: Container(
                  height: 40,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      SizedBox(width: 5.0,),
                      Text(
                        'Lihat Hasil',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
            child: Card(
              color: Colors.white.withOpacity(0.7),
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    cardInfo("Nama", nama),
                    cardInfo("Jenis Kelamin", jeniskelamin),
                    cardInfo("Tanggal Lahir", tanggallahir),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5.0, left: 13.0, right: 13.0, bottom: 18.0),
            child: Card(
              color: primaryColor,
              child: InkWell(
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                onTap: (){
                  if(nama.isNotEmpty || jeniskelamin.isNotEmpty || tanggallahir.isNotEmpty){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailAnakPage(
                              nama: nama,
                              jenis_kelamin: jeniskelamin,
                              tanggal_lahir: tanggallahir,
                              umur: umur,
                              nik_keluarga: nik_keluarga,
                              nama_orang_tua: nama_orang_tua,
                              berat_badan: berat_badan,
                              tinggi_badan: tinggi_badan,
                            )
                        )
                    );
                  }else{
                    _textFocusNode.requestFocus();
                    infoUpdate("Lakukan Pencarian NIK Terlebih Dahulu");
                  }
                },
                child: Container(
                  height: 40,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.perm_identity,
                        color: Colors.white,
                      ),
                      SizedBox(width: 5.0,),
                      Text(
                        'Lihat Detail',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600
                        ),
                      )
                    ],
                  )
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sliderBanner() {
    return Padding(
      padding: EdgeInsets.only(top: 18.0),
      child: CarouselSlider(
          items: [
            for (var i = 0; i < banner.length; i++)
              Stack(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        "${banner[i]}",
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            alignment: Alignment.center,
                            child: const Text(
                              "Gagal Memuat Gambar!",
                              style: TextStyle(fontSize: 12),
                            ),
                          );
                        },
                      )),
                ],
              )
          ],
          carouselController: _carouselController,
          options: CarouselOptions(
              viewportFraction: 1,
              aspectRatio: 2.4,
              autoPlay: true,
              enlargeCenterPage: true,
              initialPage: 2,
              pauseAutoPlayOnTouch: true,
              autoPlayInterval: const Duration(seconds: 7),
              autoPlayAnimationDuration:
              const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndexBanner = index;
                });
              })),
    );
  }

  Widget cardInfo(String label, String value){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Text(label, style: TextStyle(fontSize: 13.0, color: Colors.black.withOpacity(0.5)),),
        ),
        Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                8.0),
          ),
          child: Container(
            padding: EdgeInsets.all(13.0),
            width: MediaQuery.of(context).size.width,
            child: Text(value,style: TextStyle(fontSize: 13.0),),
          ),
        ),
      ],
    );
  }

  infoUpdate(String text) async{
    await Future.delayed(Duration(seconds: 0));
    return QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: "Gagal",
      text: '${text}',
    );
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
}
