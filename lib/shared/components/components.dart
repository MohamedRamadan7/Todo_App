import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_app/layout/cubit/cubit.dart';
import 'package:todo_app/shared/styles/colors.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  Color textColor = Colors.white,

  bool isUberCase = true,
  double radius = 15.0,
  required Function function,
  required String text,
}) =>
    Container(
      width: width,
      child: MaterialButton(
        onPressed: () => function(),
        child: Text(
          isUberCase ? text.toUpperCase() : text,
          style: TextStyle(
            fontSize: 20.0,
            color: textColor,
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          radius,
        ),
        color: background,
      ),
    );

Function? validateFunc() => null;
class defaultFormFiled extends StatelessWidget {
  defaultFormFiled({
    this.lable ,
    this.lableoutline ,
    this.ispassword = false,
    this.validation = validateFunc,
    this.onsumit= validateFunc,
    this.ontape= validateFunc,
    required this.controller,
    this.type = TextInputType.text,
    this.sufixpressd,
    this.suffix,
    this.fixIcon,
    this.radius = 15.0,
  });
  final String? lable;
  final String? lableoutline;
  final bool ispassword;
  final Function validation;
  final Function onsumit;
  final Function ontape;
  final TextEditingController controller;
  final TextInputType type;
  final Function? sufixpressd;
  final IconData? suffix;
  final IconData? fixIcon;
  final double radius;


  @override
  Widget build(BuildContext context) {
    // App Theme
    var theme = Theme.of(context);

    //Check if dark mode enabled
    bool darkModeOn = theme.brightness == Brightness.dark;

    //Main Text Field Color
    Color? color = darkModeOn ? Color(0xff252A34) : Colors.white;

    //Main Text Field border
    OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      // borderRadius: BorderRadius.circular(15),
      borderRadius: BorderRadius.circular(radius),
      // borderSide: BorderSide(color: color!),
    );

    return TextFormField(
      validator: (value) => validation(value!),
      onFieldSubmitted: (value) => onsumit(value),
      onTap: () => ontape(),
      keyboardType: type,
      obscureText: ispassword,
      controller: controller,

      style: TextStyle(
        color: darkModeOn ? Color(0xffE9EAEF) : Colors.grey[900],
        fontSize: 17,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        labelText:lableoutline ,
        hintText: lable,
        hintStyle: TextStyle(
          color: Colors.grey[600],
          fontSize: 17,
          letterSpacing: 1,
          fontWeight: FontWeight.w400,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 35, vertical: 25),
        filled: true,
        fillColor: color,
        border: outlineInputBorder,
        enabledBorder: outlineInputBorder,
        // errorBorder: outlineInputBorder.copyWith(
        //   borderSide: BorderSide(color: Colors.red[700]!),
        // ),
        focusedBorder: outlineInputBorder,
        // focusedErrorBorder: outlineInputBorder.copyWith(
        //   borderSide: BorderSide(color: Colors.red[700]!),
        // ),
        prefixIcon: Icon(fixIcon),
        suffixIcon: sufixpressd != null || suffix != null
            ? IconButton(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onPressed: () => sufixpressd!(),
          icon: Icon(suffix, color: theme.accentColor),
        )
            : null,
      ),
    );
  }
}


Widget myDivider() => Padding(
      padding: const EdgeInsetsDirectional.only(start: 20.0),
      child: Container(
        width: double.infinity,
        height: 1.0,
        color: Colors.grey[300],
      ),
    );

Widget buildTasksItems(Map model,context)=> Dismissible(
  key: Key(model['id'].toString()),
  onDismissed: (direction)
  {
    AppCubit.get(context).deleteData(id: model['id']);
  },
  child: Padding(

    padding: const EdgeInsets.all(20.0),

    child: Row(

      children: <Widget> [

         CircleAvatar(

          radius: 40,

          child: Text(

            '${model['time']}',

            style:const TextStyle(

                color: Colors.white

            ),

          ),

        ),

        const SizedBox(width: 15,),

        Expanded(

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,

            mainAxisSize: MainAxisSize.min,

            children: <Widget>[

              Text(

                '${model['title']}',

                style:const TextStyle(

                  fontSize: 18,

                  fontWeight:FontWeight.bold,

                ),

              ),

              Text(

                '${model['date']}',

                style:const TextStyle(

                  fontSize: 18,

                  color: Colors.grey,

                ),

              )





            ],

          ),

        ),

        IconButton(

            onPressed: (){

              AppCubit.get(context).updateData(stats: 'done', id: model['id']);

            },

            icon:const Icon(

              Icons.check_box,

              color: Colors.green,

            )),

        IconButton(

            onPressed: (){

              AppCubit.get(context).updateData(stats: 'archive', id: model['id']);

            },

            icon:const Icon(

              Icons.archive,

              color: Colors.grey,

            )),



      ],

    ),

  ),

);

class OrDivider extends StatelessWidget {
  const OrDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size =MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: size.height*0.02),
      width: size.width*0.8,
      child: Row(children:const <Widget>[
        Expanded(
            child: Divider(
              color: Color(0xFFD9D9D9),
              height: 1.5,
            )
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text('OR',
            style: TextStyle(color: kPrimaryColor,
                fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
            child: Divider(
              color: Color(0xFFD9D9D9),
              height: 1.5,
            )
        ),
      ],
      ),
    );
  }
}


// Widget buildArticaleItem(artical , context) => InkWell(
//   onTap: ()
//   {
//     navigateTo(context, WebViewScreen(artical['url']));
//   },
//   child:   Padding(
//     padding: const EdgeInsets.all(20.0),
//     child: Row(
//       children: [
//         Container(
//           width: 120,
//           height: 120,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10.0),
//             image: DecorationImage(
//               image: NetworkImage('${artical['urlToImage']}'),
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//         SizedBox(
//           width: 20.0,
//         ),
//         Expanded(
//           child: Container(
//             height: 120 ,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: Text(
//                     '${artical['title']}',
//                     style:Theme.of(context).textTheme.bodyText1,
//                     maxLines: 3,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 Text(
//                   '${artical['publishedAt']}',
//                   style: TextStyle(
//                     color: Colors.grey,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     ),
//   ),
// );

void navigateTo(context, widget) => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ));

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
    context, MaterialPageRoute(builder: (context) => widget), (route) => false);

void showToast({required String text, required ToastStates state}) =>
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: chooseToastColor(state),
        textColor: Colors.white,
        fontSize: 16.0);
enum ToastStates { SUCCESS, ERROR, WARNING }
Color chooseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}
