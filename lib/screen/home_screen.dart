import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todolist/dbHelper/helper.dart';
import 'package:todolist/model/notes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dbHelper = DatabaseHelper.instance;

  TextEditingController tittlecntrl = TextEditingController();
  TextEditingController desccntrl = TextEditingController();

  List<Notes> _list = [];

  @override
  void initState() {
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
            itemCount: _list.length,
            itemBuilder: (context, index) {
              if (_list[index] != null) {
                var checked = _list[index].isChecked;
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 4),
                  child: Dismissible(
                    background: Icon(
                      Icons.delete,
                      size: 40,
                      color: Colors.red,
                    ),
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      setState(() {
                        _delete(_list.removeAt(index));
                      });
                    },
                    child: Card(
                      child: ListTile(
                          leading: Checkbox(
                            value: checked == 2 ? true : false,
                            onChanged: (val) {
                              setState(() {
                                checked = checked;
                                _update(_list[index]);
                              });
                            },
                          ),
                          title: Text(_list[index]?.tittle ?? ''),
                          subtitle: Text(_list[index]?.description ?? ''),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "Created : ${DateFormat("dd-MM-yyyy").format(DateTime.now())}"),
                              Text(
                                  "At Time : ${DateFormat("hh:mm:ss ").format(DateTime.now())}"),
                            ],
                          )),
                    ),
                  ),
                );
              } else {
                return Text("ADD NOTES");
              }
            },
          )),
          ElevatedButton(
              onPressed: () {
                showAlertADDDialog();
              },
              child: Text("Add Notes"))
        ],
      ),
    ));
  }

  void showAlertADDDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: Text('ADD NOTES'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: tittlecntrl,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(),
                          borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      labelText: "Tittle",
                      fillColor: Colors.transparent,
                      hintText: "Tittle Here..."),
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 12,
                  controller: desccntrl,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      labelStyle: TextStyle(),
                      labelText: "Description",
                      fillColor: Colors.grey.shade300,
                      hintText: "Description Here"),
                ),
                ElevatedButton(
                  child: Text('ADD'),
                  onPressed: () async {
                    await _insert();
                    fetch();
                    // Provider.of<NotesProvider>(context, listen: false)
                    //     .addNotes(tittlecntrl.text, desccntrl.text, null);
                    Navigator.pop(context);
                  },
                ),

              ],
            ),
          ),
        );
      },
    );
  }

  /// INSERTING TO DATABASE FUNCTION
  Future<void> _insert() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnTittle: tittlecntrl.text,
      DatabaseHelper.columnDescription: desccntrl.text,
      DatabaseHelper.columnisChecked: 1
    };
    await dbHelper.insert(row);
    desccntrl.clear();
    tittlecntrl.clear();
    print('/// DATABASE INSERT  $row');
    return;
  }

  /// UPDATING INTO DATABASE
  Future<void> _update(
    Notes notes,
  ) async {
    Map<String, dynamic> row = {
      /// updating condition used for database  if isCheked value is 1 then update it to 2 else remain 1
      DatabaseHelper.columnisChecked: notes.isChecked == 1 ? 2 : 1,
      DatabaseHelper.columnId: notes.id,
      DatabaseHelper.columnDescription: notes.description,
      DatabaseHelper.columnTittle: notes.tittle,
    };
    final update = await dbHelper.updateTable(row, notes);
    print('/// DATABASE UPDATE $update');

    /// after udation fetching the database
    fetch();

    return;
  }

  /// Fetching Data by querying and Binding in list
  fetch() async {
    final allRows = await dbHelper.queryAllRows();
    _list = [];
    allRows.forEach((row) {
      _list.add(Notes(

          ///Response from database
          row["tittle"],
          row["Description"],
          row['_id'],
          row["isChecked"]));
      print('///FETCH  DATABASE  $row');
      setState(() {});

      /// setState to update UI
    });
  }

  /// Deleting form Database

  Future<void> _delete(Notes notes) async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnisChecked: notes.isChecked,
      DatabaseHelper.columnId: notes.id,
      DatabaseHelper.columnDescription: notes.description,
      DatabaseHelper.columnTittle: notes.tittle,
    };

    final delete = await dbHelper.deleteTable(row, notes);
    print('/// DATABASE UPDATE $delete');
    fetch();
  }
}
