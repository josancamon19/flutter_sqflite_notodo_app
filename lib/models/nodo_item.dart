import 'package:flutter/material.dart';
import 'package:notodo_app_3challenge/utils/database_utils.dart';

class NoDoItem extends StatelessWidget {
  static const String keyItemName = "item_name";
  static const String keyDateCreated = "date_created";
  static const String keyId = "id";

  String _itemName;
  String _dateCreated;
  int _id;

  NoDoItem(this._itemName, this._dateCreated);

  NoDoItem.map(dynamic obj) {
    this._itemName = obj[keyItemName];
    this._dateCreated = obj[keyDateCreated];
    this._id = obj[keyId];
  }

  String get itemName => _itemName;

  String get dateCreated => _dateCreated;

  int get id => _id;

  Map<String, dynamic> toMap() {
    Map map = new Map<String, dynamic>();
    map[keyItemName] = _itemName;
    map[keyDateCreated] = _dateCreated;
    if (_id != null) {
      map[keyId] = _id;
    }
    return map;
  }

  NoDoItem.fromMap(Map<String, dynamic> map) {
    this._itemName = map[keyItemName];
    this._dateCreated = map[keyDateCreated];
    this._id = map[keyId];
  }

  @override
  Widget build(BuildContext context) {
    /*return new Container(
      padding: new EdgeInsets.all(8.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            _itemName,
            style: new TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
                fontSize: 16.0),
          ),
          new Container(
            margin: const EdgeInsets.only(top: 5.0),
            child: new Text(
              "Created on $_dateCreated",
              style: new TextStyle(fontSize: 14.0,
                  fontStyle: FontStyle.italic),
            ),
          )
        ],
      ),
    );*/
    return new ListTile(
      leading: new CircleAvatar(
        child: new Text(
          _itemName[0],
          style: new TextStyle(color: Colors.white),
        ),
      ),
      title: new Text(_itemName),
      subtitle: new Text(_dateCreated),

    );
  }

  void deleteItem(int id) async {
    DatabaseHelper db = new DatabaseHelper();
    int rowsDeleted = await db.deleteItem(id);
    print(rowsDeleted);
  }
}
