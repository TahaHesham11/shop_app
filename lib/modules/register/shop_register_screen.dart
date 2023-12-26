import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/componets/componets.dart';
import 'package:shop_app/componets/constans.dart';
import 'package:shop_app/modules/register/cubit/cubit.dart';
import 'package:shop_app/modules/register/cubit/states.dart';
import 'package:shop_app/network/local/cache_helper.dart';
import 'package:shop_app/shop_app/shop_layout/shop_layout.dart';

class ShopRegisterScreen extends StatelessWidget {

  var formKey = GlobalKey<FormState>();

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return  BlocProvider(

      create: (BuildContext context) =>ShopRegisterCubit(),

      child: BlocConsumer<ShopRegisterCubit,ShopRegisterStates>(
        listener: (context,state){

          if(state is ShopRegisterSuccessState){
            if(state.loginModel.status!){
              print(state.loginModel.message);
              print(state.loginModel.data!.token);
              CacheHelper.saveData(key: 'token', value: state.loginModel.data!.token).then((value){

                token = state.loginModel.data!.token;
                navigateAndFinish(context, ShopLayout());
              });
            }else{
              print(state.loginModel.message);

              showToastStates(
                  text: state.loginModel.message!,
                  state: ToastStates.ERROR);
            }
          }

        },
        builder: (context,state){

          return  Scaffold(
            appBar: AppBar(),

            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'REGISTER',
                          style: TextStyle(
                              fontSize: 40.0,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                          'Register now to browser our hot offers',
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey
                          ),
                        ),
                        SizedBox(height: 30,),
                        defaultField(
                            controller: nameController,
                            type: TextInputType.name,
                            validate: ( value){
                              if(value!.isEmpty){
                                return 'Please enter your name';
                              }
                              return null;
                            },
                            label: 'User Name ',
                            prefix: Icons.person),
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
                            prefix: Icons.email),
                        SizedBox(height: 30,),
                        defaultField(
                            controller: passwordController,
                            type: TextInputType.visiblePassword,
                            isPassword: ShopRegisterCubit.get(context).isPassword,
                            onSubmit: (value){

                            },
                            suffix: ShopRegisterCubit.get(context).suffix,
                            suffixPressed: (){
                              ShopRegisterCubit.get(context).changeIsPassword();
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

                        defaultField(
                            controller: phoneController,
                            type: TextInputType.phone,
                            validate: ( value){
                              if(value!.isEmpty){
                                return 'Please enter your phone ';
                              }
                              return null;
                            },
                            label: 'Phone ',
                            prefix: Icons.phone),
                        SizedBox(height: 30,),

                        ConditionalBuilder(
                          condition: state is! ShopRegisterLoadingState,
                          builder: (context) => defaultButton(text: 'Register',
                              function: ()
                              {
                                if(formKey.currentState!.validate())
                                {
                                  ShopRegisterCubit.get(context).userRegister(
                                    name: nameController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                  phone: phoneController.text
                                  );
                                }
                              }
                          ),
                          fallback: (context)=>Center(child: CircularProgressIndicator()),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
