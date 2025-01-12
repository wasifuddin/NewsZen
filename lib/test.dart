import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TestWidget extends StatelessWidget {
  const TestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold( // scaffold carries all the frontends of the project
      appBar: AppBar(
        title: Text(
            'Hi',
          style: TextStyle(
            color: Colors.yellow,
            fontSize: 20,
            fontWeight: FontWeight.bold
          )
        ),
        backgroundColor: Colors.blue,
        elevation: 0.0, // elevation decides the shadow below appbar
        centerTitle: true,
        leading: Container(// to wrap the child elements, setting colors and add empty spaces
          margin: EdgeInsets.all(10),
          // child: SvgPicture.asset('/assets/fonts/gg.svg'),
          decoration: BoxDecoration( // description of box applied to a rectangle
              color: Colors.white,
              borderRadius: BorderRadius.circular(10)
            ),
        ),
        actions: [

          GestureDetector(
              onTap: () {

          },
          child: Container(// to wrap the child elements, setting colors and add empty spaces
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration( // description of box applied to a rectangle
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)
            ),
          )
          ),
        ],
      ),
      body: Column(

        children: [
          Container(
            margin: EdgeInsets.only(top:40,left:20,right:20),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color(0xff00ff).withOpacity(0.11),
                  blurRadius: 40,
                  spreadRadius: 0.0
                ) // to cast a shadow in the box
              ]
            ),
            child: TextField(
              decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none
                    //we can use prefixicon to add icon as a prefix
                )
            ),
          ),
          ),
        ],
      ),
    );
  }
}
