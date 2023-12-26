import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/shop_app/shop_layout/cubit/cubit.dart';
import 'package:shop_app/styles/colors.dart';


Widget defaultButton({

  double Width = double.infinity,

  Color background = Colors.indigo,

  required String text,

  required Function function,

  bool isUpperCase =true ,

}) =>       Container(

  width: double.infinity,

  child: MaterialButton(
    onPressed: (){
      function();
    },
    child: Text(
      isUpperCase ? text.toUpperCase():text,
      style: TextStyle(
          color: Colors.white
      ),
    ),

  ),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20.0),
    color: Colors.indigo,

  ),

);



Widget defaultTextButton({
  required Function? function,
  required String text,

})=>    TextButton(onPressed: (){
  function!();
},

    child: Text(text.toUpperCase())
);




Widget defaultField({

  required TextEditingController  controller,

  required TextInputType type,

  required String? Function (String? value) validate,

  required String label,

  required  IconData  prefix ,

  bool isPassword = false,

  IconData? suffix,


  Function? onTap,

  bool isClickabe = true,

  Function? onChange,

  Function? suffixPressed,

  Function? onSubmit,


}) =>    TextFormField(


  controller: controller,
  keyboardType:type ,

  onFieldSubmitted: (String value) {
    onSubmit!(value);
  },

  onChanged: (String value){
    onChange?.call(value);
  },
  validator: validate,

  onTap:(){
    onTap?.call();
  } ,

  obscureText: isPassword,
  decoration: InputDecoration(
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.0)

    ),
    labelText: label,
    enabled: isClickabe,
    prefixIcon: Icon(prefix),

    suffixIcon: IconButton(
        onPressed: (){
          suffixPressed!();
        },

        icon: Icon(suffix)),

  ),

);



void navigateTo (context,Widget) =>    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => Widget)
);

void navigateAndFinish (context,Widget) =>    Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => Widget),
        (route){
      return false;
    }
);

void showToastStates({

  required String text,
  required ToastStates state,

})=>  Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: chooseToastColor(state),
    textColor: Colors.white,
    fontSize: 16.0);


enum ToastStates{SUCCESS , ERROR , WARNING}

Color chooseToastColor(ToastStates state){

  Color color;

  switch(state){
    case ToastStates.SUCCESS:
      color=Colors.green;
      break;
    case ToastStates.ERROR:
      color=Colors.red;
      break;
      case ToastStates.WARNING:
    color=Colors.amber;
    break;
  }
  return color;

}


Widget buildListProduct (model,context, {bool isOldPrice = true}) => Padding(
  padding: const EdgeInsets.all(20.0),
  child: Container(
    height: 120.0,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            Image(
              image: NetworkImage(
                  model.image!
              ),
              width: 120.0,
              height: 120.0,
            ),
            if(model.discount != 0 && isOldPrice)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                color: Colors.red,
                child: Text(
                  'DISCOUNT',
                  style: TextStyle(
                      fontSize: 10.0,
                      color: Colors.white
                  ),
                ),
              )
          ],
        ),

        SizedBox(width: 20,),
        Expanded(

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.name!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 12.0,
                    height: 1.3
                ),
              ),
              Spacer(),
              Row(
                children: [
                  Text(
                    model.price.toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 12.0,
                        color: defaultColor
                    ),
                  ),
                  SizedBox(width: 5,),
                  if(model.discount != 0  && isOldPrice)
                    Text(
                      model.oldPrice.toString(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 10.0,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough
                      ),
                    ),
                  Spacer(),
                  IconButton(
                    onPressed: ()
                    {
                      ShopCubit.get(context).changeFavorites(model.id!);
                      //print(model.id);

                    },
                    icon: CircleAvatar(
                      radius: 15.0,
                      backgroundColor:ShopCubit.get(context).favorites[model.id]! ? defaultColor  : Colors.grey,
                      child: Icon(
                        Icons.favorite_border,
                        size: 14.0,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),




      ],
    ),
  ),
);
