import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:growth_app/addmeasurements.dart';
import 'package:growth_app/nav.dart';



class GrowthPage extends StatefulWidget{
  @override
  _GrowthPageState createState() => _GrowthPageState();
}

class _GrowthPageState extends State<GrowthPage> {

  // String date = '';
  // double weight = 0;
  // double height = 0;
  // double head = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(

                      topRight: Radius.circular(25.0),
                      topLeft: Radius.circular(25.0)),
                ),
                child: Stack(
                  children: <Widget>[
                    const SizedBox(height: 30),
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 20),
                      ),
                      onPressed: () async {
                        Navigator.push(context, new MaterialPageRoute(
                            builder: (context) => AddMeasurements()
                        ));
                      },
                      child: const Text('   + Add Measurements'),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0,50.0,0.0,0.0),
                        child: DataTable (
                          columnSpacing: 40.0,
                          columns: const <DataColumn>[
                            DataColumn(
                              label: Text(
                                'Date',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Weight',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Height',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Head',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                          ],
                          rows: const <DataRow>[
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text('16-06-2021')),
                                DataCell(Text('10 kg')),
                                DataCell(Text('20 cm')),
                                DataCell(Text('30 cm')),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text('18-06-2021')),
                                DataCell(Text('30 kg')),
                                DataCell(Text('40 cm')),
                                DataCell(Text('50 cm')),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text('18-06-2021')),
                                DataCell(Text('30.1 kg')),
                                DataCell(Text('20.1 cm')),
                                DataCell(Text('10.1 cm')),
                              ],
                            ),
                          ],
                        )
                      // child: Expanded(
                      //   child:Container(
                      //   child: FutureBuilder<List<Growth>>(
                      //   future: firebaseCalls(databaseReference), // async work
                      //   // ignore: top_level_function_literal_block
                      //   builder: (BuildContext context, AsyncSnapshot snapshot) {
                      //     switch (snapshot.connectionState) {
                      //       case ConnectionState.none: return new Text('Press button to start');
                      //       case ConnectionState.waiting: return new Text('Loading....');
                      //       default:
                      //         if (snapshot.hasError)
                      //           return new Text('Error: ${snapshot.error}');
                      //         else
                      //           return ListView.builder(
                      //             itemCount: snapshot.data.length,
                      //             itemBuilder: (BuildContext context, int index){
                      //               return Card(
                      //                 elevation: 0.0,
                      //                 child: Padding(
                      //                   padding: const EdgeInsets.all(0.0),
                      //                   child:  SizedBox(
                      //                       height: MediaQuery.of(context).size.height*0.15,
                      //                       width: MediaQuery.of(context).size.width,
                      //                       child:  Card(
                      //                           elevation: 0,
                      //                           child: Row(
                      //                             children: <Widget>[
                      //                               new Container(
                      //                                 child: Image.network(snapshot.data[index].iconUrl,height: MediaQuery.of(context).size.width*0.3,width: MediaQuery.of(context).size.width*0.3,),
                      //                               ),
                      //                               Padding(
                      //                                 padding: const EdgeInsets.only(left: 10,right: 5,top: 5),
                      //                                 child: Column(
                      //                                   mainAxisAlignment: MainAxisAlignment.start,
                      //                                   children: <Widget>[
                      //                                     new Container(
                      //                                       child: Column(
                      //                                         mainAxisAlignment: MainAxisAlignment.start,
                      //                                         children: <Widget>[
                      //                                           Column(
                      //                                             mainAxisAlignment: MainAxisAlignment.start,
                      //                                             crossAxisAlignment: CrossAxisAlignment.start,
                      //                                             children: <Widget>[
                      //                                               Row(
                      //                                                 children: <Widget>[
                      //                                                   condition('${snapshot.data[index].vegOrNon}')==true? new Image.asset('images/non_veg.png',height: 15,width: 15,): new Image.asset('images/veg.jpg',height: 15,width: 15),
                      //                                                   SizedBox(width: 5),
                      //                                                   Text(snapshot.data[index].foodtitle, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20,fontFamily: 'Roboto-Black'),)
                      //                                                 ],
                      //                                               ),
                      //
                      //                                               SizedBox(height:10.0),
                      //                                               Row(
                      //                                                 children: <Widget>[
                      //                                                   new IconTheme(
                      //                                                     data: new IconThemeData(
                      //                                                         color: Colors.black26),
                      //                                                     child: new Icon(Icons.timer,size: 20.0,),
                      //                                                   ),
                      //                                                   Text('${snapshot.data[index].PreptimeInMins} minutes',style: TextStyle(fontWeight: FontWeight.w700,color: Colors.black26),),
                      //                                                 ],
                      //                                               ),
                      //                                             ],
                      //                                           )
                      //                                         ],
                      //                                       ),
                      //                                     ),
                      //                                   ],
                      //                                 ),
                      //                               ),
                      //
                      //                             ],
                      //                           )
                      //                       )
                      //
                      //
                      //                   ),
                      //                 ),
                      //               );
                      //             },
                      //           );
                      //     }
                      //   },
                      // );
                      //   ) ,
                      // ),
                      // child: FutureBuilder (
                      //   future: viewData(),
                      //   builder: (BuildContext context, AsyncSnapshot snapshot) {
                      //     if (snapshot.data == null) {
                      //       print("future builder:");
                      //       print(snapshot.data);
                      //       return Text('no data');
                      //     } else {
                      //       print('data present');
                      //       if(!snapshot.hasData) {
                      //         return Center(child: CircularProgressIndicator());
                      //       }
                      //       if(snapshot.hasData) {
                      //         return Column(
                      //           mainAxisSize: MainAxisSize.min,
                      //           mainAxisAlignment: MainAxisAlignment.center,
                      //           verticalDirection: VerticalDirection.down,
                      //           children: <Widget>[
                      //             Expanded(
                      //               child: Container(
                      //                   padding: EdgeInsets.all(5),
                      //                   child: dataBody(snapshot.data)
                      //               ),
                      //             )
                      //           ],
                      //         );
                      //       }
                      //       return Center();
                      //       }
                      //   }
                      // )
                      // child: StreamBuilder<QuerySnapshot> (
                      //   stream: growthRef,
                      //   builder: (context, snapshot) {
                      //     if (!snapshot.hasData) return LinearProgressIndicator();
                      //     return DataTable(
                      //     columns: [
                      //       DataColumn(label: Text('Date')),
                      //       DataColumn(label: Text('Weight')),
                      //       DataColumn(label: Text('Height')),
                      //       DataColumn(label: Text('Head')),
                      //     ],
                      //     rows: _buildList(context, snapshot.data!.docs)
                      //     );
                      //     },
                      // )
                    )
                  ],
                ),
            ),
          )
        ],
      ),
    );
  }

  // viewData() {
  //   growthRef.once().then((DataSnapshot snapshot){
  //     Map<dynamic, dynamic> data = snapshot.value;
  //     data.forEach((key,values) {
  //       print("view data");
  //       print(data.values);
  //     });
  //     return data.values;
  //     //print(values);
  //     //return values;
  //     //values.forEach((key,values) {
  //     //print(values);
  //     // print(values["date"]);
  //     // print(values["weight"]);
  //     // print(values["height"]);
  //     // print(values["head"]);
  //     //});
  //   });
  // }

  SingleChildScrollView dataBody(List<Growth> growthList) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        sortColumnIndex: 0,
        showCheckboxColumn: false,
        columns: [
          DataColumn(
              label: Text("Date"),
              numeric: false,
              tooltip: "Date"
          ),
          DataColumn(
            label: Text("Weight"),
            numeric: false,
            tooltip: "Weight",
          ),
          DataColumn(
            label: Text("Height"),
            numeric: false,
            tooltip: "Height",
          ),
          DataColumn(
            label: Text("Head"),
            numeric: false,
            tooltip: "Head",
          ),
        ],
        rows: growthList
            .map(
              (growth) => DataRow(
              cells: [
                DataCell(
                    Text(growth.date)
                ),
                DataCell(
                  Text(growth.weight.toString()),
                ),
                DataCell(
                  Text(growth.height.toString()),
                ),
                DataCell(
                  Text(growth.head.toString()),
                ),
              ]),
        )
            .toList(),
      ),
    );
  }

  // List<DataRow> _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
  //   return  snapshot.map((data) => _buildListItem(context, data)).toList();
  // }
  //
  // DataRow _buildListItem(BuildContext context, DocumentSnapshot data) {
  //   final growth = Growth.fromSnapshot(data);
  //
  //   return DataRow(cells: [
  //     DataCell(Text(growth.date)),
  //     DataCell(Text(growth.weight.toString())),
  //     DataCell(Text(growth.height.toString())),
  //     DataCell(Text(growth.head.toString())),
  //   ]);
  // }

  List<Growth> listItems=[];

  Future<List<Growth>> firebaseCalls (DatabaseReference databaseReference) async{
    GrowthList growthList;
    DataSnapshot dataSnapshot = await databaseReference.once();
    Map<dynamic,dynamic> jsonResponse=dataSnapshot.value[0]['growth'];
    growthList = new GrowthList.fromJSON(jsonResponse);
    listItems.addAll(growthList.growthList);

    return listItems;
  }
}

