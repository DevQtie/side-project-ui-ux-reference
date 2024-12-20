import 'package:flutter/material.dart';

class RecursiveCallTest extends StatefulWidget {
  const RecursiveCallTest({super.key});

  @override
  State<RecursiveCallTest> createState() => _RecursiveCallTestState();
}

class _RecursiveCallTestState extends State<RecursiveCallTest> {
  String? phone;

  Future<String>? _delayThisMethod() {
    Future.delayed(const Duration(milliseconds: 5000), () {
      return 'test';
    });
    return null;
  }

  Future<void> showModal() {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('New bottom sheet'),
                SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () {
                    // launchCall(phone);
                    phone = null;
                    Navigator.of(context).pop();
                  },
                  child: Text('Test Button Sample'),
                ),
              ],
            ));
  }

  Future<void> handleBuyerCall(BuildContext context, [String kms = 'test']
      // NumberMasking numberMasking,
      ) async {
    if (kms != "") {
      // await numberMasking
      //     .getNumberMasking(kms.Value!);
      phone = await _delayThisMethod();

      if (phone != null) {
        if (context.mounted) {
        await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('New bottom sheet'),
                SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () {
                    // launchCall(phone);
                    phone = null;
                    Navigator.of(context).pop();
                  },
                  child: Text('Test Button Sample'),
                ),
              ],
            )
        );
      }
      } else {
        if (context.mounted) {
          await showModalBottomSheet(
            context: context,
            builder: (BuildContext context) => ElevatedButton(
              onPressed: () {
                phone = 'is_not_null';
                Navigator.of(context).pop();
                handleBuyerCall(context);
              },
              child: Text('Try Again (recursion testing)'),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recursive Call Test'),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              handleBuyerCall(context);
            },
            child: Text('Show BottomSheet')),
      ),
    );
  }
}
