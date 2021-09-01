import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/modules/archived_tasks/archived_tasks.dart';
import 'package:todo_app/modules/done_tasks/done_tasks.dart';
import 'package:todo_app/modules/new_tasks/new_tasks.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/shared/componenets/components.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/componenets/constants.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget
{
  @override


  late var scaffoldKey = GlobalKey<ScaffoldState>();
  late var formkey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  void clearData()
  {
    titleController.text = '';
    timeController.text = '';
    dateController.text = '';
  }

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDb(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state)
        {
          if(state is AppInsertDbState)
          {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.titles[AppCubit.get(context).currentIndex]),
            ),
              //tasks.length > 0 ? AppCubit.get(context).screens[AppCubit.get(context).currentIndex] : Center(child: CircularProgressIndicator())
            //AppCubit.get(context).screens[cubit.currentIndex],
              body: state is! AppCreateDbLoadingState ? AppCubit.get(context).screens[AppCubit.get(context).currentIndex] : Center(child: CircularProgressIndicator()),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                if (cubit.isOpened) {
                  if (formkey.currentState!.validate()) {
                    cubit.insertDb(title: titleController.text, date: dateController.text, time: timeController.text);
                    clearData();
                    // insertDb(
                    //     title: titleController.text,
                    //     time: timeController.text,
                    //     date: dateController.text
                    // ).then((value) {
                    //   getDb(database).then((value)
                    //   {
                    //     Navigator.pop(context);
                    //     // setState(() {
                    //     //   fabIcon = Icons.edit;
                    //     //   isOpened = false;
                    //     //   tasks = value;
                    //     // });
                    //     // print(tasks);
                    //   });
                    // });
                  }
                } else {
                  scaffoldKey.currentState!.showBottomSheet((context) => Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: formkey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Center(
                              child: Container(
                                height: 8.0,
                                width: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.grey[300],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            defaultFormField(
                                border: OutlineInputBorder(),
                                labelText: 'Add New Task',
                                keyboardType: TextInputType.text,
                                icon: Icons.title_rounded,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Title must not be empty';
                                  }
                                  return null;
                                },
                                controller: titleController),
                            SizedBox(
                              height: 15.0,
                            ),
                            defaultFormField(
                                showCursor: true,
                                readOnly: true,
                                border: OutlineInputBorder(),
                                labelText: 'Select Time',
                                onTap: () {
                                  showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now())
                                      .then((value) {
                                    // print(value!.format(context));
                                    timeController.text = value!.format(context).toString();
                                  });
                                },
                                keyboardType: TextInputType.datetime,
                                icon: Icons.watch_later,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Time must not be empty';
                                  }
                                  return null;
                                },
                                controller: timeController),
                            SizedBox(
                              height: 15.0,
                            ),
                            defaultFormField(
                                showCursor: true,
                                readOnly: true,
                                border: OutlineInputBorder(),
                                labelText: 'Select Date',
                                onTap: () {
                                  showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2090-12-30'))
                                      .then((value) {
                                    dateController.text =
                                        DateFormat.yMMMd().format(value!);
                                  });
                                },
                                keyboardType: TextInputType.datetime,
                                icon: Icons.date_range_rounded,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Date must not be empty';
                                  }
                                  return null;
                                },
                                controller: dateController),
                          ],
                        ),
                      ),
                    ),
                  )
                  ).closed.then((value){
                    cubit.changeBottomSheetState(
                        isShow: false,
                        icon: Icons.edit
                    );
                  });
                  cubit.changeBottomSheetState(
                      isShow: true,
                      icon: Icons.add,
                  );
                }
              },
              child: Icon(cubit.fabIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: AppCubit.get(context).currentIndex,
              onTap: (index) {
                AppCubit.get(context).changeIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.menu_rounded), label: 'Tasks'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline_rounded), label: 'Done'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined), label: 'Archived'),
              ],
            ),
          );
        },
      ),
    );
  }




}


