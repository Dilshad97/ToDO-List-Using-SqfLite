import 'package:flutter/cupertino.dart';
import 'package:todolist/model/notes.dart';

class NotesProvider extends ChangeNotifier {
  List<Notes> _notes = List<Notes>();

  List<Notes> getNotes() {
    return _notes;
  }

  void removeNotes(int index) {
    _notes.removeAt(index);
    notifyListeners();
  }

  void addNotes(String tittle, String description, int key, int isChecked) {
    Notes note = Notes(tittle, description, key,isChecked);
    _notes.add(note);
    notifyListeners();
  }
}