// class Growth {
//   final String date;
//   final double weight;
//   final double height;
//   final double head;
//   final DocumentReference reference;
//
//   Growth.fromMap(Map<dynamic, dynamic> map, {required this.reference})
//       : assert(map['date'] != null),
//         assert(map['weight'] != null),
//         assert(map['height'] != null),
//         assert(map['head'] != null),
//         date = map['date'],
//         weight = map['weight'],
//         height = map['height'],
//         head = map['head'];
//
//   Growth.fromSnapshot(DocumentSnapshot snapshot)
//       : this.fromMap(snapshot.data as Map<dynamic, dynamic>, reference: snapshot.reference);
//
//   @override
//   String toString() => "Growth<$date:$weight:$height:$head>";
// }

class Growth {
  String date;
  double weight, height, head;

  Growth({required this.date,required this.weight,required this.height,required this.head});

  factory Growth.fromJson(Map<dynamic,dynamic> parsedJson) {
    return Growth(date:parsedJson['date'],weight: parsedJson['weight'],height:parsedJson['height'],head: parsedJson['head']);
  }
}

class GrowthList{
  List<Growth> growthList;
  GrowthList({required this.growthList});

  final growthRef = FirebaseDatabase.instance.reference();
  //.child('growth')

  factory GrowthList.fromJSON(Map<dynamic,dynamic> json){
    return GrowthList(
        growthList: parsedata(json)
    );
    }

  static List<Growth> parsedata(growthJSON){
    var gList=growthJSON['growth'] as List;
    List<Growth> growthList=gList.map((data) => Growth.fromJson(data)).toList();  //Add this
    return growthList;
  }
}

// class MakeCall{
//   List<Growth> listItems=[];
//
//   Future<List<Growth>> firebaseCalls (DatabaseReference databaseReference) async{
//     GrowthList growthList;
//     DataSnapshot dataSnapshot = await databaseReference.once();
//     Map<dynamic,dynamic> jsonResponse=dataSnapshot.value[0]['growth'];
//     growthList = new GrowthList.fromJSON(jsonResponse);
//     listItems.addAll(growthList.growthList);
//
//     return listItems;
//   }
// }

