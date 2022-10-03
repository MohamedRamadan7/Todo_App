import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/layout/cubit/cubit.dart';
import 'package:todo_app/layout/cubit/stats.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/components/constants.dart';

class NewTasksScreen extends StatelessWidget {
  const NewTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<AppCubit,AppStates>(
      listener:(context,state){},
      builder: (context,state){
        return AppCubit.get(context).newTasks.length != 0 ?ListView.separated(
            itemBuilder:(context,index)=> buildTasksItems(AppCubit.get(context).newTasks[index],context),
            separatorBuilder: (context,index)=>const Divider(thickness: 2,indent: 20, endIndent: 20,),
            itemCount:AppCubit.get(context).newTasks.length
        ): Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const[
              Icon(Icons.menu,
                color: Colors.grey,
                size: 100,),
              Text('No Tasks yet , Please Add some Tasks',
                style: TextStyle(
                    fontWeight: FontWeight.bold),)
            ],
          ),
        );
      },
    );
  }
}
