import 'package:flutter/material.dart';
import 'package:growth_app/model/development_domain.dart';

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
                      )),
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
                  onTap: () {},
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
                  onTap: () {},
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

        // decoration: BoxDecoration(
        //   color: Color(0xfff2f2f2),
        //   borderRadius: const BorderRadius.all(
        //     const Radius.circular(25),
        //   ),
        // ),
      ]),
    ));
  }
}
