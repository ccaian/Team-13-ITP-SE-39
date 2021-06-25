import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:growth_app/addmeasurements.dart';


class GrowthPage extends StatefulWidget{
  @override
  _GrowthPageState createState() => _GrowthPageState();
}

class _GrowthPageState extends State<GrowthPage> {

  late Query _ref;
  DatabaseReference reference = FirebaseDatabase.instance.reference().child('growth');

  @override
  void initState() {
    super.initState();
    _ref = FirebaseDatabase.instance.reference().child('growth').orderByChild('date');
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Container(
          color: Color(0xff4C52A8),
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: <Widget>[
              Positioned(
                  top: 80,
                  left: 30,
                  child: Text(
                      "Baby Name",
                      style: TextStyle(
                        fontSize: 26.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      )
                  )
              ),
              Positioned(
                top: 40,
                right: -10,
                child: new Image.asset('assets/milkbottle.png', width: 140.0),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.7,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(

                        topRight: Radius.circular(25.0),
                        topLeft: Radius.circular(25.0)),
                  ),
                  child: Stack(
                    children: <Widget>[
                      const SizedBox(height: 100),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                          child: FirebaseAnimatedList(
                              query: _ref,
                              itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                                Map growth = snapshot.value;
                                growth['key'] = snapshot.key;
                                return _buildGrowthItem(growth: growth);
                              }
                          )
                        // child: DataTable(
                        //   columnSpacing: 40.0,
                        //   columns: const <DataColumn>[
                        //     DataColumn(
                        //       label: Text(
                        //         'Date',
                        //         style: TextStyle(fontStyle: FontStyle.italic),
                        //       ),
                        //     ),
                        //     DataColumn(
                        //       label: Text(
                        //         'Weight',
                        //         style: TextStyle(fontStyle: FontStyle.italic),
                        //       ),
                        //     ),
                        //     DataColumn(
                        //       label: Text(
                        //         'Height',
                        //         style: TextStyle(fontStyle: FontStyle.italic),
                        //       ),
                        //     ),
                        //     DataColumn(
                        //       label: Text(
                        //         'Head',
                        //         style: TextStyle(fontStyle: FontStyle.italic),
                        //       ),
                        //     ),
                        //   ],
                        //   rows: const <DataRow>[
                        //     DataRow(
                        //       cells: <DataCell>[
                        //         DataCell(Text('16-06-2021')),
                        //         DataCell(Text('10 kg')),
                        //         DataCell(Text('20 cm')),
                        //         DataCell(Text('30 cm')),
                        //       ],
                        //     ),
                        //     DataRow(
                        //       cells: <DataCell>[
                        //         DataCell(Text('18-06-2021')),
                        //         DataCell(Text('30 kg')),
                        //         DataCell(Text('40 cm')),
                        //         DataCell(Text('50 cm')),
                        //       ],
                        //     ),
                        //     DataRow(
                        //       cells: <DataCell>[
                        //         DataCell(Text('18-06-2021')),
                        //         DataCell(Text('30.1 kg')),
                        //         DataCell(Text('20.1 cm')),
                        //         DataCell(Text('10.1 cm')),
                        //       ],
                        //     ),
                        //   ],
                        // )
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton(
                  child: Icon(Icons.add),
                  backgroundColor: Color(0xff4C52A8),
                  onPressed: () async {
                    Navigator.push(context, new MaterialPageRoute(
                        builder: (context) => AddMeasurements()
                    ));
                  },
                ),
              ),
            ],
          ),
        )
    );
  }
}

Widget _buildGrowthItem({required Map growth}) {
  return Container(
    margin: EdgeInsets.symmetric(),
    padding: EdgeInsets.all(10),
    height: 80,
    color: Colors.white,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(width: 30),
            Text(
              growth['date'],
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(width: 30),
            Text(
              "Weight: " + growth['weight'] + "kg, ",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black),
            ),
            Text(
              "Height: " + growth['height'] + "cm, ",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black),
            ),
            Text(
              "Head: " + growth['head'] + "cm",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black),
            ),
          ]
        ),
      ],
    ),
  );
}

