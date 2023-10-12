import 'package:flutter/material.dart';

class DataAnak extends StatefulWidget {
  final String nama, jenis_kelamin, tanggal_lahir, umur, nik_keluarga, nama_orang_tua, berat_badan,tinggi_badan;
  const DataAnak({Key? key, required this.nama, required this.jenis_kelamin, required this.tanggal_lahir, required this.umur, required this.nik_keluarga, required this.nama_orang_tua, required this.berat_badan, required this.tinggi_badan}) : super(key: key);

  @override
  State<DataAnak> createState() => _DataAnakState();
}

class _DataAnakState extends State<DataAnak> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(18.0),
        child: ListView(
          children: [
            cardInfo("Nama", "${widget.nama}"),
            cardInfo("Jenis Kelamin", "${widget.jenis_kelamin}"),
            cardInfo("Tanggal Lahir", "${widget.tanggal_lahir}"),
            cardInfo("Umur", "${widget.umur}"),
            cardInfo("NIK Keluarga", "${widget.nik_keluarga}"),
            cardInfo("Nama Orang Tua", "${widget.nama_orang_tua}"),
            cardInfo("Berat Badan", "${widget.berat_badan} Kg"),
            cardInfo("Tinggi Badan", "${widget.tinggi_badan} Cm"),
          ],
        ),
      )
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
          color: Colors.white.withOpacity(0.5),
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
        SizedBox(
          height: 5.0,
        )
      ],
    );
  }
}
