import 'package:flutter/material.dart';
import 'package:growth_app/model/fenton_chart_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:growth_app/theme/colors.dart';

/// FentonChart exist to improve user experience by creating a visualisation
/// of data for the Growth Parameter input by parents or healthcare workers.
class FentonChart extends StatelessWidget {
  /// Three key object arrays [weightArray], [heightArray] and [headArray] are
  /// data parse in that are retrived from firestore. the respective arrays
  /// are used to populate the visualisation charts.
  const FentonChart(
      {Key? key,
      required this.weightArray,
      required this.heightArray,
      required this.headArray,
      required this.gender})
      : super(key: key);

  /// initialisation of respective object arrays
  final List<WeightChart> weightArray;
  final List<HeightChart> heightArray;
  final List<HeadChart> headArray;
  final String gender;

  @override
  Widget build(BuildContext context) {
    String gender = 'male';
    final List<HeadChart> femaleHeadThirdPercentile = [
      HeadChart(
        weekNumber: 23,
        headData: 18.7,
      ),
    ];

    return SafeArea(
        child: Container(
            child: DefaultTabController(
                length: 3,
                child: Scaffold(
                  appBar: AppBar(
                      backgroundColor: mainTheme,
                      bottom: TabBar(
                        indicatorColor: secondaryTheme,
                        indicatorWeight: 5,
                        tabs: [
                          Tab(
                              text: 'Weight',
                              icon: Icon(Icons.airline_seat_flat)),
                          Tab(text: 'Height', icon: Icon(Icons.person)),
                          Tab(text: 'Head', icon: Icon(Icons.child_care)),
                        ],
                      ),
                      title: const Text("Fenton Chart")),
                  body: TabBarView(
                    children: [
                      Center(
                          child: Container(
                              child: SfCartesianChart(
                                  title: ChartTitle(text: 'Weight Chart'),
                                  legend: Legend(isVisible: true),
                                  primaryXAxis: NumericAxis(
                                      edgeLabelPlacement:
                                          EdgeLabelPlacement.shift),
                                  series: <ChartSeries>[
                            // Renders spline chart
                            SplineSeries<WeightChart, int>(
                              name: "Actual Weight Data",
                              dataSource: this.weightArray,
                              xValueMapper: (WeightChart week, _) =>
                                  week.weekNumber,
                              yValueMapper: (WeightChart week, _) =>
                                  week.weightData,
                              dataLabelSettings: DataLabelSettings(
                                  isVisible: true,
                                  labelAlignment: ChartDataLabelAlignment.top,
                                  textStyle:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),

                            /// Renders 3rd percentile data spline chart
                            generateWeight3Percentile(this.gender),

                            /// Renders 10th percentile data spline chart
                            generateWeight10Percentile(this.gender),

                            /// Renders 50th percentile data spline chart
                            generateWeight50Percentile(this.gender),

                            /// Renders 90th percentile data spline chart
                            generateWeight90Percentile(this.gender),

                            /// Renders 97th percentile data spline chart
                            generateWeight97Percentile(this.gender)
                          ]))),
                      Center(
                          child: Container(
                              child: SfCartesianChart(
                                  title: ChartTitle(text: 'Height Chart'),
                                  legend: Legend(isVisible: true),
                                  primaryXAxis: NumericAxis(
                                      edgeLabelPlacement:
                                          EdgeLabelPlacement.shift),
                                  series: <ChartSeries>[
                            // Renders spline chart
                            SplineSeries<HeightChart, int>(
                              name: "Actual Height Data",
                              dataSource: this.heightArray,
                              xValueMapper: (HeightChart week, _) =>
                                  week.weekNumber,
                              yValueMapper: (HeightChart week, _) =>
                                  week.heightData,
                              dataLabelSettings: DataLabelSettings(
                                  isVisible: true,
                                  labelAlignment: ChartDataLabelAlignment.top,
                                  textStyle:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),

                            /// Renders 3rd percentile data spline chart
                            generateHeight3Percentile(this.gender),

                            /// Renders 10th percentile data spline chart
                            generateHeight10Percentile(this.gender),

                            /// Renders 50th percentile data spline chart
                            generateHeight50Percentile(this.gender),

                            /// Renders 90th percentile data spline chart
                            generateHeight90Percentile(this.gender),

                            /// Renders 97th percentile data spline chart
                            generateHeight97Percentile(this.gender)
                          ]))),
                      Center(
                          child: Container(
                              child: SfCartesianChart(
                                  title: ChartTitle(
                                      text: 'Head Circumference Chart'),
                                  legend: Legend(isVisible: true),
                                  primaryXAxis: NumericAxis(
                                      edgeLabelPlacement:
                                          EdgeLabelPlacement.shift),
                                  series: <ChartSeries>[
                            /// Renders actual head circumference spline chart
                            SplineSeries<HeadChart, int>(
                              name: "Actual Head Circumference Data",
                              dataSource: this.headArray,
                              xValueMapper: (HeadChart week, _) =>
                                  week.weekNumber,
                              yValueMapper: (HeadChart week, _) =>
                                  week.headData,
                              dataLabelSettings: DataLabelSettings(
                                  isVisible: true,
                                  labelAlignment: ChartDataLabelAlignment.top,
                                  textStyle:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),

                            /// Renders 3rd percentile data spline chart
                            generateHead3Percentile(this.gender),

                            /// Renders 10th percentile data spline chart
                            generateHead10Percentile(this.gender),

                            /// Renders 50th percentile data spline chart
                            generateHead50Percentile(this.gender),

                            /// Renders 90th percentile data spline chart
                            generateHead90Percentile(this.gender),

                            /// Renders 97th percentile data spline chart
                            generateHead97Percentile(this.gender)
                          ]))),
                    ],
                  ),
                ))));
  }

  generateWeight97Percentile(String gender) {
    if (gender == "male") {
      return SplineSeries<WeightChart, int>(
        name: "97th Percentile",
        dataSource: this.weightArray, // CHANGE TO maleW97Percent array when added in
        xValueMapper: (WeightChart week, _) => week.weekNumber,
        yValueMapper: (WeightChart week, _) => week.weightData,
      );
    } else {
      return SplineSeries<WeightChart, int>(
        name: "97th Percentile",
        dataSource: this.weightArray, // CHANGE TO femaleW97Percent array when added in
        xValueMapper: (WeightChart week, _) => week.weekNumber,
        yValueMapper: (WeightChart week, _) => week.weightData,
      );
    }
  }

  generateWeight90Percentile(String gender) {
    if (gender == "male") {
      return SplineSeries<WeightChart, int>(
        name: "90th Percentile",
        dataSource: this.weightArray, // CHANGE TO maleW90Percent array when added in
        xValueMapper: (WeightChart week, _) => week.weekNumber,
        yValueMapper: (WeightChart week, _) => week.weightData,
      );
    } else {
      return SplineSeries<WeightChart, int>(
        name: "90th Percentile",
        dataSource: this.weightArray, // CHANGE TO femaleW90Percent array when added in
        xValueMapper: (WeightChart week, _) => week.weekNumber,
        yValueMapper: (WeightChart week, _) => week.weightData,
      );
    }
  }

  generateWeight50Percentile(String gender) {
    if (gender == "male") {
      return SplineSeries<WeightChart, int>(
        name: "50th Percentile",
        dataSource: this.weightArray, // CHANGE TO maleW50Percent array when added in
        xValueMapper: (WeightChart week, _) => week.weekNumber,
        yValueMapper: (WeightChart week, _) => week.weightData,
      );
    } else {
      return SplineSeries<WeightChart, int>(
        name: "50th Percentile",
        dataSource: this.weightArray, // CHANGE TO femaleW50Percent array when added in
        xValueMapper: (WeightChart week, _) => week.weekNumber,
        yValueMapper: (WeightChart week, _) => week.weightData,
      );
    }
  }

  generateWeight10Percentile(String gender) {
    if (gender == "male") {
      return SplineSeries<WeightChart, int>(
        name: "10th Percentile",
        dataSource: this.weightArray, // CHANGE TO maleW10Percent array when added in
        xValueMapper: (WeightChart week, _) => week.weekNumber,
        yValueMapper: (WeightChart week, _) => week.weightData,
      );
    } else {
      return SplineSeries<WeightChart, int>(
        name: "10th Percentile",
        dataSource: this.weightArray, // CHANGE TO femaleW10Percent array when added in
        xValueMapper: (WeightChart week, _) => week.weekNumber,
        yValueMapper: (WeightChart week, _) => week.weightData,
      );
    }
  }

  generateWeight3Percentile(String gender) {
    if (gender == "male") {
      return SplineSeries<WeightChart, int>(
        name: "3th Percentile",
        dataSource: this.weightArray, // CHANGE TO maleW5Percent array when added in
        xValueMapper: (WeightChart week, _) => week.weekNumber,
        yValueMapper: (WeightChart week, _) => week.weightData,
      );
    } else {
      return SplineSeries<WeightChart, int>(
        name: "3th Percentile",
        dataSource: this.weightArray, // CHANGE TO femaleW5Percent array when added in
        xValueMapper: (WeightChart week, _) => week.weekNumber,
        yValueMapper: (WeightChart week, _) => week.weightData,
      );
    }
  }
  ///
  ///  @LINUS REMEMBER TO CHANGE THE REST TO THE PROPER ARRAYS. THANKS
  ///

  generateHead97Percentile(String gender) {
    if (gender == "male") {
      return SplineSeries<HeadChart, int>(
        name: "97th Percentile",
        dataSource: this.headArray,
        xValueMapper: (HeadChart week, _) => week.weekNumber,
        yValueMapper: (HeadChart week, _) => week.headData,
      );
    } else {
      return SplineSeries<HeadChart, int>(
        name: "97th Percentile",
        dataSource: this.headArray,
        xValueMapper: (HeadChart week, _) => week.weekNumber,
        yValueMapper: (HeadChart week, _) => week.headData,
      );
    }
  }

  generateHead90Percentile(String gender) {
    if (gender == "male") {
      return SplineSeries<HeadChart, int>(
        name: "90th Percentile",
        dataSource: this.headArray,
        xValueMapper: (HeadChart week, _) => week.weekNumber,
        yValueMapper: (HeadChart week, _) => week.headData,
      );
    } else {
      return SplineSeries<HeadChart, int>(
        name: "90th Percentile",
        dataSource: this.headArray,
        xValueMapper: (HeadChart week, _) => week.weekNumber,
        yValueMapper: (HeadChart week, _) => week.headData,
      );
    }
  }

  generateHead50Percentile(String gender) {
    if (gender == "male") {
      return SplineSeries<HeadChart, int>(
        name: "50th Percentile",
        dataSource: this.headArray,
        xValueMapper: (HeadChart week, _) => week.weekNumber,
        yValueMapper: (HeadChart week, _) => week.headData,
      );
    } else {
      return SplineSeries<HeadChart, int>(
        name: "50th Percentile",
        dataSource: this.headArray,
        xValueMapper: (HeadChart week, _) => week.weekNumber,
        yValueMapper: (HeadChart week, _) => week.headData,
      );
    }
  }

  generateHead10Percentile(String gender) {
    if (gender == "male") {
      return SplineSeries<HeadChart, int>(
        name: "10th Percentile",
        dataSource: this.headArray,
        xValueMapper: (HeadChart week, _) => week.weekNumber,
        yValueMapper: (HeadChart week, _) => week.headData,
      );
    } else {
      return SplineSeries<HeadChart, int>(
        name: "10th Percentile",
        dataSource: this.headArray,
        xValueMapper: (HeadChart week, _) => week.weekNumber,
        yValueMapper: (HeadChart week, _) => week.headData,
      );
    }
  }

  generateHead3Percentile(String gender) {
    if (gender == "male") {
      return SplineSeries<HeadChart, int>(
        name: "3rd Percentile",
        dataSource: this.headArray,
        xValueMapper: (HeadChart week, _) => week.weekNumber,
        yValueMapper: (HeadChart week, _) => week.headData,
      );
    } else {
      return SplineSeries<HeadChart, int>(
        name: "3rd Percentile",
        dataSource: this.headArray,
        xValueMapper: (HeadChart week, _) => week.weekNumber,
        yValueMapper: (HeadChart week, _) => week.headData,
      );
    }
  }
  generateHeight97Percentile(String gender) {
    if (gender == "male") {
      return SplineSeries<HeightChart, int>(
        name: "97th Percentile",
        dataSource: this.heightArray,
        xValueMapper: (HeightChart week, _) => week.weekNumber,
        yValueMapper: (HeightChart week, _) => week.heightData,
      );
    } else {
      return SplineSeries<HeightChart, int>(
        name: "97th Percentile",
        dataSource: this.heightArray,
        xValueMapper: (HeightChart week, _) => week.weekNumber,
        yValueMapper: (HeightChart week, _) => week.heightData,
      );
    }
  }
  generateHeight90Percentile(String gender) {
    if (gender == "male") {
      return SplineSeries<HeightChart, int>(
        name: "90 Percentile",
        dataSource: this.heightArray,
        xValueMapper: (HeightChart week, _) => week.weekNumber,
        yValueMapper: (HeightChart week, _) => week.heightData,
      );
    } else {
      return SplineSeries<HeightChart, int>(
        name: "90 Percentile",
        dataSource: this.heightArray,
        xValueMapper: (HeightChart week, _) => week.weekNumber,
        yValueMapper: (HeightChart week, _) => week.heightData,
      );
    }
  }
  generateHeight50Percentile(String gender) {
    if (gender == "male") {
      return SplineSeries<HeightChart, int>(
        name: "50th Percentile",
        dataSource: this.heightArray,
        xValueMapper: (HeightChart week, _) => week.weekNumber,
        yValueMapper: (HeightChart week, _) => week.heightData,
      );
    } else {
      return SplineSeries<HeightChart, int>(
        name: "50th Percentile",
        dataSource: this.heightArray,
        xValueMapper: (HeightChart week, _) => week.weekNumber,
        yValueMapper: (HeightChart week, _) => week.heightData,
      );
    }
  }
  generateHeight10Percentile(String gender) {
    if (gender == "male") {
      return SplineSeries<HeightChart, int>(
        name: "10th Percentile",
        dataSource: this.heightArray,
        xValueMapper: (HeightChart week, _) => week.weekNumber,
        yValueMapper: (HeightChart week, _) => week.heightData,
      );
    } else {
      return SplineSeries<HeightChart, int>(
        name: "10th Percentile",
        dataSource: this.heightArray,
        xValueMapper: (HeightChart week, _) => week.weekNumber,
        yValueMapper: (HeightChart week, _) => week.heightData,
      );
    }
  }

  generateHeight3Percentile(String gender) {
    if (gender == "male") {
      return SplineSeries<HeightChart, int>(
        name: "3rd Percentile",
        dataSource: this.heightArray,
        xValueMapper: (HeightChart week, _) => week.weekNumber,
        yValueMapper: (HeightChart week, _) => week.heightData,
      );
    } else {
      return SplineSeries<HeightChart, int>(
        name: "3rd Percentile",
        dataSource: this.heightArray,
        xValueMapper: (HeightChart week, _) => week.weekNumber,
        yValueMapper: (HeightChart week, _) => week.heightData,
      );
    }
  }
}
