import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class ObserveReadmoreText extends StatefulWidget {
  const ObserveReadmoreText({super.key});

  @override
  State<ObserveReadmoreText> createState() => _ObserveReadmoreTextState();
}

class _ObserveReadmoreTextState extends State<ObserveReadmoreText> {
  String loremIpsum =
      'Lorem ipsum dolor sit amet, consectetuer adipiscing elit.Maecenas porttitor congue massa. Fusce posuere, magna sed pulvinar ultricies, purus lectus malesuada libero, sit amet commodo magna eros quis urna. Nunc viverra imperdiet enim. Fusce est. Vivamus a tellus. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Proin pharetra nonummy pede. Mauris et orci. Aenean nec lorem. In porttitor. Donec laoreet nonummy augue. Suspendisse dui purus, scelerisque at, vulputate vitae, pretium mattis, nunc. Mauris eget neque at sem venenatis eleifend. Ut nonummy.';

  TextStyle _readMoreTextStyle([bool isDark = true]) {
    // [bool isDark = false] optional param
    return isDark //sample condition, you add yours
        ? TextStyle(fontSize: 21, color: Colors.grey[200]) // other style..
        : TextStyle(fontSize: 21, color: Colors.grey[900]); // other style..
  } // add your conditional TextStyle here...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ReadMore Test'),
      ),
      body: Material(
        textStyle: Theme.of(context).textTheme.labelLarge,
        child: ReadMoreText(
          key: ValueKey('test'),
          loremIpsum,
          trimLines: 3,
          trimMode: TrimMode.Line,
          trimExpandedText: 'Read less',
          trimCollapsedText: 'Read more',
          moreStyle: Theme.of(context).textTheme.headlineLarge,
          lessStyle: Theme.of(context).textTheme.headlineLarge,
          // style:
          //     Theme.of(context).textTheme.headlineLarge!.copyWith(fontSize: 30),
          // style: _readMoreTextStyle(), //this does work

          annotations: [
            // Annotation 1: Hashtag (#)
            Annotation(
              regExp: RegExp(
                  r'#([a-zA-Z0-9_]+)'), // Matches text starting with # followed by letters, numbers, and underscores
              spanBuilder: ({required String text, TextStyle? textStyle}) =>
                  TextSpan(
                text: text, // Keeps the matched text
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge!
                    .copyWith(fontSize: 30), // Changes color to blue
              ),
            ),
          ],
        ),
      ),
    );
  }
}