// class _HomeLayoutState extends State<HomeLayout> {
//   int currentIndex = 0;
//
//   List<Widget> screens = [
//     NewTasks(),
//     DoneTasks(),
//     ArchivedTasks(),
//   ];
//
//   List<String> titels = [
//     'New Tasks',
//     'Done Tasks',
//     'Archived Tasks',
//   ];
//
//   late Database database;
//
//   late var scaffoldKey = GlobalKey<ScaffoldState>();
//   late var formkey = GlobalKey<FormState>();
//
//   bool isOpened = false;
//   IconData fabIcon = Icons.edit;
//
//   var titleController = TextEditingController();
//   var timeController = TextEditingController();
//   var dateController = TextEditingController();
//
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     createDb();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: scaffoldKey,
//       appBar: AppBar(
//         title: Text(titels[currentIndex]),
//       ),
//       body: tasks.length > 0 ? screens[currentIndex] : Center(child: CircularProgressIndicator()),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           if (isOpened) {
//             if (formkey.currentState!.validate()) {
//               insertDb(
//                 title: titleController.text,
//                 time: timeController.text,
//                 date: dateController.text
//               ).then((value) {
//                 getDb(database).then((value)
//                 {
//                   Navigator.pop(context);
//                   setState(() {
//                     fabIcon = Icons.edit;
//                     isOpened = false;
//                     tasks = value;
//                   });
//                   // print(tasks);
//                 });
//               });
//             }
//           } else {
//             scaffoldKey.currentState!.showBottomSheet((context) => Container(
//                   decoration: BoxDecoration(
//                     color: Colors.grey[100],
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.5),
//                         spreadRadius: 5,
//                         blurRadius: 7,
//                         offset: Offset(0, 3), // changes position of shadow
//                       ),
//                     ],
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: Form(
//                       key: formkey,
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Center(
//                             child: Container(
//                               height: 8.0,
//                               width: 30,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(30),
//                                 color: Colors.grey[300],
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 20.0,
//                           ),
//                           defaultFormField(
//                               border: OutlineInputBorder(),
//                               labelText: 'Add New Task',
//                               keyboardType: TextInputType.text,
//                               icon: Icons.title_rounded,
//                               validator: (value) {
//                                 if (value.isEmpty) {
//                                   return 'Title must not be empty';
//                                 }
//                                 return null;
//                               },
//                               controller: titleController),
//                           SizedBox(
//                             height: 15.0,
//                           ),
//                           defaultFormField(
//                               border: OutlineInputBorder(),
//                               labelText: 'Select Time',
//                               onTap: () {
//                                 showTimePicker(
//                                         context: context,
//                                         initialTime: TimeOfDay.now())
//                                     .then((value) {
//                                   // print(value!.format(context));
//                                   timeController.text =
//                                       value!.format(context).toString();
//                                 });
//                               },
//                               keyboardType: TextInputType.datetime,
//                               icon: Icons.watch_later,
//                               validator: (value) {
//                                 if (value.isEmpty) {
//                                   return 'Time must not be empty';
//                                 }
//                                 return null;
//                               },
//                               controller: timeController),
//                           SizedBox(
//                             height: 15.0,
//                           ),
//                           defaultFormField(
//                               border: OutlineInputBorder(),
//                               labelText: 'Select Date',
//                               onTap: () {
//                                 showDatePicker(
//                                         context: context,
//                                         initialDate: DateTime.now(),
//                                         firstDate: DateTime.now(),
//                                         lastDate: DateTime.parse('2090-12-30'))
//                                     .then((value) {
//                                   dateController.text =
//                                       DateFormat.yMMMd().format(value!);
//                                 });
//                               },
//                               keyboardType: TextInputType.datetime,
//                               icon: Icons.date_range_rounded,
//                               validator: (value) {
//                                 if (value.isEmpty) {
//                                   return 'Date must not be empty';
//                                 }
//                                 return null;
//                               },
//                               controller: dateController),
//                         ],
//                       ),
//                     ),
//                   ),
//                 )
//             ).closed.then((value){
//               setState(() {
//                 fabIcon = Icons.edit;
//               });
//               isOpened = false;
//             });
//             setState(() {
//               fabIcon = Icons.add;
//             });
//             isOpened = true;
//           }
//         },
//         child: Icon(fabIcon),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: currentIndex,
//         onTap: (index) {
//           setState(() {
//             currentIndex = index;
//           });
//         },
//         items: [
//           BottomNavigationBarItem(
//               icon: Icon(Icons.menu_rounded), label: 'Tasks'),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.check_circle_outline_rounded), label: 'Done'),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.archive_outlined), label: 'Archived'),
//         ],
//       ),
//     );
//   }
//
//   void createDb() async {
//     database = await openDatabase('todo.db', version: 1,
//         onCreate: (database, version) async {
//       print('database created');
//       database
//           .execute(
//               'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
//           .then((value) {
//         print('table created');
//       }).catchError((error) {
//         print('Error creating database table ${error.toString()}');
//       });
//     }, onOpen: (database) {
//       getDb(database).then((value)
//       {
//         setState(() {
//           tasks = value;
//         });
//         // print(tasks);
//       });
//       print('database opened');
//     });
//   }
//
//   Future insertDb({
//     required title,
//     required date,
//     required time,
//   }) async {
//     return await database.transaction((txn) async {
//       txn
//           .rawInsert(
//               'INSERT INTO tasks (title, date, time, status) VALUES ("$title", "$date", "$time", "new")')
//           .then((value) {
//         print('$value insert successfully');
//       }).catchError((error) {
//         print('error inserting in database ${error.toString()}');
//       });
//     });
//   }
//
//   Future<List<Map>> getDb(database) async
//   {
//     return await database.rawQuery('SELECT * FROM tasks');
//   }
// }
