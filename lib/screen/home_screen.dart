import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/dbHelper/helper.dart';
import 'package:todolist/model/notes.dart';
import 'package:todolist/model/notes_provider.dart';

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
  void initState() {
    // TODO: implement initState
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
          // Expanded(
          //   child: Consumer<NotesProvider>(
          //     builder: (context, NotesProvider data, _) {
          //       return ListView.separated(
          //         itemCount: data.getNotes().length,
          //         itemBuilder: (context, index) {
          //           return Container(
          //             child: _cardList(data.getNotes()[index], index),
          //           );
          //         },
          //         separatorBuilder: (context, index) {
          //           return Divider(
          //             height: 2,
          //           );
          //         },
          //       );
          //     },
          //   ),
          // ),

          Expanded(
            child: ListView.separated(
              itemCount: _list.length,
              itemBuilder: (context, index) {

                var checked =_list[index].isChecked;
                return ListTile(
                    leading: Checkbox(
                      value:checked==2?true:false,
                      onChanged: (val) {
                        setState(() {
                           checked=checked;
                           _update();
                        });
                      },
                    ),
                    title: Text(_list[index]?.tittle ?? ''),
                    subtitle: Text(_list[index]?.description ??''),

                );
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

  Future<void> _insert() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnTittle: tittlecntrl.text,
      DatabaseHelper.columnDescription: desccntrl.text,
      DatabaseHelper.columnisChecked: 1
    };
    final id = await dbHelper.insert(row);
    print('///  $id');
    return;
  }


  Future<void> _update() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnisChecked:'2'
    };
    final update = await dbHelper.updateTable(row);
     print('/// UPDATE $update');
    return;
  }



  fetch() async {
    final allRows = await dbHelper.queryAllRows();
    allRows.forEach((row) {
      _list.add(Notes(row["tittle"], row["Description"], row["key"],row["isChecked"]));
      print(row);
    });
    setState(() {});
  }
}
