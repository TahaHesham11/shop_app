import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/bloc_observer.dart';
import 'package:shop_app/componets/constans.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/modules/on_boarding.dart';
import 'package:shop_app/network/local/cache_helper.dart';
import 'package:shop_app/network/remote/dio_helper.dart';
import 'package:shop_app/shop_app/shop_layout/cubit/cubit.dart';
import 'package:shop_app/shop_app/shop_layout/shop_layout.dart';
import 'package:shop_app/styles/themes.dart';

void main() async{

  Bloc.observer=MyBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();

DioHelper.init();
 await CacheHelper.init();
Widget widget;

  bool? onBoarding = CacheHelper.getData(key: 'onBoarding');

   token = CacheHelper.getData(key: 'token');
   print(token);

  if(onBoarding != null){

    if(token !=null) widget = ShopLayout();
    else
      widget = ShopLoginScreen();
  }else{
    widget = OnBoardingScreen();
  }



  runApp(MyApp(startWidget:widget));
}

class MyApp extends StatelessWidget {

  final Widget? startWidget;

   MyApp({this.startWidget});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(

      create: (BuildContext context) =>ShopCubit()..getHomeData()..getCategories()..getFavorites()..getUserData(),
      child: MaterialApp(

        debugShowCheckedModeBanner: false,
        theme: lightTheme,


        home: startWidget
      ),
    );
  }
}
