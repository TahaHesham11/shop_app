import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/componets/constans.dart';
import 'package:shop_app/end_points.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/change_favorites_model.dart';
import 'package:shop_app/models/favorites_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/network/remote/dio_helper.dart';
import 'package:shop_app/shop_app/categories_screen.dart';
import 'package:shop_app/shop_app/favorites_screen.dart';
import 'package:shop_app/shop_app/products_screen.dart';
import 'package:shop_app/shop_app/settings_screen.dart';
import 'package:shop_app/shop_app/shop_layout/cubit/states.dart';

class ShopCubit extends Cubit<ShopStates>{
  ShopCubit(): super (ShopInitialState());


  static ShopCubit get(context)=>BlocProvider.of(context);


  int current = 0;

  List<Widget> bottomScreen =
  [
  ProductsScreen(),
  CategoriesScreen(),
  FavoritesScreen(),
  SettingsScreen(),
  ];

  void changeBottom(index){

    current = index;
    emit(ShopChangeNavBarState());

  }

  HomeModel? homeModel;

  Map<int , bool >  favorites = {};

  void getHomeData(){
    emit(ShopLoadingHomeDataState());

    DioHelper.getData(
        url: HOME,
      token:token,
    ).then((value) {

          homeModel = HomeModel.fromJson(value.data);

       ;

          homeModel!.data!.products.forEach((element) {
            favorites.addAll({
              element.id! : element.inFavorites!,
            });
          });
          print(favorites.toString());

          emit(ShopSuccessHomeDataState());
    }).catchError((error){

      print(error.toString());

      emit(ShopErrorHomeDataState());
    });


  }

  CategoriesModel?  categoriesModel;

  void getCategories(){
    emit(ShopLoadingCategoriesState());

    DioHelper.getData(
      url: Get_Categories,
      token:token,
    ).then((value) {

      categoriesModel = CategoriesModel.fromJson(value.data);

      emit(ShopSuccessCategoriesState());

    }).catchError((error){

      print(error.toString());

      emit(ShopErrorCategoriesState());
    });


  }


  ChangeFavoritesModel? changeFavoritesModel;
  void changeFavorites(int productId)
  {
    favorites[productId] = !favorites[productId]!;

    emit(ShopChangeFavoritesState());
DioHelper.postData(
    url: FAVORITES,
    token: token,
    data: {
      'product_id':productId
    },


).then((value) {

  changeFavoritesModel=ChangeFavoritesModel.fromJson(value.data);
  print(value.data);
  if(!changeFavoritesModel!.status!){
    favorites[productId] = !favorites[productId]!;

  }else{
    getFavorites();
  }

emit(ShopSuccessChangeFavoritesState(changeFavoritesModel!));
}).catchError((error){
  favorites[productId] = !favorites[productId]!;

  emit(ShopErrorChangeFavoritesState());
});

  }


  FavoritesModel? favoritesModel;
  void getFavorites(){

    emit(ShopLoadingGetFavoritesState());

    DioHelper.getData(
      url: FAVORITES,
      token: token
    ).then((value) {

      favoritesModel=FavoritesModel.fromJson(value.data);
      print(value.data.toString());
      emit(ShopSuccessGetFavoritesState());

    }).catchError((error){
      emit(ShopErrorGetFavoritesState());
    });

  }


  ShopLoginModel? userModel;
  void getUserData(){

    emit(ShopLoadingUserDataState());

    DioHelper.getData(
        url: PROFILE,
        token: token
    ).then((value) {

      userModel=ShopLoginModel.fromJson(value.data);

      print(userModel!.data!.name);

      emit(ShopSuccessUserDataState(userModel!));

    }).catchError((error){
      emit(ShopErrorUserDataState());
    });

  }




  void updateUserData({

  required String name,
    required String email,
    required String phone,

  }){

    emit(ShopLoadingUpdateUserState());

    DioHelper.PutData(
        url: UPDATE_PROFILE,
        token: token,
      data: {
          'name':name,
        'email':email,
        'phone':phone,

      }
    ).then((value) {

      userModel=ShopLoginModel.fromJson(value.data);

      print(userModel!.data!.name);

      emit(ShopSuccessUpdateUserState(userModel!));

    }).catchError((error){
      emit(ShopErrorUpdateUserState());
    });

  }



}