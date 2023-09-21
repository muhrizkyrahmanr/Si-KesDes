import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sikesdes/DataAnak.dart';
import 'package:sikesdes/DetailAnak_page.dart';
import 'package:sikesdes/utils/colors.dart';

class AnakPage extends StatefulWidget {
  const AnakPage({Key? key}) : super(key: key);

  @override
  State<AnakPage> createState() => _AnakPageState();
}

class _AnakPageState extends State<AnakPage> {
  @override
  void initState() {
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Si-KesDes"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(15.0),
        child: ListView(
          children: [
            InkWell(
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailAnakPage()
                    )
                );
              },
              child: Card(
                color: Colors.white.withOpacity(0.7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                          padding: EdgeInsets.all(18.0),
                          child:  Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("111111111111111",
                                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600)
                              ),
                              Text("Muhammad Rizky",
                                  style: TextStyle(fontSize: 15.0)
                              ),
                              Text("Laki-Laki",
                                  style: TextStyle(fontSize: 15.0, color: Colors.black.withOpacity(0.5))
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Wrap(
                                spacing: 5.0,
                                runSpacing: 5.0,
                                children: [
                                  Container(
                                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.circular(8.0), // Atur radius sudut di sini
                                      ),
                                      child: Text("Tinggi Badan 10 cm", style: TextStyle(fontSize: 13.0, color: Colors.white),)
                                  ),
                                  Container(
                                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.circular(8.0), // Atur radius sudut di sini
                                      ),
                                      child: Text("Berat Badan 10 kg", style: TextStyle(fontSize: 13.0, color: Colors.white),)
                                  ),
                                ],
                              )
                            ],
                          )
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        )
      )
    );
  }
}
