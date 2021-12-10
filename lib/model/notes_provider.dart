import 'package:flutter/cupertino.dart';
import 'package:todolist/dbHelper/helper.dart';
import 'package:todolist/model/notes.dart';

class NotesProvider extends ChangeNotifier {
  List<Notes> _notes = List<Notes>();

  List<Notes> getNotes() {
    return _notes;
  }

  // void removeNotes(int index) {
  //   _notes.removeAt(index);
  //   notifyListeners();
  // }
  //
  // void addNotes(String tittle, String description, int id, int isChecked) {
  //   Notes note = Notes(
  //     tittle,
  //     description,
  //     id,
  //     isChecked,
  //   );
  //   _notes.add(note);
  //   notifyListeners();
  // }

  Future<void> insertTable(String tittlecntrl, String desccntrl) async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnTittle: tittlecntrl,
      DatabaseHelper.columnDescription: desccntrl,
      DatabaseHelper.columnisChecked: 1
    };
    await dbHelper.insert(row);
    print('/// DATABASE INSERT  $row');
    notifyListeners();
    return;
  }

  final dbHelper = DatabaseHelper.instance;



  /// Fetching Data by querying and Binding in list
  Future<void> fetchTable() async {
    final allRows = await dbHelper.queryAllRows();
    _notes = [];
    allRows.forEach((row) {
      _notes.add(Notes(

          ///Response from database
          row["tittle"],
          row["Description"],
          row['_id'],
          row["isChecked"]));
      print('///FETCH  DATABASE  $row');
      //   setState(() {});
      //
      //   /// setState to update UI
      // });
      notifyListeners();
    });
  }
  /// UPDATING INTO DATABASE
  Future<void> updateTable(Notes notes,) async {
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
    fetchTable();
    notifyListeners();
    return;
  }

  /// Deleting form Database

Future<void> deleteTable(Notes notes,) async {
  Map<String, dynamic> row = {
    DatabaseHelper.columnisChecked: notes.isChecked,
    DatabaseHelper.columnId: notes.id,
    DatabaseHelper.columnDescription: notes.description,
    DatabaseHelper.columnTittle: notes.tittle,
  };

  final delete = await dbHelper.deleteTable(row, notes);
  print('/// DATABASE UPDATE $delete');
  fetchTable();
}

}
