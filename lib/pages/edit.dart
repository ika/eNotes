import 'package:flutter/material.dart';

import '../db/database.dart';
import '../models/model.dart';
import '../utils/utilities.dart';

String noteFunction;

int id;
String _contents;

class EditPage extends StatefulWidget {
  EditPage({Key key, this.model}) : super(key: key);

  final Model model;

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  @override
  void initState() {
    super.initState();

    id = widget.model.id != null ? widget.model.id : null;
    _contents = widget.model.contents != null ? widget.model.contents : '';

    if (id == null) {
      noteFunction = 'Add Note';
    } else {
      noteFunction = 'Edit Note';
    }
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  _handleOnChange() {
    if (id == null) {
      // no id, save
      _saveEdit();
    } else {
      // with id, update
      _updateEdit();
    }
  }

  _saveEdit() async {
    await DBProvider.db
        .insertNote(Model(contents: _contents, time: getTime()))
        .then((res) {
      id = res; // populate 'id' so that it is not saved more than once
    });
  }

  _updateEdit() async {
    await DBProvider.db
        .updateNote(Model(id: id, contents: _contents, time: getTime()));
  }

  void _deleteEdit() async {
    await DBProvider.db.deleteNote(id).then((value) {
      int count = 0;
      Navigator.popUntil(context, (route) {
        return count++ == 2;
      });
    });
  }

  _deleteDialogWrapper() {
    if (id != null) {
      return showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Delete?',
                    style: TextStyle(color: Colors.orange[900])),
                content: Text(_contents.isNotEmpty
                    ? _contents
                    : 'Delete this null entry?'),
                actions: <Widget>[
                  TextButton(
                      child: Text('YES',
                          style: TextStyle(color: Colors.orange[900])),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        _deleteEdit();
                      }),
                  TextButton(
                      child: Text('NO',
                          style: TextStyle(color: Colors.orange[900])),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ],
              ));
    }
  }

  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
      appBar: AppBar(
        title: Text(noteFunction),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _deleteDialogWrapper,
          )
        ],
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.only(top: 30.0, left: 15.0, right: 15.0),
          child: TextFormField(
            initialValue: _contents,
            maxLength: 256,
            maxLines: null, // auto line break
            autofocus: true,
            // decoration: InputDecoration(
            //   labelText: 'Enter your text',
            //   labelStyle: Theme.of(context).textTheme.subtitle1,
            //   border: OutlineInputBorder(
            //     borderRadius: BorderRadius.circular(5.0),
            //   ),
            // ),
            onChanged: (text) {
              _contents = text;
              _handleOnChange();
            },
          ),
        ),
      ),
    ));
  }
}
