import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:growth_app/model/development_domain.dart';
import 'package:growth_app/theme/colors.dart';

class DevelopmentDomainCard extends StatelessWidget {
  final isAdmin;

  const DevelopmentDomainCard({
    Key? key,
    required this.developmentDomainRecord,
    required this.isAdmin,
  }) : super(key: key);

  final DevelopmentDomain developmentDomainRecord;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Container(
      padding: EdgeInsets.all(10),
      child: Column(children: <Widget>[
        Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          Expanded(
            child: Container(
              child: Text("Title: " + developmentDomainRecord.title,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ),
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          Expanded(
            child: Container(
              child:
                  Text("Description: \n" + developmentDomainRecord.description,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[700],
                      ),),
            ),
          ),
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          SizedBox(
            width: 0,
            height: 40,
          ),
          !isAdmin
              ? const SizedBox.shrink()
              : GestureDetector(
                  onTap: () {
                    updateDialog(context);
                    },
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit,
                        color: Theme.of(context).primaryColor,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text('Update',
                          style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
          SizedBox(
            width: 20,
            height: 40,
          ),
          !isAdmin
              ? const SizedBox.shrink()
              : GestureDetector(
                  onTap: () {
                    deleteDialog(context);
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete,
                        color: Colors.red[700],
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text('Delete',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.red[700],
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
        ]),
      ]),
    ));
  }



  void _updateData(String key, String title, String description) async {
    FirebaseFirestore.instance.collection('developmentdomain').doc(key).update({
      'title': title,
      'description': description
    });
  }

  void updateDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _titleController = TextEditingController(text: developmentDomainRecord.title);
    final _descriptionController = TextEditingController(text: developmentDomainRecord.description);
    String _title = '';
    String _description = '';

    var alert = AlertDialog(
      title:
      Text("Editing \"" + developmentDomainRecord.title+ "\" Development Domain"),
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
                    controller: _titleController,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
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
                    controller:
                    _descriptionController,
                    maxLines: 5,
                    minLines: 3
                  ),
                ),
                Row(mainAxisAlignment:
                MainAxisAlignment.end,
                  children: <Widget>[
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: secondaryTheme,
                      ),
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                    SizedBox(width: 20),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: mainTheme,
                        ),
                        child: Text('Submit'),
                        onPressed: () {
                          if (_formKey.currentState!
                              .validate()) {
                            _updateData(
                                developmentDomainRecord.id.toString(), _titleController.text, _descriptionController.text
                            );
                            Navigator.pop(context);
                          }
                        }),
                ]),
              ],
            ),
          ),
        ],
      ),
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  void deleteDialog(BuildContext context) {
    var alert = AlertDialog(
        title: Text('Delete Post'),
        content: Text('Are you sure you want to delete?'),
        actions: <Widget>[
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: secondaryTheme,
              ),
            child: Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            }),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: mainTheme,
              ),
              child: Text('Ok'),
              onPressed: () {
                FirebaseFirestore.instance.collection('developmentdomain').doc(developmentDomainRecord.id.toString()).delete().then((_) {
                  print("success!");
                });
                Navigator.pop(context);
              }),
        ]);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }
}

