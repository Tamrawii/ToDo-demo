import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archived_tasks/archived_tasks.dart';
import 'package:todo_app/modules/done_tasks/done_tasks.dart';
import 'package:todo_app/modules/new_tasks/new_tasks.dart';
import 'package:todo_app/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;

  List<Widget> screens = [
    NewTasks(),
    DoneTasks(),
    ArchivedTasks(),
  ];

  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(ApBarChangeBottomNavBarState());
  }

  late Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void createDb() {
    openDatabase('todo.db', version: 1, onCreate: (database, version) {
      print('database created');
      database
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
          .then((value) {
        print('table created');
      }).catchError((error) {
        print('Error creating database table ${error.toString()}');
      });
    }, onOpen: (database) {
      getDb(database);
      print('database opened');
    }).then((value) {
      database = value;
      emit(AppCreateDbState());
    });
  }

  updateDb({
    required status,
    required id,
  }) async {
    await database.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      getDb(database);
      emit(AppUpdateDbState());
    });
  }

  deleteDb({
    required id,
  }) async {
    await database.rawDelete('DELETE FROM tasks WHERE id = ?',
        [id]).then((value) {
      getDb(database);
      emit(AppDeleteDbState());
    });
  }

  insertDb({
    required title,
    required date,
    required time,
  }) async {
    await database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks (title, date, time, status) VALUES ("$title", "$date", "$time", "new")')
          .then((value) {
        print('$value insert successfully');
        emit(AppInsertDbState());

        getDb(database).then((value) {
          newTasks = value;
          print(newTasks);
          emit(AppGetDbState());
        });
      }).catchError((error) {
        print('error inserting in database ${error.toString()}');
      });
    });
  }

  getDb(database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    emit(AppCreateDbLoadingState());

    database.rawQuery('SELECT * FROM tasks').then((value) {
      emit(AppGetDbState());

      value.forEach((element) {
        if (element['status'] == 'new')
          newTasks.add(element);
        else if (element['status'] == 'done')
          doneTasks.add(element);
        else
          archivedTasks.add(element);
      });
    });
  }

  bool isOpened = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    isOpened = isShow;
    fabIcon = icon;
    emit(ApBarChangeBottomSheetState());
  }
}
