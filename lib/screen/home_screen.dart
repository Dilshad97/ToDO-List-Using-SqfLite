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
  // bool value = false;
  final dbHelper = DatabaseHelper.instance;

  TextEditingController tittlecntrl = TextEditingController();
  TextEditingController desccntrl = TextEditingController();

  List<Notes> _list = [];

  @override
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: _list.length,
              itemBuilder: (context, index) {
                var checked = _list[index].isChecked;
                return ListTile(
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "At Time : ${DateFormat("hh:mm:ss ").format(DateTime.now())}"),
                      ],
                    ));
              },
              separatorBuilder: (context, index) {
                return Divider(
                  color: Colors.red,
                );
              },
            ),
          ),
          ElevatedButton(
              onPressed: () {
                _showAlerEmailtDialog();
              },
              child: Text("Add Notes"))
        ],
      ),
    ));
  }

  void _showAlerEmailtDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ADD NOTES'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tittlecntrl,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.transparent,
                    hintText: "Tittle Here..."),
              ),
              TextField(
                controller: desccntrl,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.transparent,
                    hintText: "Description Here"),
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
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
    print('/// DATABASE INSERT  $row');
    return;
  }

  /// UPDATING INTO DATABASE
  Future<void> _update(
    Notes notes,
  ) async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnisChecked: notes.isChecked == 1 ? 2 : 1,

      /// updating condition used for database  if isCheked value is 1 then update it to 2 else remain 1
      DatabaseHelper.columnId: notes.id,
      DatabaseHelper.columnDescription: notes.description,
      DatabaseHelper.columnTittle: notes.tittle,
    };

    /// getting  for databse query and updating
    final update = await dbHelper.updateTable(row, notes);
    print('/// DATABASE UPDATE $update');
    fetch();

    /// after udation fetching the database

    return;
  }

  /// Fetching Data by querying and Binding in list
  fetch() async {
    final allRows = await dbHelper.queryAllRows();
    _list = [];
    allRows.forEach((row) {
      _list.add(Notes(

          /// Binding in _list of data from database
          row["tittle"],
          row["Description"],
          row['_id'],
          row["isChecked"]));
      print('///FETCH  DATABASE  $row');
      setState(() {});

      /// setState to update UI
    });
  }
}
