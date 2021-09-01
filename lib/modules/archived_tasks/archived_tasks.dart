import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/componenets/components.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class ArchivedTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppCubit.get(context).archivedTasks;

        return tasks.length > 0
            ? ListView.separated(
                itemBuilder: (context, index) =>
                    defaultRow(tasks[index], context),
                separatorBuilder: (context, index) => Padding(
                  padding: const EdgeInsetsDirectional.only(start: 20),
                  child: Container(
                    width: double.infinity,
                    height: 1.0,
                    color: Colors.grey[200],
                  ),
                ),
                itemCount: tasks.length,
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.archive,
                      size: 60,
                      color: Colors.grey[400],
                    ),

                    SizedBox(
                      height: 15,
                    ),

                    Text(
                      'No Tasks Archived, Please Archive Some Tasks',
                      style: TextStyle(
                          color: Colors.grey[400], fontWeight: FontWeight.w700),
                    )
                  ],
                ),
              );
        ;
      },
    );
  }
}
