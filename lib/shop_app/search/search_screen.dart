import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/componets/componets.dart';
import 'package:shop_app/shop_app/search/cubit/cubit.dart';
import 'package:shop_app/shop_app/search/cubit/states.dart';

class SearchScreen extends StatelessWidget {

  var formKey = GlobalKey<FormState>();

  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(

      create: (BuildContext context) =>SearchCubit(),

      child: BlocConsumer<SearchCubit,SearchStates>(
        listener: (context,state){},
        builder: (context,state){

          return Scaffold(
            appBar: AppBar(),
            body: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [

                    defaultField(
                        controller: searchController,
                        type: TextInputType.text,
                        onSubmit: (text){
                          SearchCubit.get(context).search(text);
                        },
                        validate: (value){
                          if(value!.isEmpty){
                            return 'enter text to search';
                          }
                          return null;
                        },
                        label: 'Search',
                        prefix: Icons.search),
                    SizedBox(height: 20,),

                    if(state is SearchLoadingState)
                    LinearProgressIndicator(),

                    if(state is SearchSuccessState)
                    Expanded(
                      child: ListView.separated(
                          itemBuilder: (context,index) => buildListProduct(SearchCubit.get(context).searchModel!.data!.data![index],context,isOldPrice: false),
                          separatorBuilder: (context,index) => Container(
                            height: 1,
                            width: double.infinity,
                            color: Colors.grey,
                          ),
                          itemCount: SearchCubit.get(context).searchModel!.data!.data!.length),
                    ),

                  ],
                ),
              ),
            )
          );
        },

      ),
    );
  }
}
