import 'package:flutter/material.dart';

class DataAnak extends StatefulWidget {
  const DataAnak({Key? key}) : super(key: key);

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
            cardInfo("Nama", "Muhammad Rizky"),
            cardInfo("Jenis Kelamin", "Laki-Laki"),
            cardInfo("Tanggal Lahir", "28 Maret 2023"),
            cardInfo("Umur", "2 Bulan"),
            cardInfo("NIK Keluarga", "1111111111111111"),
            cardInfo("Nama Orang Tua", "Baco Becce"),
            cardInfo("Berat Badan", "10 Kg"),
            cardInfo("Tinggi Badan", "48 Cm"),
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
