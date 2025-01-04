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
      routes: [
        GoRoute(
          path: 'page1', // for web browser purposes
          pageBuilder: (context, state) => GoRouterMobile.noTransition(
            state,
            Page1(),
          ),
          routes: [
            GoRoute(
              path: 'page2', // for web browser purposes
              pageBuilder: (context, state) => GoRouterMobile.noTransition(
                state,
                Page2(),
              ),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/page1', // for mobile app purposes
      pageBuilder: (context, state) => GoRouterMobile.noTransition(
        state,
        Page1(),
      ),
    ),
    GoRoute(
      path: '/page2', // for mobile app purposes
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Home'),
            SizedBox(
              height: 8,
            ),
            ElevatedButton(
              onPressed: () {
                kIsWeb
                    ? context.go('///page1')
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Page 1'),
            SizedBox(
              height: 8,
            ),
            ElevatedButton(
              onPressed: () {
                kIsWeb
                    ? context.go('///page1/page2')
                    : GoRouter.of(context).push(Uri(path: '/page2').toString());
              },
              child: Text('Go to Page 2'),
            ),
          ],
        ),
      ),
    );
  }
}

class Page2 extends StatefulWidget {
  const Page2({super.key});

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Page 2'),
              SizedBox(
                height: 8,
              ),
              ElevatedButton(
                onPressed: () {
                  context.go(
                      '/'); // to avoid having a page stack in the page cycle
                },
                child: Text('Go to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
