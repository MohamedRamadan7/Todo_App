import 'dart:ffi';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/layout/cubit/cubit.dart';
import 'package:todo_app/layout/cubit/stats.dart';
import 'package:todo_app/modules/archive_tasks/archive_tasks.dart';
import 'package:todo_app/modules/done_tasks/done_tasks.dart';
import 'package:todo_app/modules/new_tasks/new_tasks.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/components/constants.dart';

class HomeScreen extends StatelessWidget
{

  var scaffoldKey =GlobalKey<ScaffoldState>();
  var formKey =GlobalKey<FormState>();
  var titleController =TextEditingController();
  var timeController =TextEditingController();
  var dateController =TextEditingController();




  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (BuildContext context)=> AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context , state){
          if(state is AppInsertToDatabaseState)
            Navigator.pop(context);
        },
        builder: (context , state){
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                  AppCubit.get(context).titles[AppCubit.get(context).currentIndex]
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (AppCubit.get(context).isBottomSheet) {
                  if (formKey.currentState!.validate()) {
                    AppCubit.get(context).insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text);

                  }
                }else {
                  scaffoldKey.currentState!.showBottomSheet(
                        (context) =>
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(20.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultFormFiled(
                                  controller: titleController,
                                  lableoutline: 'Task Title',
                                  type: TextInputType.text,
                                  validation: (String value) {
                                    if (value.isEmpty) {
                                      return ' Title must be not empty';
                                    }
                                    return null;
                                  },
                                  fixIcon: Icons.title,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                defaultFormFiled(
                                  controller: timeController,
                                  lableoutline: 'Task Time',
                                  type: TextInputType.text,
                                  validation: (String value) {
                                    if (value.isEmpty) {
                                      return ' Time must be not empty';
                                    }
                                    return null;
                                  },
                                  ontape: () {
                                    showTimePicker(context: context,
                                        initialTime: TimeOfDay.now()).then((value) {
                                      timeController.text =
                                          value!.format(context).toString();
                                    });
                                  },
                                  fixIcon: Icons.watch_later_outlined,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                defaultFormFiled(
                                  controller: dateController,
                                  lableoutline: 'Task Date',
                                  type: TextInputType.text,
                                  validation: (String value) {
                                    if (value.isEmpty) {
                                      return ' Date must be not empty';
                                    }
                                    return null;
                                  },
                                  ontape: () {
                                    showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse('2023-08-01'))
                                        .then((value) {
                                      dateController.text =
                                          DateFormat.yMMMd().format(value!);
                                    });
                                  },
                                  fixIcon: Icons.calendar_today,
                                ),

                              ],
                            ),
                          ),
                        ),
                    elevation: 20.0,
                  ).closed
                      .then((value) {
                    AppCubit.get(context).changeBottomSheet(
                        isShow: false,
                        icon:  Icons.edit);
                  });
                  AppCubit.get(context).changeBottomSheet(
                      isShow: true,
                      icon:  Icons.add);

                }
              },

              child: Icon(AppCubit.get(context).fabIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
                BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline), label: 'Done'),
                BottomNavigationBarItem(icon: Icon(Icons.archive_outlined), label: 'Archive')
              ],
              type: BottomNavigationBarType.fixed,
              currentIndex: AppCubit.get(context).currentIndex,
              onTap: (index) {
                AppCubit.get(context).changeIndex(index);
              },
            ),
            body: State is AppGetDataFromDatabaseLoadingState ? const Center(
              child:CircularProgressIndicator(),
            ): AppCubit.get(context).screens[AppCubit.get(context).currentIndex],
          );
        },
      ),
    );
  }


}

