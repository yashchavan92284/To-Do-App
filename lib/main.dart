import 'package:advancedtodo/databaseoftodo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart ' as path;
import 'package:sqflite/sqflite.dart';

class ToDoApp extends StatefulWidget {
  const ToDoApp({super.key});
  @override
  State<ToDoApp> createState() => ToDoAppState();
}

class ToDoAppState extends State<ToDoApp> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Future<void>
  Future showBottomSht(bool doEdit, [ToDoModelClass? toDoModelObj]) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 15,
            right: 15,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Create Tasks",
                  style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Title",
                        style: GoogleFonts.quicksand(
                          color: const Color.fromRGBO(89, 57, 241, 1),
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      TextFormField(
                        controller: titleController,
                        decoration: InputDecoration(
                          hintText: "Enter Title",
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color.fromRGBO(113, 35, 230, 1),
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Description",
                        style: GoogleFonts.quicksand(
                          color: const Color.fromRGBO(89, 57, 241, 1),
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      TextFormField(
                        controller: descriptionController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: "Enter Description",
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color.fromRGBO(89, 57, 241, 1),
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Date",
                        style: GoogleFonts.quicksand(
                          color: const Color.fromRGBO(89, 57, 241, 1),
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      TextFormField(
                        controller: dateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: "Enter Date",
                          suffixIcon: const Icon(Icons.date_range_rounded),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color.fromRGBO(89, 57, 241, 1),
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2023),
                            lastDate: DateTime(2025),
                          );
                          String formatedDate =
                              DateFormat.yMMMd().format(pickedDate!);
                          dateController.text = formatedDate;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 50,
                  width: 300,
                  margin: const EdgeInsets.all(10),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(30)),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          13,
                        ),
                      ),
                      backgroundColor: const Color.fromARGB(255, 57, 195, 241),
                    ),
                    onPressed: () {
                      doEdit ? submit(doEdit, toDoModelObj) : submit(doEdit);

                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Submit",
                      style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List todoList = [
    // ToDoModelClass(
    //   id: 1,
    //   title: "Write Title Here",
    //   description: "You Can Write here Description  ",
    //   date: "Select Date",
    // ),
  ];
  @override
  void initState() {
    super.initState();
    fetchDataFromDatabase();
    setState(() {});
  }

  Future<void> fetchDataFromDatabase() async {
    List<Map<String, dynamic>> data = await gettodoData();
    setState(() {
      todoList = data
          .map((map) => ToDoModelClass(
                id: map['id'],
                title: map['title'],
                description: map['description'],
                date: map['date'],
              ))
          .toList();
    });
  }

  Future submit(bool doedit, [ToDoModelClass? toDoModelObj]) async {
    if (titleController.text.trim().isNotEmpty &&
        descriptionController.text.trim().isNotEmpty &&
        dateController.text.trim().isNotEmpty) {
      if (!doedit) {
        await insertodoData(
          ToDoModelClass(
            title: titleController.text.trim(),
            description: descriptionController.text.trim(),
            date: dateController.text.trim(),
          ),
        );
        List<Map<String, dynamic>> retVal = await gettodoData();
        print(await gettodoData());

        List<ToDoModelClass> todoListFromDB = retVal
            .map((data) => ToDoModelClass(
                  id: data['id'],
                  title: data['title'],
                  description: data['description'],
                  date: data['date'],
                ))
            .toList();
        // todoList = await retVal;
        // for (int i = 0; i < retVal.length; i++) {}
        setState(() {
          todoList.clear();

          todoList.addAll(todoListFromDB);
        });
      } else {
        toDoModelObj!.date = dateController.text.trim();
        toDoModelObj.title = titleController.text.trim();
        toDoModelObj.description = descriptionController.text.trim();
        await updateData(toDoModelObj);
        setState(() {});
      }
    }
    clearController();
  }

  void clearController() {
    titleController.clear();
    descriptionController.clear();
    dateController.clear();
  }

  void removeTasks(ToDoModelClass toDoModelObj) async {
    setState(() {
      // todoList.removeWhere((task) => task.id == toDoModelObj.id);
      for (int i = 0; i < todoList.length; i++) {
        if (todoList[i].id == toDoModelObj.id) {
          todoList.removeAt(i);
          i--; // Adjust the loop counter since the list length has changed
        }
      }

      // deleteData(id);
      deleteData(toDoModelObj.id!);
      // if (todoList.isEmpty) {
      //    database.clear();
      // }
    });
  }

  void editTask(ToDoModelClass toDoModelObj) {
    titleController.text = toDoModelObj.title;
    descriptionController.text = toDoModelObj.description;
    dateController.text = toDoModelObj.date;
    showBottomSht(true, toDoModelObj);
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    dateController.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 44, 177, 214),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 100,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 35),
              child: Text(
                "Good Morning...",
                style: GoogleFonts.quicksand(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 30,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.only(left: 35),
              child: Text(
                "Yash Chavan ",
                style: GoogleFonts.quicksand(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 30,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(217, 217, 217, 1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(
                      40,
                    ),
                  ),
                ),
                width: double.infinity,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      "CREATE TASKS",
                      style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w500, fontSize: 15),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(top: 20),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(
                              40,
                            ),
                          ),
                        ),
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: todoList.length,
                          itemBuilder: (context, index) {
                            return Slidable(
                              closeOnScroll: true,
                              endActionPane: ActionPane(
                                extentRatio: 0.2,
                                motion: const DrawerMotion(),
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            editTask(todoList[index]);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              color: const Color.fromRGBO(
                                                  89, 57, 241, 1),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: const Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            removeTasks(todoList[index]);
                                            deleteData(2);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(5),
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              color: const Color.fromRGBO(
                                                  89, 57, 241, 1),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: const Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              key: ValueKey(index),
                              child: Container(
                                margin: const EdgeInsets.only(top: 10),
                                padding: const EdgeInsets.only(
                                  left: 20,
                                  bottom: 20,
                                  top: 20,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(255, 255, 255, 1),
                                  border: Border.all(
                                      color:
                                          const Color.fromRGBO(0, 0, 0, 0.05),
                                      width: 0.5),
                                  boxShadow: const [
                                    BoxShadow(
                                      offset: Offset(0, 4),
                                      blurRadius: 20,
                                      color: Color.fromRGBO(0, 0, 0, 0.13),
                                    )
                                  ],
                                  borderRadius:
                                      const BorderRadius.all(Radius.zero),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                            height: 60,
                                            width: 60,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color.fromRGBO(
                                                  217, 217, 217, 1),
                                            ),
                                            child: const Icon(
                                              Icons.image,
                                              size: 50,
                                            )),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        SizedBox(
                                          width: 240,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                todoList[index].title,
                                                style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              SizedBox(
                                                width: 220,
                                                child: Text(
                                                  todoList[index].description,
                                                  style: GoogleFonts.inter(
                                                      color:
                                                          const Color.fromRGBO(
                                                              0, 0, 0, 0.7),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 12),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                todoList[index].date,
                                                style: GoogleFonts.inter(
                                                    color: const Color.fromRGBO(
                                                        0, 0, 0, 0.7),
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Checkbox(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          activeColor: Colors.green,
                                          value: true,
                                          onChanged: (val) {},
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 58, 204, 234),
        onPressed: () async {
          clearController();
          await showBottomSht(false);
        },
        child: const Icon(
          size: 50,
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  database = openDatabase(path.join(await getDatabasesPath(), "todo13.db"),
      version: 1, onCreate: (db, version) {
    print("in openDatabase");
    db.execute('''
    CREATE TABLE Todo(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT,
    description TEXT,
    date TEXT
  )
''');
  });
  runApp(const MyApp());
  List<Map<String, dynamic>> retVal = await gettodoData();

  for (int i = 0; i < retVal.length; i++) {
    print(retVal[i]);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ToDoApp(),
    );
  }
}

// int id = 0;

class ToDoModelClass {
  int? id;
  String title;
  String description;
  String date;
  ToDoModelClass({
    this.id,
    required this.title,
    required this.description,
    required this.date,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
    };
  }
}
