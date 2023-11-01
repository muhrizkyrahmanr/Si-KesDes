import 'package:flutter/material.dart';
import 'package:sikesdes/service/AnakService.dart';
import 'package:sikesdes/service/Model/Perkembangan_model.dart';
import 'package:sikesdes/utils/colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';

class PerkembanganPage extends StatefulWidget {
  final String nik;
  PerkembanganPage({Key? key, required this.nik}) : super(key: key);

  @override
  PerkembanganPageState createState() => PerkembanganPageState();
}

class PerkembanganPageState extends State<PerkembanganPage> {
  late ZoomPanBehavior _zoomPanBehavior;
  List<PerkembanganModel> dataPerkembangan = [];

  Future getPerkembangan() async {
    await Future.delayed(Duration(seconds: 0));
    showAlertDialogLoading(context);
    var response = await AnakService().getPerkembangan(widget.nik);
    if(response != null) {
      Navigator.pop(context);
      if(response.length > 0){
        setState(() {
          dataPerkembangan = response;
        });
      }else{
        setState(() {
          dataPerkembangan = [];
        });
      }
    }else{
      Navigator.pop(context);
      showMessage("Gagal Terhubung Keserver");
    }
  }

  @override
  void initState() {
    super.initState();
    _zoomPanBehavior = ZoomPanBehavior(
        enablePanning: true,
        enablePinching: true,
    );
    getPerkembangan();
  }

  @override
  Widget build(BuildContext context) {
    num maxTinggiValue = 0;
    num maxBeratValue = 0;
    if(dataPerkembangan.isNotEmpty){
      maxTinggiValue = dataPerkembangan.map((item) => item.tinggi_badan!).reduce((max, value) => max > value ? max : value);
      maxBeratValue = dataPerkembangan.map((item) => item.berat_badan!).reduce((max, value) => max > value ? max : value);
    }
    return Scaffold(
        body: Container(
          padding: EdgeInsets.all(8.0),
          child: ListView(
              children: [
                SfCartesianChart(
                enableAxisAnimation: true,
                primaryXAxis: CategoryAxis(
                  visibleMaximum: 5,
                ),
                primaryYAxis: NumericAxis(
                  numberFormat: NumberFormat('###.###'),
                  desiredIntervals: 5,
                  minimum: 0,
                  maximum: maxTinggiValue + 10,
                  labelFormat: '{value} cm',
                ),
                title: ChartTitle(text: 'Tinggi Badan Anak',textStyle: TextStyle(fontWeight: FontWeight.bold)),
                tooltipBehavior: TooltipBehavior(enable: true),
                zoomPanBehavior: _zoomPanBehavior,
                series: <SplineSeries<PerkembanganModel, String>>[
                  SplineSeries<PerkembanganModel, String>(
                      markerSettings: MarkerSettings(
                        isVisible: true,
                        shape: DataMarkerType.circle,
                        height: 7,
                        width: 7,
                      ),
                      color: primaryColor,
                      dataSource: dataPerkembangan,
                      xValueMapper: (PerkembanganModel perkembangan, _) => "${perkembangan.bulan}\n${perkembangan.tahun}",
                      yValueMapper: (PerkembanganModel perkembangan, _) => perkembangan.tinggi_badan,
                      name: 'Tinggi Badan',
                      // Enable data label
                      dataLabelSettings: DataLabelSettings(isVisible: true))
                ]),
                SfCartesianChart(
                    enableAxisAnimation: true,
                    primaryXAxis: CategoryAxis(
                      visibleMaximum: 5,
                    ),
                    primaryYAxis: NumericAxis(
                      numberFormat: NumberFormat('###.###'),
                      desiredIntervals: 5,
                      minimum: 0,
                      maximum: maxBeratValue + 10,
                      labelFormat: '{value} kg',
                    ),
                    title: ChartTitle(text: 'Berat Badan Anak', textStyle: TextStyle(fontWeight: FontWeight.bold)),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    zoomPanBehavior: _zoomPanBehavior,
                    series: <SplineSeries<PerkembanganModel, String>>[
                      SplineSeries<PerkembanganModel, String>(
                          markerSettings: MarkerSettings(
                            isVisible: true,
                            shape: DataMarkerType.circle,
                            height: 7,
                            width: 7,
                          ),
                          color: primaryColor,
                          dataSource: dataPerkembangan,
                          xValueMapper: (PerkembanganModel perkembangan, _) => "${perkembangan.bulan}\n${perkembangan.tahun}",
                          yValueMapper: (PerkembanganModel perkembangan, _) => perkembangan.berat_badan,
                          name: 'Berat Badan',
                          // Enable data label
                          dataLabelSettings: DataLabelSettings(isVisible: true))
                    ]),
              ]
          ),
        )
    );
  }

  showMessage(String text) async{
    await Future.delayed(Duration(seconds: 0));
    return QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      confirmBtnColor: primaryColor,
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
}