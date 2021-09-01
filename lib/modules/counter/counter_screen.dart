import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/modules/counter/cubit/states.dart';

import 'cubit/cubit.dart';

class CounterScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CubitCounter(),
      child: BlocConsumer<CubitCounter, CubitStates>(
        listener: (context, build) {},
        builder: (context, build) => Scaffold(
          appBar: AppBar(
            title: Text('Counter'),
          ),
          body: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: (){
                      CubitCounter.get(context).minus();
                    },
                    child: Text('-', style: TextStyle(
                        color: Colors.blue,
                        fontSize: 60.0,
                        fontWeight: FontWeight.bold
                    ),)),
                SizedBox(width: 10.0),
                Text('${CubitCounter.get(context).counter}', style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 80.0
                ),),
                SizedBox(width: 10.0),
                TextButton(
                    onPressed: (){
                      CubitCounter.get(context).plus();
                    },
                    child: Text('+', style: TextStyle(
                        color: Colors.blue,
                        fontSize: 50.0,
                        fontWeight: FontWeight.bold
                    ),)),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
