import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/shared/bloc_observer.dart';

import 'layout/home_layout.dart';
import 'modules/counter/counter_screen.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MaterialApp(
      home: MyApp()
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomeLayout();
  }
}
