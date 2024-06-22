import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:todo_app_gokhan_namli/constants/color.dart';
import 'package:todo_app_gokhan_namli/constants/tasktype.dart';
import 'package:todo_app_gokhan_namli/model/task.dart';
import 'package:todo_app_gokhan_namli/screens/add_new_task.dart';
import 'package:todo_app_gokhan_namli/service/todo_service.dart';
import 'package:todo_app_gokhan_namli/todoitem.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //List<String> todo = ["Study lesson", "Run 5k", "Go to party"];
  //List<String> complated = ["Game meetup", "Take out trash"];
  List<Task> todo = [
    Task(
        type: TaskType.note,
        title: "Study lesson",
        description: "Study COMP1117",
        isComplated: false),
    Task(
        type: TaskType.calendar,
        title: "Go to party",
        description: "Attend to party",
        isComplated: false),
    Task(
        type: TaskType.contest,
        title: "Run 5k",
        description: "Run 5 kilometers",
        isComplated: false),
  ];
  List<Task> complated = [
    Task(
        type: TaskType.calendar,
        title: "Go to party",
        description: "Attend to party",
        isComplated: false),
    Task(
        type: TaskType.contest,
        title: "Run 5k",
        description: "Run 5 kilometers",
        isComplated: false),
  ];

  void addNewTask(Task newTask) {
    setState(() {
      todo.add(newTask);
    });
  }

  @override
  Widget build(BuildContext context) {
    TodoService todoService = TodoService();

    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
        home: SafeArea(
      child: Scaffold(
        backgroundColor: HexColor(backgroundColor),
        body: Column(
          children: [
            //Head
            Container(
              width: deviceWidth,
              height: deviceHeight / 3,
              decoration: const BoxDecoration(
                  color: Colors.purple,
                  image: DecorationImage(
                      image: AssetImage("lib/assets/images/Header.png"),
                      fit: BoxFit.cover)),
              child: const Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      "Octaber 20,2024",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Text(
                      "My Todo List",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
            //Top Colum
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: SingleChildScrollView(
                  //FutureBuilder
                  child: FutureBuilder(
                    future: todoService.getuncompletedTodos(),
                    builder: (context, snapshot) {
                      if (snapshot.data == null) {
                        return const CircularProgressIndicator();
                      } else {
                        return ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return TodoItem(task: snapshot.data![index]);
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
            //Complated Text
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Completed",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: SingleChildScrollView(
                  child: FutureBuilder(
                    future: todoService.getcompletedTodos(),
                    builder: (context, snapshot) {
                      if (snapshot.data == null) {
                        return const CircularProgressIndicator();
                      } else {
                        return ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return TodoItem(task: snapshot.data![index]);
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddNewTaskScreen(
                    addNewTask: (newTask) => addNewTask(newTask),
                  ),
                ));
              },
              child: const Text("Add New Task"),
            )
          ],
        ),
      ),
    ));
  }
}
