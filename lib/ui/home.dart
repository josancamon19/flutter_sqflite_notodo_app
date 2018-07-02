import 'package:flutter/material.dart';
import 'package:notodo_app_3challenge/models/nodo_item.dart';
import 'package:notodo_app_3challenge/utils/database_utils.dart';
import 'package:notodo_app_3challenge/utils/date_formatter.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController itemController = new TextEditingController();
  var db = new DatabaseHelper();
  final List<NoDoItem> itemList = <NoDoItem>[];

  @override
  void initState() {
    super.initState();
    _readItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: new AppBar(
        title: Text("No Todo List"),
        centerTitle: true,
      ),
      floatingActionButton: new FloatingActionButton(
        backgroundColor: Colors.amberAccent,
        onPressed: () => _showItemDialog(context),
        child: new Icon(Icons.add),
      ),
      body: new ListView.builder(
        padding: new EdgeInsets.only(bottom: 72.0),
        itemCount: itemList.length,
        itemBuilder: (BuildContext context, int position) {
          return new Column(
            children: <Widget>[
              new Container(
                padding: new EdgeInsets.only(right: 16.0),
                child: new ListTile(
                  onLongPress: () =>
                      _showDialogUpdate(context, itemList[position], position),
                  title: itemList[position],
                  trailing: new Listener(
                    child: new Icon(
                      Icons.remove_circle,
                    ),
                    onPointerDown: (onPointerEvent) =>
                        deleteItem(itemList[position].id, position),
                  ),
                ),
              ),
              new Divider()
            ],
          );
        },
      ),
    );
  }

  void _showItemDialog(_) {
    var alert = new AlertDialog(
      content: new Row(
        children: <Widget>[
          new Expanded(
              child: new TextField(
            controller: itemController,
            autofocus: true,
            decoration: new InputDecoration(
              labelText: "Add item",
              hintText: "Ex. dont drink beer",
              icon: new Icon(Icons.note_add),
            ),
          ))
        ],
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              _handleSubmitItem(itemController.text);
              itemController.clear();
              Navigator.pop(context);
            },
            child: new Text("Save")),
        new FlatButton(
            onPressed: () => Navigator.pop(_), child: new Text("Cancel"))
      ],
    );
    showDialog(context: _, builder: (_) => alert);
  }

  void _showDialogUpdate(_, NoDoItem item, int index) {
    itemController.text = item.itemName;
    var alert = new AlertDialog(
      content: new Row(
        children: <Widget>[
          new Expanded(
              child: new TextField(
            controller: itemController,
            autofocus: true,
            decoration: new InputDecoration(
              labelText: "Update item",
              icon: new Icon(Icons.note_add),
            ),
          ))
        ],
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () async {
              NoDoItem itemNew = new NoDoItem.fromMap({
                "item_name": itemController.text,
                "date_created": dateFormatted(),
                "id": item.id
              });
              _handleUpdateItem(index, itemNew);
              itemController.clear();
              Navigator.pop(context);
            },
            child: new Text("Update")),
        new FlatButton(
            onPressed: () => Navigator.pop(_), child: new Text("Cancel"))
      ],
    );
    showDialog(context: _, builder: (_) => alert);
  }

  void _handleSubmitItem(String text) async {
    itemController.clear();
    NoDoItem item = new NoDoItem(text, dateFormatted());
    int itemSavedId = await db.saveItem(item);
    print(itemSavedId);
    NoDoItem noDoItem = await db.getItem(itemSavedId);
    print(noDoItem.itemName);
    setState(() {
      itemList.add(noDoItem);
    });
  }

  void _readItems() async {
    List items = await db.getItems();
    items.forEach((noDoItem) {
      NoDoItem item = NoDoItem.fromMap(noDoItem);
      setState(() {
        itemList.add(item);
      });
    });
  }

  void deleteItem(int id, int index) async {
    int rowsDeleted = await db.deleteItem(id);
    setState(() {
      itemList.removeAt(index);
    });
    print(rowsDeleted);
  }

  void _handleUpdateItem(int index, NoDoItem noDoItem) async {
    int rowsUpdated = await db.updateItem(noDoItem);
    setState(() {
      itemList.removeWhere((element) {
        itemList[index].itemName == noDoItem.itemName;
      });
      _readItems();
    });
    print(rowsUpdated);
  }
}
