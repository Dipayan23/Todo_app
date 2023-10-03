import 'package:hive/hive.dart';

class ToDoDatabase {
  final _mybox = Hive.box('mybox');

  List ToDoLists = [];

  void createInitialdata() {
    ToDoLists = [
      ["Doing Python", false],
      ["DSA", false],
    ];
  }


  void loadData(){
    ToDoLists = _mybox.get("ToDoList");
  }

  void updateData(){
    _mybox.put("ToDoList", ToDoLists);
  }
}
