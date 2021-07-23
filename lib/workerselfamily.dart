import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:growth_app/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkerSelFamily extends StatefulWidget {
  @override
  _WorkerSelFamilyState createState() => _WorkerSelFamilyState();
}

class _WorkerSelFamilyState extends State<WorkerSelFamily> {
  List<String> litems = [];
  List userData = [];
  List babyData = [];
  List userKeyList = [];
  List listTileChild = [];
  Map keyMap = Map<String, String>();
  List testList = [];
  List parentEmailList = [];
  List<String> listOfChildrenNRIC = [];
  List<String> babyNameList = [];

  String selectedChildNRIC = '';
  TextEditingController _searchControl = TextEditingController();

  final _userRef = FirebaseDatabase.instance.reference().child('user');

  @override
  void initState() {
    makeList();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: mainTheme,
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
              child: Column(
                children: <Widget>[
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.7,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(25.0),
                            topLeft: Radius.circular(25.0)),
                      ),
                      child: Scaffold(
                          body: Container(
                        child: Column(
                          children: <Widget>[
                            Padding(padding: EdgeInsets.only(top: 10)),
                            TextFormField(
                              decoration: InputDecoration(
                                fillColor: Colors.grey,
                                border: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(25),
                                  ),
                                ),
                                labelText: 'Search',
                              ),
                              controller: _searchControl,
                              onFieldSubmitted: (val) {
                                searchBarList(_searchControl.text);
                              },
                            ),
                            Expanded(
                                child: new ListView.builder(
                                    padding: const EdgeInsets.all(8),
                                    itemCount: litems.length,
                                    itemBuilder:
                                        (BuildContext ctxt, int index) {
                                      testList = validateChildren(
                                          parentEmailList[index]);
                                      return new GestureDetector(
                                        //You need to make my child interactive

                                        child: new Column(
                                          children: <Widget>[
                                            //new Image.network(video[index]),
                                            new Padding(
                                                padding:
                                                    new EdgeInsets.all(16.0)),
                                            buildText(index, testList),
                                          ],
                                        ),
                                      );
                                      //new Text(litems[index]);
                                    })),
                            new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                      child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        80.0, 0, 80.0, 20.0),
                                  ))
                                ]),
                          ],
                        ),
                      ))),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildText(int items, List babyNRICList) {
    String parentEmail = parentEmailList[items].toString();

    return Card(
      child: ExpansionTile(
        title: Text(
          litems[items] + " Family",
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
        ),
        /*trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
          IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                //   _onDeleteItemPressed(index);
                deleteUser(parentEmailList[items]);
                setState(() {
                  litems.removeAt(items);
                  litems.join(', ');
                });
              })
        ]),*/
        children: [
          for (var i = 0; i < babyNRICList.length; i++)
            newTile(babyNRICList[i], items)
        ],
      ),
    );
  }

  List validateChildren(String parentEmail) {
    List listOfChildrenEmail = [];
    for (var i = 0; i < babyData.length; i++) {
      if (parentEmail == babyData[i]["parent"]) {
        listOfChildrenEmail.add(babyData[i]["nric"].toString());
      }
    }
    if (listOfChildrenEmail.length == 0) {
      listOfChildrenEmail.add('No Children');
    }
    return listOfChildrenEmail;
  }

  newTile(String title, int index) {
    String babyTitle = '';
    babyTitle = getBabyName(title);
    if (babyTitle == 'No Children') {
      return new ListTile(
        title: Text(
          babyTitle,
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        onTap: () {},
      );
    } else {
      return new ListTile(
        title: Text(
          babyTitle,
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        onTap: () async {
          final SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          sharedPreferences.setString('Fam', litems[index]);
          sharedPreferences.setString('parentemail', parentEmailList[index]);
          sharedPreferences.setString('ChildNRIC', title);
          sharedPreferences.setString('ChildName', babyTitle);

          Navigator.of(context).pushNamed("/homePage");
        },
      );
    }
  }

  makeList() {
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
        if (value['admin'] == false) {
          newList.add(value['firstName'].toString() +
              " " +
              value['lastName'].toString());
          temp.add(value);
        }
      });
      setState(() {
        litems = newList;
        userData = temp;
      });
    });
    getChildParentEmail();
  }

  makeKeyList() {
    FirebaseDatabase.instance
        .reference()
        .child("user")
        .orderByChild("email")
        .once()
        .then((DataSnapshot snapshot) {
      //here i iterate and create the list of objects
      Map<dynamic, dynamic> childMap = snapshot.value;
      childMap.forEach((key, value) {
        if (value['admin'] == false) {
          keyMap[value['email'].toString()] = key;
        }
      });
      setState(() {
        keyMap = keyMap;
      });
    });
  }

  getChildParentEmail() {
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
        temp.add(value);
      });
      setState(() {
        babyData = temp;
      });
    });
    getParentEmail();
  }

  getParentEmail() {
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
        if (value['admin'] == false) {
          tempList.add(value['email'].toString());
        }
      });
      setState(() {
        parentEmailList = tempList;
      });
    });
    getChildNRICList();
  }

  getChildNRICList() {
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
    makeKeyList();
  }

  String getBabyName(String babyNRIC) {
    String babyName = '';
    for (var i = 0; i < babyData.length; i++) {
      if (babyNRIC == babyData[i]["nric"].toString()) {
        babyName = babyData[i]["name"].toString();
      }
    }
    if (babyName == '') {
      babyName = 'No Children';
    }
    return babyName;
  }

  searchBarList(search) {
    setState(() {
      litems = [];
      testList = [];
      parentEmailList = [];
    });
    for (var i = 0; i < userData.length; i++) {
      if (search.toUpperCase() ==
          userData[i]["firstName"].toString().toUpperCase()) {
        setState(() {
          litems.add(userData[i]["firstName"].toString() +
              ' ' +
              userData[i]["lastName"].toString());
          parentEmailList.add(userData[i]["email"]);
        });
      } else if (search == '') {
        makeList();
      }
    }
  }

  /*void deleteUser(String email) async {
    var tempKey;
    keyMap.forEach((key, value) {
      if (email == key) {
        tempKey = value;
      }
    });
    await _userRef.child(tempKey).remove().then((_) async {
    });
    *//*await FirebaseAuth.instance.currentUser!.delete().then((_) async {
        print('Account Deleted');
      });*//*
  }*/
}
