import 'dart:async';

import 'package:flutter/material.dart';

class DialogUncommon {
  void showAnimatedDialog(BuildContext context, String messageData) {
    //it will be dismissed through human-intervention
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (context, animation1, animation2) {
        return Align(
          alignment: Alignment.center,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: animation1,
              curve: Curves.easeOutBack,
            ),
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(messageData),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  void showAutoDismissDialog(
      BuildContext context, String messageData, IconData icon, Color color) {
    // Completer to track the dialog state
    final Completer<void> dialogCompleter = Completer<void>();
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (context, animation1, animation2) {
        final Brightness brightness = MediaQuery.of(context).platformBrightness;
        final bool isDarkMode = brightness == Brightness.dark;

        // Use `Navigator.of(context)` to get the navigator before the delay.
        final navigator = Navigator.of(context);

        // Auto-dismiss the dialog after 1.5 seconds
        Future.delayed(const Duration(milliseconds: 3000), () {
          if (!dialogCompleter.isCompleted && navigator.canPop()) {
            navigator.pop();
          }
        });

        return FadeTransition(
          opacity: animation1,
          child: Align(
            alignment: Alignment.center,
            child: ScaleTransition(
              scale: CurvedAnimation(
                parent: animation1,
                curve: Curves.easeOutBack,
              ),
              child: Dialog(
                backgroundColor: Colors.black87.withAlpha(200),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icon,
                        color: color,
                      ),
                      const SizedBox(
                        height: 4.0,
                      ),
                      Text(
                        messageData,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    ).then((_) {
      // Mark the dialog as dismissed when it's popped or dismissed
      if (!dialogCompleter.isCompleted) {
        dialogCompleter.complete();
      }
    });
  }
}
