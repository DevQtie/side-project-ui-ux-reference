import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class GoRouterMobile {
  static CustomTransitionPage noTransition(
    GoRouterState state,
    Widget page,
  ) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: page,
      transitionDuration: Duration.zero,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          child,
    );
  }
}

final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _navigatorKey,
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => GoRouterMobile.noTransition(
        state,
        Home(),
      ),
      // routes: [
      //   GoRoute(
      //     path: 'page1',
      //     pageBuilder: (context, state) => GoRouterMobile.noTransition(
      //       state,
      //       Page1(),
      //     ),
      //     routes: [
      //       GoRoute(
      //         path: 'page2',
      //         pageBuilder: (context, state) => GoRouterMobile.noTransition(
      //           state,
      //           Page2(),
      //         ),
      //       ),
      //     ],
      //   ),
      // ],
    ),
    GoRoute(
      path: '/page1',
      pageBuilder: (context, state) => GoRouterMobile.noTransition(
        state,
        Page1(),
      ),
    ),
    GoRoute(
      path: '/page2',
      pageBuilder: (context, state) => GoRouterMobile.noTransition(
        state,
        Page2(),
      ),
    ),
  ],
);

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FocusNode? _homeFocusNode;

  @override
  void initState() {
    super.initState();
    _homeFocusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _homeFocusNode!.requestFocus();
    });
  }
  
  @override
  void dispose() {
    _homeFocusNode!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Home'),
            SizedBox(
              height: 8,
            ),
            TextField(
              focusNode: _homeFocusNode,
            ),
            SizedBox(
              height: 8,
            ),
            ElevatedButton(
              onPressed: () {
                kIsWeb
                    ? context.go('/page1')
                    : GoRouter.of(context).push(Uri(path: '/page1').toString());
              },
              child: Text('Go to Page 1'),
            ),
          ],
        ),
      ),
    );
  }
}

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  FocusNode? _page1FocusNode;

  @override
  void initState() {
    super.initState();
    _page1FocusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _page1FocusNode!.requestFocus();
    });
  }
  
  @override
  void dispose() {
    _page1FocusNode!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (context, visible) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, Object? result) async {
          if (didPop) {
            return;
          }
          if (visible) {
            _page1FocusNode!.unfocus();
          } else {
            if (GoRouter.of(context).canPop()) {
              GoRouter.of(context).pop();
            }
          }
        },
        child: KeyboardDismissOnTap(
          dismissOnCapturedTaps: true,
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  if (GoRouter.of(context).canPop()) {
                    GoRouter.of(context).pop();
                  }
                },
                icon: Icon(CupertinoIcons.chevron_back),
              ),
              title: Text('Page 1'),
            ),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Page 1'),
                  SizedBox(
                    height: 8,
                  ),
                  TextField(
                    focusNode: _page1FocusNode,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // _page1FocusNode!.dispose();
                      kIsWeb
                          ? context.go('/page2')
                          : GoRouter.of(context)
                              .push(Uri(path: '/page2').toString());
                    },
                    child: Text('Go to Page 2'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class Page2 extends StatefulWidget {
  const Page2({super.key});

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  FocusNode? _page2FocusNode;

  @override
  void initState() {
    super.initState();
    _page2FocusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _page2FocusNode!.requestFocus();
    });
  }
  
  @override
  void dispose() {
    _page2FocusNode!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (context, visible) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, Object? result) async {
          if (didPop) {
            return;
          }
          if (visible) {
            _page2FocusNode!.unfocus();
          } else {
            if (GoRouter.of(context).canPop()) {
              GoRouter.of(context).pop();
            }
          }
        },
        child: KeyboardDismissOnTap(
          dismissOnCapturedTaps: true,
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  if (GoRouter.of(context).canPop()) {
                    GoRouter.of(context).pop();
                  }
                },
                icon: Icon(CupertinoIcons.chevron_back),
              ),
              title: Text('Page 2'),
            ),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Page 2'),
                  SizedBox(
                    height: 8,
                  ),
                  TextField(
                    focusNode: _page2FocusNode,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // _page2FocusNode!.dispose();
                      context.go('/');
                    },
                    child: Text('Go to Home'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
