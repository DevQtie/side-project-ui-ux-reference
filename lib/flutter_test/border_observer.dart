import 'package:flutter/material.dart';

class BorderObserver extends StatelessWidget {
  const BorderObserver({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Container(
            // height: 100,
            // width: 350,
            padding: EdgeInsets.symmetric(vertical: 100, horizontal: 100),
            decoration: BoxDecoration(
              border: Border(
                  left: BorderSide(
                    color: Colors.red, //Theme.of(context).primaryColor,
                    width: 10,
                  ),
                  top: BorderSide.none,
                  right: BorderSide.none,
                  bottom: BorderSide.none),
              color: Colors.white,
              // borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
      ),
    );
  }
}
