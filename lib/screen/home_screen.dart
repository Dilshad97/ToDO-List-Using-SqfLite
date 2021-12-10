import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  final dbHelper = DatabaseHelper.instance;

  TextEditingController tittlecntrl = TextEditingController();
  TextEditingController desccntrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    NotesProvider notesprovider =
        Provider.of<NotesProvider>(context, listen: false);
    notesprovider.fetchTable();
    // fetch();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('ToDo Calender'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Consumer<NotesProvider>(
              builder: (context, NotesProvider notesprovider, _) {
                return ListView.builder(
                  itemCount: notesprovider.getNotes().length,
                  itemBuilder: (context, index) {
                    final items = notesprovider.getNotes();
                    final item = notesprovider.getNotes()[index];
                    var checked = item.isChecked;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Dismissible(
                        key: UniqueKey(),
                        onDismissed: (direction) {
                          setState(() {
                            NotesProvider notesprovider =
                                Provider.of<NotesProvider>(context,
                                    listen: false);
                            notesprovider.deleteTable(items.removeAt(index));
                          });
                        },
                        child: Card(
                          child: ListTile(
                            leading: Checkbox(
                              value: checked == 2 ? true : false,
                              onChanged: (val) {
                                setState(() {
                                  checked = checked;
                                  NotesProvider notesprovider =
                                      Provider.of<NotesProvider>(context,
                                          listen: false);
                                  notesprovider.updateTable(item);
                                  // _update(_list[index]);
                                });
                              },
                            ),
                            title: Text(item?.tittle ?? 'null'),
                            subtitle: Text(item?.description ?? ''),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
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
                      hintText: "Start writing  Here"),
                ),
                ElevatedButton(
                  child: Text('ADD'),
                  onPressed: () async {
                    NotesProvider notesprovider =
                        Provider.of<NotesProvider>(context, listen: false);
                    await notesprovider.insertTable(
                        tittlecntrl.text, desccntrl.text);
                    await notesprovider.fetchTable();
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
}
