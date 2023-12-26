import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/componets/componets.dart';
import 'package:shop_app/componets/constans.dart';
import 'package:shop_app/shop_app/shop_layout/cubit/cubit.dart';
import 'package:shop_app/shop_app/shop_layout/cubit/states.dart';

class SettingsScreen extends StatelessWidget {

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();

var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {


    return BlocConsumer<ShopCubit,ShopStates>(
      listener: (context,state){},
      builder: (context,state){

        var model = ShopCubit.get(context).userModel;

        nameController.text = model!.data!.name!;
        emailController.text = model.data!.email!;
        phoneController.text = model.data!.phone!;

        return  ConditionalBuilder(
          condition: ShopCubit.get(context).userModel != null,
          builder: (context)=> Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    if(state is ShopLoadingUpdateUserState)
                    LinearProgressIndicator(),
                    SizedBox(height: 20,),

                    defaultField(
                        controller: nameController,
                        type: TextInputType.text,
                        validate: (value){
                          if(value!.isEmpty){
                            return 'name must not be empty';
                          }
                          return null;
                        },
                        label: 'Name',
                        prefix: Icons.person),
                    SizedBox(height: 20,),
                    defaultField(
                        controller: emailController,
                        type: TextInputType.emailAddress,
                        validate: (value){
                          if(value!.isEmpty){
                            return 'email must not be empty';
                          }
                          return null;
                        },
                        label: 'Email Address',
                        prefix: Icons.email),
                    SizedBox(height: 20,),
                    defaultField(
                        controller: phoneController,
                        type: TextInputType.phone,
                        validate: (value){
                          if(value!.isEmpty){
                            return 'phone must not be empty';
                          }
                          return null;
                        },
                        label: 'Phone',
                        prefix: Icons.phone),
                    SizedBox(height: 20,),

                    defaultButton(text: 'Update', function: ()
                    {
                      if(formKey.currentState!.validate()){
                        ShopCubit.get(context).updateUserData(
                            name: nameController.text,
                            email: emailController.text,
                            phone: phoneController.text);

                      }

                    }),
                    SizedBox(height: 20,),

                    defaultButton(text: 'Logout', function: ()
                    {
                      signOut(context);
                    }),
                  ],
                ),
              ),
            ),
          ),
          fallback: (context)=> Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
