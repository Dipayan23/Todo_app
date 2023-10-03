import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo/components/Todo_list.dart';
import 'package:todo/components/dialog.dart';
import 'package:todo/data/database.dart';

class Homepage extends StatefulWidget {
  Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  final _mybox = Hive.box('mybox');
  ToDoDatabase db = ToDoDatabase();

  @override
  void initState(){

    if (_mybox.get("ToDoList")==null) {
      db.createInitialdata();
    }else{
      db.loadData();
    }

    super.initState();
  }

  final _controller = TextEditingController();

  void CheckboxChange(bool? value, int index) {
    setState(() {
      db.ToDoLists[index][1] = !db.ToDoLists[index][1];
     
    });
     db.updateData();
  }

  void saveNewTask() {
    setState(() {
      db.ToDoLists.add([_controller.text, false]);
      _controller.clear();
      
    });
    Navigator.of(context).pop();
     db.updateData();
  }

  void createNewTask() {
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            controller: _controller,
            onCancel: () => Navigator.of(context).pop(),
            onSaved: saveNewTask,
          );
        });
  }

  void deleteTask(int index){
    setState(() {
      db.ToDoLists.removeAt(index);
    });
     db.updateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        title: Text(
          "TO DO",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: Icon(Icons.add),
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: db.ToDoLists.length,
        itemBuilder: (context, index) {
          return ToDoList(
            taskName: db.ToDoLists[index][0],
            taskCompleted: db.ToDoLists[index][1],
            onChanged: (value) => CheckboxChange(value, index),
            deleteFunction:(context)=> deleteTask(index),
          );
        },
      ),
    );
  }
}
