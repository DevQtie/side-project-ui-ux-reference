import 'package:flutter/material.dart';

class GrandParent extends StatelessWidget {
  const GrandParent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FocusNode Test'),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Parent()),
              );
            },
            child: Text('Go to Parent')),
      ),
    );
  }
}

class Parent extends StatefulWidget {
  const Parent({super.key});

  @override
  State<Parent> createState() => _ParentState();
}

class _ParentState extends State<Parent> {
  FocusNode? _focusNode1;
  FocusNode? _focusNode2;

  @override
  void initState() {
    super.initState();
    _focusNode1 = FocusNode();
    _focusNode2 = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode1!.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode1!.dispose();
    _focusNode2!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text('FocusNode Test'),
      ),
      body: Center(
        child: isSmallScreen
            ? ChildOne(
                focusNode1: _focusNode1,
                focusNode2: _focusNode2,
              )
            : ChildTwo(
                focusNode1: _focusNode1,
                focusNode2: _focusNode2,
              ),
      ),
    );
  }
}

class ChildOne extends StatefulWidget {
  final FocusNode? focusNode1;
  final FocusNode? focusNode2;
  const ChildOne(
      {super.key, required this.focusNode1, required this.focusNode2});

  @override
  State<ChildOne> createState() => _ChildOneState();
}

class _ChildOneState extends State<ChildOne> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber[600],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Small Screen Widget',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 8,
          ),
          TextField(
            focusNode: widget.focusNode1,
            decoration: InputDecoration(hintText: 'FocusNode 1'),
          ),
          TextField(
            focusNode: widget.focusNode2,
            decoration: InputDecoration(hintText: 'FocusNode 2'),
          ),
        ],
      ),
    );
  }
}

class ChildTwo extends StatefulWidget {
  final FocusNode? focusNode1;
  final FocusNode? focusNode2;
  const ChildTwo(
      {super.key, required this.focusNode1, required this.focusNode2});

  @override
  State<ChildTwo> createState() => _ChildTwoState();
}

class _ChildTwoState extends State<ChildTwo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amberAccent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Large Screen Widget'),
          SizedBox(
            height: 8,
          ),
          TextField(
            focusNode: widget.focusNode1,
            decoration: InputDecoration(hintText: 'FocusNode 1'),
          ),
          TextField(
            focusNode: widget.focusNode2,
            decoration: InputDecoration(hintText: 'FocusNode 2'),
          ),
        ],
      ),
    );
  }
}
