import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/componets/componets.dart';
import 'package:shop_app/componets/constans.dart';
import 'package:shop_app/modules/login/cubit/cubit.dart';
import 'package:shop_app/modules/login/cubit/states.dart';
import 'package:shop_app/modules/register/shop_register_screen.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:shop_app/network/local/cache_helper.dart';
import 'package:shop_app/shop_app/shop_layout/shop_layout.dart';

class ShopLoginScreen extends StatelessWidget {

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {


    return BlocProvider(

      create: (BuildContext context) =>ShopLoginCubit(),

      child: BlocConsumer<ShopLoginCubit,ShopLoginStates>(
        listener: (context,state){
          if(state is ShopLoginSuccessState){
            if(state.loginModel.status!){
              print(state.loginModel.message);
              print(state.loginModel.data!.token);

              CacheHelper.saveData(key: 'token', value: state.loginModel.data!.token).then((value) {

                token = state.loginModel.data!.token;
                navigateAndFinish(context, ShopLayout());
              });

            }
            else
            {
              print(state.loginModel.message);

             showToastStates(
                 text: state.loginModel.message!,
                 state: ToastStates.ERROR);

            }
          }

        },
        builder: (context,state){
          return Scaffold (
              appBar:AppBar(),
              body:Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Login',
                            style: TextStyle(
                                fontSize: 40.0,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(
                            'Login now to browser our hot offers',
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey
                            ),
                          ),
                          SizedBox(height: 30,),
                          defaultField(
                              controller: emailController,
                              type: TextInputType.emailAddress,
                              validate: ( value){
                                if(value!.isEmpty){
                                  return 'Please enter your email address';
                                }
                                return null;
                              },
                              label: 'Email Address',
                              prefix: Icons.email_outlined),
                          SizedBox(height: 30,),
                          defaultField(
                              controller: passwordController,
                              type: TextInputType.visiblePassword,
                              isPassword: ShopLoginCubit.get(context).isPassword,
                              onSubmit: (value){
                                if(formKey.currentState!.validate()){
                                  ShopLoginCubit.get(context).userLogin(
                                      email: emailController.text,
                                      password: passwordController.text);
                                }
                              },
                              suffix: ShopLoginCubit.get(context).suffix,
                              suffixPressed: (){
                                ShopLoginCubit.get(context).changeIsPassword();
                              },
                              validate: (value){
                                if(value!.isEmpty){
                                  return 'Password is too short';
                                }
                                return null;
                              },
                              label: 'Password',
                              prefix: Icons.lock_outline),
                          SizedBox(height: 30,),

                           ConditionalBuilder(
                             condition: state is! ShopLoginLoadingState,
                             builder: (context) => defaultButton(text: 'Login',
                                 function: ()
                                 {
                                   if(formKey.currentState!.validate()){
                                     ShopLoginCubit.get(context).userLogin(
                                         email: emailController.text,
                                         password: passwordController.text);
                                   }
                                 }
                                 ),
                             fallback: (context)=>Center(child: CircularProgressIndicator()),
                           ),

                          SizedBox(height: 15,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  'Dont have an account?'
                              ),


                              defaultTextButton(function: (){

                                navigateTo(context, ShopRegisterScreen());
                              },
                                  text: 'register'),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
          );
        },
      ),
    );
  }
}


