import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/componets/componets.dart';
import 'package:shop_app/shop_app/search/search_screen.dart';
import 'package:shop_app/shop_app/shop_layout/cubit/cubit.dart';
import 'package:shop_app/shop_app/shop_layout/cubit/states.dart';

class ShopLayout extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<ShopCubit,ShopStates>(
      listener: (context,state){},
      builder: (context,state){
        var cubit = ShopCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: Text(
                'Salla'
            ),
            actions: [
              IconButton(onPressed: (){
                navigateTo(context, SearchScreen());
              }, icon: Icon(Icons.search))

            ],

          ),

          body: cubit.bottomScreen[cubit.current],

          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.current,
            onTap: (index){
              cubit.changeBottom(index);
            },
            items: [

              BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.apps),label: 'Categories'),
              BottomNavigationBarItem(icon: Icon(Icons.favorite),label: 'Favorites'),
              BottomNavigationBarItem(icon: Icon(Icons.settings),label: 'Settings'),

            ],
          ),

        );

      },

    );
  }
}
