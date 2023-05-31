import 'package:flutter/material.dart';

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        child: Row(
          children: [
            //for(int i =0 ; i<10 ;i++)
            //Single item
            //drink
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(247, 200, 224, 1),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                          color: Color.fromRGBO(255, 180, 220, 1),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: Offset(0, 3))
                    ]),
                child: Image.asset(
                  "assets/images/fruit.png",
                  width: 50,
                  height: 50,
                ),
              ),
            ),

            //Single item
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(247, 200, 224, 1),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromRGBO(255, 180, 220, 1),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: Offset(0, 3))
                      ]),
                  child: Image.asset(
                    "assets/images/dessert.png",
                    width: 50,
                    height: 50,
                  )),
            ), //Single item
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(247, 200, 224, 1),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                          color: Color.fromRGBO(255, 180, 220, 1),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: Offset(0, 3))
                    ]),
                child: Image.asset(
                  "assets/images/ham.png",
                  width: 50,
                  height: 50,
                ),
              ),
            ), //Single item
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(247, 200, 224, 1),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                          color: Color.fromRGBO(255, 180, 220, 1),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: Offset(0, 3))
                    ]),
                child: Image.asset(
                  "assets/images/tek.png",
                  width: 50,
                  height: 50,
                ),
              ),
            ), //Single item
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(247, 200, 224, 1),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                          color: Color.fromRGBO(255, 180, 220, 1),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: Offset(0, 3))
                    ]),
                child: Image.asset(
                  "assets/images/coke.png",
                  width: 50,
                  height: 50,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
