import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:growth_app/nav.dart';
import 'package:growth_app/workerhome.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkerSelFamily extends StatefulWidget{

  @override
  _WorkerSelFamilyState createState() => _WorkerSelFamilyState();
}

class _WorkerSelFamilyState extends State<WorkerSelFamily> {
  List<String> litems = [];
  List userData = [];
  List babyData = [];
  List<String> childParentEmailList = [];
  List<String> parentEmailList = [];
  List<String> listOfChildrenNRIC = [];
  List<String> babyNameList = [];

  String selectedChildNRIC ='';
  @override
  void initState(){
    makeList();
    super.initState();
  }
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Color(0xff4C52A8),
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: <Widget>[
            Positioned(
                top: 80,
                left: 30,
                child: Text("Select Family",
                    style: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ))),
            Positioned(
              top: 40,
              right: -10,
              child: new Image.asset('assets/healthcare.png', width: 140.0),
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
                child: Scaffold(
                    body: new ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: litems.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          List testList = [];
                          testList = validateChildren(parentEmailList[index]);
                          print("print data: " + babyData[index].toString());
                          return new GestureDetector(
                            //You need to make my child interactive


                            child: new Column(
                              children: <Widget>[
                                //new Image.network(video[index]),
                                new Padding(padding: new EdgeInsets.all(16.0)),
                                buildText(index, testList),
                              ],
                            ),
                          );
                          //new Text(litems[index]);
                        })),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildText(int items, List babyNRICList) {
    String parentEmail = parentEmailList[items].toString();
    print("in BuildText: " + parentEmail);


    return Card(
      child: ExpansionTile(
        title: Text(
          litems[items] + " Family",
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
        ),
        children: [
      for(var i = 0; i < babyNRICList.length; i++)
        newTile(babyNRICList[i], items)
        ],
      ),
    );

  }

 List validateChildren(String parentEmail) {
    List listOfChildrenEmail =[];
    for(var i = 0; i < childParentEmailList.length; i++){
      if(parentEmail == babyData[i]["parent"]){
        print('in validate children: '+ parentEmail +' child email '+ babyData[i]["parent"]);
        listOfChildrenEmail.add(babyData[i]["nric"].toString());
      }
    }
    if (listOfChildrenEmail.length == 0){
      listOfChildrenEmail.add('No Children');
    }
    return listOfChildrenEmail;
}

  newTile(String title, int index){
    String babyTitle ='';
    babyTitle = getBabyName(title);
      return new ListTile(
        title: Text(
          babyTitle,
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        onTap: () async{
          final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          sharedPreferences.setString('Fam',litems[index]);
          sharedPreferences.setString('ChildNRIC',title);
          sharedPreferences.setString('ChildName',babyTitle);

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Nav())).then((value) => setState( () {} ));
        },
      );

}

  makeList(){
    List<String> newList = [];
    List temp = [];
    FirebaseDatabase.instance
        .reference()
        .child("user")
        .orderByChild("email")
        .once()
        .then((DataSnapshot snapshot) {
      //here i iterate and create the list of objects
      Map<dynamic, dynamic> childMap = snapshot.value;
      childMap.forEach((key, value) {
        if(value['admin']==false){
          newList.add(value['firstName'].toString() + " " + value['lastName'].toString());
          temp.add(value);
        }

      });
      print(newList);
      setState(() {
        litems = newList;
        userData = temp;
      });
    });
      getChildParentEmail();
  }

  getChildParentEmail(){
    List<String> tempList = [];
    List temp = [];
    FirebaseDatabase.instance
        .reference()
        .child("child")
        .orderByChild("parent")
        .once()
        .then((DataSnapshot snapshot) {
      //here i iterate and create the list of objects
      Map<dynamic, dynamic> childMap = snapshot.value;
      childMap.forEach((key, value) {
        tempList.add(value['parent'].toString());
        temp.add(value);
      });
      print('child List:');
      print(tempList);
      setState(() {
        childParentEmailList = tempList;
        babyData = temp;
      });
    });
    getParentEmail();
  }
  getParentEmail(){
    List<String> tempList = [];
    FirebaseDatabase.instance
        .reference()
        .child("user")
        .orderByChild("email")
        .once()
        .then((DataSnapshot snapshot) {
      //here i iterate and create the list of objects
      Map<dynamic, dynamic> childMap = snapshot.value;
      List temp = childMap.values.toList();
      childMap.forEach((key, value) {
        if(value['admin']==false){
          tempList.add(value['email'].toString());
        }
      });
      print('Parent List:');
      print(tempList);
      setState(() {
        parentEmailList = tempList;
      });
    });
    getChildNRICList();
  }
  getChildNRICList(){
    List<String> tempList = [];
    FirebaseDatabase.instance
        .reference()
        .child("child")
        .orderByChild("parent")
        .once()
        .then((DataSnapshot snapshot) {
      //here i iterate and create the list of objects
      Map<dynamic, dynamic> childMap = snapshot.value;
      List temp = childMap.values.toList();
      childMap.forEach((key, value) {
        tempList.add(value['nric'].toString());
      });
      setState(() {
        listOfChildrenNRIC = tempList;
      });
    });
  }

 String getBabyName( String babyNRIC) {
    String babyName = '';
    for(var i = 0; i < babyData.length; i++){
      if(babyNRIC == babyData[i]["nric"].toString()){
        babyName = babyData[i]["name"].toString();
      }
    }
    if(babyName == ''){
      babyName = 'No Children';
    }
    return babyName;
  }


}
