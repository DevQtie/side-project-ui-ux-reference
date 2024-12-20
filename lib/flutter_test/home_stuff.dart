import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> images = ["Flutter.png", "Flutter.png"];
  final PageController _sliderController = PageController();
  int currImage = 0;
  late PageView imageCarousel;
  @override
  void initState() {
    super.initState();
    imageCarousel = PageView.builder(
              controller: _sliderController,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => Image.asset(
                "assets/images/${images[index % images.length]}",
                // fit: BoxFit.cover,
              ),
            );
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 400),
          child: Stack(children: [
            imageCarousel,
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                  onPressed: () {
                    _sliderController.previousPage(
                        duration: Duration(seconds: 1), curve: Curves.easeIn);
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: CircleBorder(),
                      backgroundColor: Colors.white70,
                      foregroundColor: Colors.black),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.arrow_back_ios_rounded,
                      size: 40,
                    ),
                  )),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                  onPressed: () {
                    _sliderController.nextPage(
                        duration: Duration(seconds: 1), curve: Curves.easeIn);
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: CircleBorder(),
                      backgroundColor: Colors.white70,
                      foregroundColor: Colors.black),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 40,
                    ),
                  )),
            )
          ]),
        ),
        Row(
          children: [
            for (int i = 0; i < 4; i++)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                  padding: const EdgeInsets.all(8.0),
                  child: Image(image: AssetImage("assets/images/Flutter.png"))),
        ])
      ],
    );
  }
}