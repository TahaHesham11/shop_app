import 'package:flutter/material.dart';
import 'package:shop_app/componets/componets.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/network/local/cache_helper.dart';
import 'package:shop_app/styles/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BoardingModel{

  final String image;
  final String title;
  final String body;
  BoardingModel({
    required this.image,
    required this.title,
    required this.body
});

}

class OnBoardingScreen extends StatefulWidget {

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  List<BoardingModel> boarding = [
    BoardingModel(
        image: 'assets/images/Onboard.png',
      title: 'On Board  1  Title',
      body: 'On Board  1  Body'
    ),
    BoardingModel(
        image: 'assets/images/Onboard.png',
        title: 'On Board  2  Title',
        body: 'On Board  2  Body'
    ),
    BoardingModel(
        image: 'assets/images/Onboard.png',
        title: 'On Board  3  Title',
        body: 'On Board  3  Body'
    ),
  ];

  var boardController = PageController();

  bool isLast = false;


  void submit (){

    CacheHelper.saveData(key: 'onBoarding', value: true).then((value) {


      if(value){
        navigateTo(context, ShopLoginScreen());

      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        actions: [

defaultTextButton(
    function: submit,
    text: 'SKIP')
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(

          children: [
            Expanded(
              child: PageView.builder(
                controller: boardController,
                onPageChanged: (index){
                  if(index == boarding.length -1){

                    setState(() {
                      isLast = true;
                    });
                  }else{
                    setState(() {
                      isLast = false;
                    });                  }
                },
                physics: BouncingScrollPhysics(),
                  itemBuilder: (context,index)=> buildBoardingItem(boarding[index]),
              itemCount: 3,
              ),
            ),
            SizedBox(height: 40,),
            Row(
              children: [
               SmoothPageIndicator(
                   controller: boardController,
                   count: boarding.length,
               effect: ExpandingDotsEffect(
                 dotColor: Colors.grey,
                 activeDotColor: defaultColor,
                 dotHeight: 10,
                 dotWidth: 10,
                 expansionFactor: 4,
                 spacing: 5.0
               ),
               ),
                Spacer(),
                FloatingActionButton(onPressed: (){
                  if(isLast){

                    submit();
                  }else{
                    boardController.nextPage(
                        duration: Duration(
                          milliseconds: 750,),
                        curve: Curves.bounceInOut);

                  }

                },child: Icon(Icons.arrow_forward_ios),)
              ],
            )
          ],
        ),
      )
    );
  }

  Widget buildBoardingItem(BoardingModel model) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Image(
            image: AssetImage
              (
                '${model.image}'
            )
        ),
      ),
      Text(
        '${model.title}',
        style: TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.bold,

        ),
      ),
      SizedBox(height: 15,),
      Text(
        '${model.body} ',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,

        ),
      ),
    ],
  );
}


