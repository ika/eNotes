import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../db/database.dart';
import '../models/model.dart';
import '../pages/edit.dart';
import '../utils/utilities.dart';

class NotesPage extends StatefulWidget {
  NotesPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {

  FutureOr onReturnFromEdit(dynamic value) {
    // update notes
    setState(() {});
  }

  _navigateToEditPage(Model model) async {
    Route route =
        CupertinoPageRoute(builder: (context) => EditPage(model: model));
        Future.delayed(Duration.zero,() {
          Navigator.push(context, route).then(onReturnFromEdit);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: hexToColor("#f5f0e1"),
      appBar: AppBar(
        title: Text(widget.title)
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: FutureBuilder<List<Model>>(
                future: DBProvider.db.getAllNotes(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Model>> snapshot) {
                  // Make sure data exists and is actually loaded
                  if (snapshot.hasData) {
                    // If there are no notes.
                    if (snapshot.data.length < 1) {
                      //_navigateToEditPage(Model(id: null, contents: ''));
                      return Center(
                        child: Text('No items found!'),
                      );
                    }

                    List<Model> notes = snapshot.data;

                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        Model model = notes[index];
                        return Column(
                          children: <Widget>[
                            ListTile(
                              title: Text(reduceLength(model.contents)),
                              onTap: () {
                                _navigateToEditPage(model);
                              },
                              leading:
                                  Icon(Icons.chevron_right, color: Colors.orangeAccent),
                            ),
                            Divider(
                              height: 2.0,
                              indent: 15.0,
                              endIndent: 20.0,
                            ),
                          ],
                        );
                      },
                    );
                  }

                  return Center(
                    child: Text('An error has occured!'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange[900],
        onPressed: () {
          _navigateToEditPage(Model(id: null, contents: null));
        },
        child: Icon(Icons.add),
      ),
    );
  }


}
