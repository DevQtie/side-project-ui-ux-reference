import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Open Sheet and Dialog')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _openBottomSheet(context);
          },
          child: const Text('Open Sheet'),
        ),
      ),
    );
  }
}

void _openBottomSheet(BuildContext context) {
  // Keep a reference to the BottomSheet
  final notifier = Provider.of<BottomSheetNotifier>(context, listen: false);
  debugPrint(notifier._isToggled.toString());
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) {
      if (notifier.getInstance()) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _openDialog(context); // Open the Dialog
        });
      }
      return BottomSheetContent();
    },
  );
}

void _openDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('This is a Dialog'),
        content: const Text('The previously opened bottom sheet is closed.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}

class BottomSheetNotifier extends ChangeNotifier {
  var _isToggled = false;
  get toggle => _isToggled;

  void toggleDisposeBottomSheet() {
    _isToggled = false;
    notifyListeners();
  }

  void toggleShowBottomSheet() {
    _isToggled = true;
    notifyListeners();
  }

  bool getInstance() {
    return _isToggled;
  }
}

class BottomSheetContent extends StatefulWidget {
  const BottomSheetContent({super.key});

  @override
  State<BottomSheetContent> createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    final notifier = Provider.of<BottomSheetNotifier>(context, listen: false);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 16,
          left: 16,
          right: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('This is the Bottom Sheet'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                Future.delayed(Duration(seconds: 1), () {
                  if (navigator.canPop()) {
                    if (context.mounted) {
                      Navigator.pop(context); // Close the Bottom Sheet
                      notifier.toggleShowBottomSheet();
                      setState(() {});
                    }
                  }
                });
              },
              child: const Text('Open Dialog'),
            ),
          ],
        ),
      ),
    );
  }
}
