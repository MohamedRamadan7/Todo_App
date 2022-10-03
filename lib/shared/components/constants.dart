
import 'package:todo_app/shared/network/local/cache_helper.dart';

void signOut(context) {
  CacheHelper.removeData(key: 'token').then((value) {
    if (value) {}
  });
}

String? uId;


