import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/componets/componets.dart';
import 'package:shop_app/models/favorites_model.dart';
import 'package:shop_app/shop_app/shop_layout/cubit/cubit.dart';
import 'package:shop_app/shop_app/shop_layout/cubit/states.dart';
import 'package:shop_app/styles/colors.dart';

class FavoritesScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return   BlocConsumer<ShopCubit,ShopStates>(
      listener: (context,state){},
      builder: (context,state){

        return ConditionalBuilder(
          condition: state is! ShopLoadingGetFavoritesState,
          builder: (context) => ListView.separated(
              itemBuilder: (context,index) => buildListProduct(ShopCubit.get(context).favoritesModel!.data!.data![index].product,context),
              separatorBuilder: (context,index) => Container(
                height: 1,
                width: double.infinity,
                color: Colors.grey,
              ),
              itemCount: ShopCubit.get(context).favoritesModel!.data!.data!.length),
          fallback: (context)=> Center(child: CircularProgressIndicator()),
        );
      },
    );
  }



}
