import 'package:flutter/material.dart';
import 'package:sikesdes/utils/colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class PerkembanganPage extends StatefulWidget {
  PerkembanganPage({Key? key}) : super(key: key);

  @override
  PerkembanganPageState createState() => PerkembanganPageState();
}

class PerkembanganPageState extends State<PerkembanganPage> {
  late ZoomPanBehavior _zoomPanBehavior;
  List<_SalesData> data = [
    _SalesData('Jan', 10),
    _SalesData('Feb', 11),
    _SalesData('Mar', 14),
    _SalesData('Apr', 16),
    _SalesData('May', 18),
    _SalesData('Jun', 10),
    _SalesData('Jul', 20),
    _SalesData('Agu', 80),
  ];


  @override
  void initState() {
    _zoomPanBehavior = ZoomPanBehavior(
        enablePanning: true,
        enablePinching: true,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double maxSalesValue = data.map((item) => item.sales).reduce((max, value) => max > value ? max : value);
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
                  numberFormat: NumberFormat('#'),
                  desiredIntervals: 5,
                  minimum: 0,
                  maximum: maxSalesValue + 10,
                  labelFormat: '{value} cm',
                ),
                title: ChartTitle(text: 'Tinggi Badan Anak',textStyle: TextStyle(fontWeight: FontWeight.bold)),
                tooltipBehavior: TooltipBehavior(enable: true),
                zoomPanBehavior: _zoomPanBehavior,
                series: <SplineSeries<_SalesData, String>>[
                  SplineSeries<_SalesData, String>(
                      markerSettings: MarkerSettings(
                        isVisible: true,
                        shape: DataMarkerType.circle,
                        height: 7,
                        width: 7,
                      ),
                      color: primaryColor,
                      dataSource: data,
                      xValueMapper: (_SalesData sales, _) => sales.year,
                      yValueMapper: (_SalesData sales, _) => sales.sales,
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
                      numberFormat: NumberFormat('#'),
                      desiredIntervals: 5,
                      minimum: 0,
                      maximum: maxSalesValue + 10,
                      labelFormat: '{value} kg',
                    ),
                    title: ChartTitle(text: 'Berat Badan Anak', textStyle: TextStyle(fontWeight: FontWeight.bold)),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    zoomPanBehavior: _zoomPanBehavior,
                    series: <SplineSeries<_SalesData, String>>[
                      SplineSeries<_SalesData, String>(
                          markerSettings: MarkerSettings(
                            isVisible: true,
                            shape: DataMarkerType.circle,
                            height: 7,
                            width: 7,
                          ),
                          color: primaryColor,
                          dataSource: data,
                          xValueMapper: (_SalesData sales, _) => sales.year,
                          yValueMapper: (_SalesData sales, _) => sales.sales,
                          name: 'Berat Badan',
                          // Enable data label
                          dataLabelSettings: DataLabelSettings(isVisible: true))
                    ]),
              ]
          ),
        )
    );
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}