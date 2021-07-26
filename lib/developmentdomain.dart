import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:growth_app/model/development_domain.dart';
import 'package:growth_app/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/development_domain_card.dart';

class DevelopmentDomainPage extends StatefulWidget {
  @override
  _DevelopmentDomainPageState createState() => _DevelopmentDomainPageState();
}

///  Development Domain Page State for displaying development domain posts.
class _DevelopmentDomainPageState extends State<DevelopmentDomainPage> {
  /// variables
  bool _isAdmin = false;
  String _title = '';
  String _description = '';
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _domainPost =
      FirebaseFirestore.instance.collection('developmentdomain');
  final _formKey = GlobalKey<FormState>();

  /// to ensure certain function is execute before page load for certain data
  @override
  void initState() {
    _checkAdmin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: mainTheme,
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: <Widget>[

            Positioned(
              top: 70,
              left: 10,
              child: IconButton(
                onPressed: (){
                  Navigator.pop(context);
                }, icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              ),



            ),

            Positioned(
                top: 150,
                left: 50,
                child: TextButton(
                  child: new Text(
                    "Milestone Guidance",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/milestoneGuideline');
                  },
                )),
            Positioned(
                top: 80,
                left: 50,
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

                      /// creating a list of DevelopmentDomain Objects
                      List<DevelopmentDomain> _records = devDomainList
                          .map(
                            (devDomainPost) => DevelopmentDomain(
                                id: devDomainPost.id,
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
                            isAdmin: _isAdmin,
                          );
                        },
                      );
                    },
                  )),
            ),
            !_isAdmin
                ? const SizedBox.shrink()
                : Positioned(
                    bottom: 20,
                    right: 20,
                    child: FloatingActionButton(
                      heroTag: "add",
                      child: Icon(Icons.add),
                      backgroundColor: mainTheme,
                      onPressed: () async {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title:
                                    const Text('Enter new Development Domain'),
                                content: Stack(
                                  overflow: Overflow.visible,
                                  children: <Widget>[
                                    Form(
                                      key: _formKey,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          TextFormField(
                                            decoration: InputDecoration(
                                              border: new OutlineInputBorder(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  const Radius.circular(25),
                                                ),
                                              ),
                                              fillColor: secondaryTheme,
                                              labelText: 'Title',
                                            ),
                                            validator: (val) => val!.isEmpty
                                                ? 'Enter a Title'
                                                : null,
                                            onChanged: (val) {
                                              setState(() => _title = val);
                                            },
                                            controller: _titleController,
                                          ),
                                          SizedBox(height: 10),
                                          TextFormField(
                                              decoration: InputDecoration(
                                                border: new OutlineInputBorder(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    const Radius.circular(25),
                                                  ),
                                                ),
                                                fillColor: secondaryTheme,
                                                labelText: 'Description',
                                              ),
                                              validator: (val) => val!.isEmpty
                                                  ? 'Enter a description'
                                                  : null,
                                              onChanged: (val) {
                                                setState(
                                                    () => _description = val);
                                              },
                                              controller:
                                                  _descriptionController,
                                              maxLines: 5,
                                              minLines: 3),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: <Widget>[
                                                ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary: secondaryTheme,
                                                    ),
                                                    child: Text('Cancel'),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    }),
                                                SizedBox(width: 20),
                                                ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary: mainTheme,
                                                    ),
                                                    child: Text('Submit'),
                                                    onPressed: () {
                                                      if (_formKey.currentState!
                                                          .validate()) {
                                                        _addData();
                                                      }
                                                    }),
                                              ]),
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

  /// Function is for checking whether user type is an admin
  ///
  /// Function will use [_isAdmin] variable to true or false based on the database data retrieved
  void _checkAdmin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isAdmin = prefs.getBool('admin')!;
    });
  }

  /// Function for adding new Development Domain Post Data
  void _addData() {
    _domainPost.add({
      "title": _titleController.text,
      "description": _descriptionController.text,
    });

    Navigator.pop(context);
    setState(() {
      _titleController.clear();
      _descriptionController.clear();
    });
  }
}
