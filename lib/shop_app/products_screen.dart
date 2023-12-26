import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/componets/componets.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/shop_app/shop_layout/cubit/cubit.dart';
import 'package:shop_app/shop_app/shop_layout/cubit/states.dart';
import 'package:shop_app/styles/colors.dart';

class ProductsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<ShopCubit,ShopStates>(
      listener: (context,state){

        if(state is ShopSuccessChangeFavoritesState){
          if(!state.model.status!){

            showToastStates(
                text: state.model.message!,
                state: ToastStates.ERROR);
          }
        }

      },
      builder: (context,state){

        return ConditionalBuilder(
            condition: ShopCubit.get(context).homeModel != null && ShopCubit.get(context).categoriesModel != null ,

            builder: (context)=>  productsBuilder(ShopCubit.get(context).homeModel!,ShopCubit.get(context).categoriesModel!,context),

            fallback: (context)=>Center(child: CircularProgressIndicator()));
      },

    );
  }


  Widget productsBuilder(HomeModel model, CategoriesModel categoriesModel,context) => SingleChildScrollView(
    physics: BouncingScrollPhysics(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CarouselSlider(
            items: model.data!.banners.map((e) =>  Image(
              image: NetworkImage(
                '${e.image}',
              ),
              width: double.infinity,
            )).toList(),

            options: CarouselOptions(
              height: 250.0,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(seconds: 1),
              autoPlayCurve: Curves.fastOutSlowIn,
              scrollDirection: Axis.horizontal,
              viewportFraction: 1
            )),
        SizedBox(height: 10.0,),

  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Categories',
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 10.0,),

                    Container(
                      height: 100,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context,index) => buildCategoryItem (categoriesModel.data!.data![index]),
                          separatorBuilder: (context,index) => SizedBox(width: 10.0,),
                          itemCount: categoriesModel.data!.data!.length),
                    ),
                    SizedBox(height: 20.0,),
                    Text(
                      'New Products',
                      style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold
                      ),
                    ),
            ],
          ),
        ),
      ],
    ),
  ),


        Container(
  color: Colors.grey[300],
  child: GridView.count(
  shrinkWrap: true,
  physics: NeverScrollableScrollPhysics(),
  crossAxisCount: 2,
  mainAxisSpacing: 1.0,
  crossAxisSpacing: 1.0,
  childAspectRatio: 1/1.7,
  children: List.generate(
  model.data!.products.length,
  (index) =>buildGridProduct(model.data!.products[index],context)

  ),
  )
  ),
]
          ),
        );





  Widget buildGridProduct(ProductModel model,context)=> Container(
    color: Colors.white,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            Image(image: NetworkImage(model.image!),
              width: double.infinity,
              height: 200,
            ),
            if(model.discount != 0)
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

        Padding(
          padding: const EdgeInsets.all(12.0),
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
              Row(
                children: [
                  Text(
                    '${model.price.round()}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 12.0,
                      color: defaultColor
                    ),
                  ),
                  SizedBox(width: 5,),
                  if(model.discount != 0)
                  Text(
                    '${model.oldPrice.round()}',
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
                        print(model.id);

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
  );


  Widget buildCategoryItem (DataModel model) =>     Stack(

    alignment: AlignmentDirectional.bottomCenter,
    children: [

      Image(
        image: NetworkImage(
          model.image!
        ),
        height: 100.0,
        width: 100.0,
        fit: BoxFit.cover,
      ),
      Container(
        color: Colors.black.withOpacity(.8),
        width: 100.0,
        child: Text(
          model.name!,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: Colors.white
          ),
        ),
      )
    ],
  );


}
