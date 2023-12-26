import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/end_points.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/modules/login/cubit/states.dart';
import 'package:shop_app/network/remote/dio_helper.dart';

class ShopLoginCubit extends Cubit<ShopLoginStates>{


  ShopLoginCubit() : super (ShopLoginInitialState());


  static ShopLoginCubit get(context) => BlocProvider.of(context);

  ShopLoginModel? loginModel;
void userLogin({
  required String email,
  required String password,

}){
  emit(ShopLoginLoadingState());
  DioHelper.postData(
      url: LOGIN,
      data: {
        'email':email,
        'password':password,}).then((value) {

          print(value.data);
          loginModel = ShopLoginModel.fromJson(value.data);

          emit(ShopLoginSuccessState(loginModel!));
  }).catchError((error){
    emit(ShopLoginErrorState(error.toString()));
  });
}


bool isPassword = true;
  IconData suffix = Icons.visibility_outlined;

void changeIsPassword(){

  isPassword = !isPassword;

  suffix = isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
  emit(ShopLoginChangeIsPasswordState());

}
}


