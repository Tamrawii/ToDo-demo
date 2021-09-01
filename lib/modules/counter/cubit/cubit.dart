import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/modules/counter/cubit/states.dart';

class CubitCounter extends Cubit<CubitStates>
{
  CubitCounter() : super(CounterInitialState());

  static CubitCounter get(context) => BlocProvider.of(context);
  int counter = 1;

  void minus(){
    counter--;
    emit(CounterMinusState());
  }

  void plus(){
    counter++;
    emit(CounterPlusState());
  }
}