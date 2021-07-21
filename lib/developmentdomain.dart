import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:growth_app/model/development_domain.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/development_domain_card.dart';
import 'components/milk_card.dart';

class DevelopmentDomainPage extends StatefulWidget {
  @override
  _DevelopmentDomainPageState createState() => _DevelopmentDomainPageState();
}

class _DevelopmentDomainPageState extends State<DevelopmentDomainPage> {
  final _formKey = GlobalKey<FormState>();

  bool isAdmin = false;
  String _title = '';
  String _description = '';

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _domainPost =
      FirebaseFirestore.instance.collection('developmentdomain');

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
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
                child: Text("Development Domain",
                    style: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ))),
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
                  child: StreamBuilder(
                    stream: _domainPost.snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData)
                        return new Text("There are no records.");
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return Center(child: CircularProgressIndicator());
                      List devDomainList = snapshot.data!.docs;
                      List<DevelopmentDomain> _records = devDomainList
                          .map(
                            (devDomainPost) => DevelopmentDomain(
                                title: devDomainPost['title'],
                                description: devDomainPost['description']),
                          )
                          .toList();
                      return ListView.builder(
                        padding:
                            const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 60.0),
                        itemCount: snapshot.data!.size,
                        itemBuilder: (context, index) {
                          return DevelopmentDomainCard(
                            developmentDomainRecord: _records[index],
                          );
                        },
                      );
                    },
                  )),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                heroTag: "add",
                child: Icon(Icons.add),
                backgroundColor: Color(0xff4C52A8),
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Enter new Development Domain'),
                          content: Stack(
                            overflow: Overflow.visible,
                            children: <Widget>[
                              Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          border: new OutlineInputBorder(
                                            borderRadius: const BorderRadius.all(
                                              const Radius.circular(25),
                                            ),
                                          ),
                                          fillColor: Colors.red,
                                          labelText: 'Title',
                                        ),
                                        validator: (val) =>
                                            val!.isEmpty ? 'Enter a Title' : null,
                                        onChanged: (val) {
                                          setState(() => _title = val);
                                        },
                                        controller: _titleController,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          border: new OutlineInputBorder(
                                            borderRadius: const BorderRadius.all(
                                              const Radius.circular(25),
                                            ),
                                          ),
                                          fillColor: Colors.red,
                                          labelText: 'Description',
                                        ),
                                        validator: (val) => val!.isEmpty
                                            ? 'Enter a description'
                                            : null,
                                        onChanged: (val) {
                                          setState(() => _description = val);
                                        },
                                        controller: _descriptionController,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.deepPurple,
                                          minimumSize: Size(200, 50),
                                          //shape: shape,
                                        ),
                                        child: Text("Submit"),
                                        onPressed: () async {
                                          if (_formKey.currentState!.validate()) {
                                            _addData();
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isAdmin = prefs.getBool('admin')!;
    });
  }

  void _addData() {
    _domainPost.add({
      "title": _titleController.text,
      "description": _descriptionController.text,
    }).then((_) {
      print("success!");
    });

    Navigator.pop(context);
    setState(() {
      _titleController.clear();
      _descriptionController.clear();
    });
  }
}
