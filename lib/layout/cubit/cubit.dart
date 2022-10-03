import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/layout/cubit/stats.dart';
import 'package:todo_app/modules/archive_tasks/archive_tasks.dart';
import 'package:todo_app/modules/done_tasks/done_tasks.dart';
import 'package:todo_app/modules/new_tasks/new_tasks.dart';

class AppCubit extends Cubit<AppStates>
{
  AppCubit () : super(AppInitialState());

  static AppCubit get(context) =>BlocProvider.of(context);

  int currentIndex = 0;
  List<String> titles =[
    'New Tasks',
    'Done Tasks',
    'Archive Tasks'
  ];
  List<Widget> screens =[
    const NewTasksScreen(),
    const DoneTasksScreen(),
    const ArchiveTasksScreen()
  ];

void changeIndex(index){
  currentIndex =index;
  emit(AppChangeBottomNavState());

}
  Database? database ;
  bool isBottomSheet = false;
  IconData fabIcon =Icons.edit;
  List<Map> newTasks=[];
  List<Map> doneTasks=[];
  List<Map> archiveTasks=[];

  void createDatabase ()
  {
    openDatabase('todo.db',
      version: 1,
      onCreate: (database, version){
        print('database create');
        database.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY ,title TEXT,date TEXT,time TEXT,stats TEXT)').then((value) =>
        {
          print('table create')
        }).catchError((error){
          print('error when create table ${error.toString()}');
        });
      },
      onOpen: (database)
      {
        getDataFromDatabase(database);

      },
    ).then((value) {
      database =value;
      emit(AppCreateDatabaseState());
    });

  }

  Future insertToDatabase ({
    required String title,
    required String time,
    required String date
  })async
  {
     await database!.transaction((txn) {
      txn.rawInsert('INSERT INTO tasks(title,date,time,stats) VALUES("$title","$date","$time","now")')
          .then((value){

        getDataFromDatabase(database);

        print('$value inserted successfully');
        emit(AppInsertToDatabaseState());

      }).catchError((error){
        print('error when Inserting now record ${error.toString()}');

      });
      return Future(() => null);
    });
  }

  void getDataFromDatabase (database)
  {
    newTasks=[];
    doneTasks=[];
    archiveTasks=[];

    emit(AppGetDataFromDatabaseLoadingState());
      database!.rawQuery('SELECT * FROM tasks ').then((value) {
        value.forEach((element) {
          if(element['stats']=='now')
            newTasks.add(element);
          else if(element['stats']=='done')
            doneTasks.add(element);
          else
            archiveTasks.add(element);
        });
        emit(AppGetDataFromDatabaseState());
      });

  }
  void updateData({
  required String stats,
    required int id
})
  {
    database!.rawUpdate(
        'UPDATE tasks SET stats =? WHERE id =? ',
        ['$stats',id])
        .then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDataFromDatabaseState());
    });
  }

  void deleteData({
    required int id
  })
  {
    database!.rawDelete(
        'DELETE FROM tasks  WHERE id =? ',
        [id])
        .then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDataFromDatabaseState());
    });
  }

  void changeBottomSheet({
    required bool isShow,
    required IconData icon
})
  {
    isBottomSheet =isShow;
    fabIcon =icon ;
    emit(AppChangeBottomSheetState());
  }

}