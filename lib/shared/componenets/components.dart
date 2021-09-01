import 'package:flutter/material.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

Widget defaultFormField({
  required String labelText,
  required var icon,
  required validator,
  bool readOnly = false,
  bool showCursor = false,
  var onTap,
  var keyboardType,
  var border,
  var controller,
  bool enable = true,
}) => TextFormField(
  showCursor: showCursor,
  readOnly: readOnly,
  enabled: enable,
  validator: validator,
  controller: controller,
  onChanged: (value) {},
  onFieldSubmitted: (value) {
    print(value);
  },
  keyboardType: keyboardType,
  onTap: onTap,
  decoration: InputDecoration(
    labelText: labelText,
    border: border,
    prefixIcon: Icon(icon),
  ),
);


Widget defaultRow(Map model, context) => Dismissible(
  child: Padding(
  
    padding: const EdgeInsets.all(20.0),
  
    child: Row(
  
      // crossAxisAlignment: CrossAxisAlignment.start,
  
      children: [
  
        //time
  
        CircleAvatar(
  
          radius: 35,
  
          backgroundColor: Colors.grey[400],
  
          child: Text('${model['time']}', style: TextStyle(
  
            color: Colors.white,
  
          )),
  
        ),
  
        SizedBox(
  
          width: 20.0,
  
        ),
  
        Expanded(
  
          child: Column(
  
            crossAxisAlignment: CrossAxisAlignment.start,
  
            mainAxisSize: MainAxisSize.min,
  
            children: [
  
              //title
  
              Text('${model['title']}', style: TextStyle(
  
                // color: Colors.white,
  
                  fontWeight: FontWeight.bold,
  
                  fontSize: 20.0
  
              )),
  
              SizedBox(
  
                height: 10.0,
  
              ),
  
              //date
  
              Text('${model['date']}', style: TextStyle(
  
                color: Colors.grey[500],
  
              )),
  
            ],
  
          ),
  
        ),
  
        SizedBox(
  
          width: 20.0,
  
        ),
  
        IconButton(
  
            onPressed: ()
  
            {
  
              AppCubit.get(context).updateDb(
  
                  status: 'done',
  
                  id: model['id']
  
              );
  
            },
  
            icon: Icon(Icons.check_box,
  
            color: Colors.green,
  
            )
  
        ),
  
        IconButton(
  
            onPressed: ()
  
            {
  
              AppCubit.get(context).updateDb(
  
                  status: 'archive',
  
                  id: model['id']
  
              );
  
            },
  
            icon: Icon(Icons.archive,
  
              color: Colors.grey,
  
            )
  
        )
  
      ],
  
    ),
  
  ),
  key: Key(model['id'].toString()),
  onDismissed: (direction)
  {
    AppCubit.get(context).deleteDb(id: model['id']);
  },
);