import 'package:flutter/material.dart';
import 'package:sikesdes/DetailAnak_page.dart';
import 'package:sikesdes/utils/colors.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
                Expanded(child: Text("Masukkan NIK Anak untuk melihat BIODATA dan Perkembangan Berat & Tinggi Badan", style: TextStyle(color: Colors.black.withOpacity(0.6)),)),
              ],
            )
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0, left: 13.0, right: 13.0),
            child: Card(
              color: Colors.white.withOpacity(0.7),
              child: TextFormField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.credit_card,
                    color: primaryColor,
                  ),
                  hintText: 'Masukkan NIK Anak',
                  hintStyle: TextStyle(
                      fontSize: 13),
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
                onTap: (){

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
                    cardInfo("Nama", ""),
                    cardInfo("Jenis Kelamin", ""),
                    cardInfo("Tanggal Lahir", ""),
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailAnakPage()
                      )
                  );
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
}
