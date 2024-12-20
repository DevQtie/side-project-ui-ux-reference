import 'package:flutter/material.dart';
import 'package:flutter_observer/flutter_test/home_stuff.dart';

class MainStuff extends StatefulWidget {
  const MainStuff({super.key});

  @override
  State<MainStuff> createState() => _MainStuffState();
}

class _MainStuffState extends State<MainStuff> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        toolbarHeight: 120,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Text("testing scrolling"),
        scrolledUnderElevation: 20,
        elevation: 20,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Material(
              elevation: 10,
              shadowColor: Colors.black26,
                color: Colors.white,
                child: TabBar(
                  labelColor: Colors.green[700],
                          labelStyle: TextStyle(fontWeight: FontWeight.w800),
                          tabs: [
                Tab(text: "Home", icon: Icon(Icons.home),),
                Tab(text: "Our Story", icon: Icon(Icons.people_alt),),
                Tab(text: "Shop", icon: Icon(Icons.storefront_outlined),),
                Tab(text: "Special Offers", icon: Icon(Icons.star),),
                Tab(text: "Contact Us", icon: Icon(Icons.call),)
                          ],
                          controller: _tabController,
                        ),
              ),
            SizedBox(
              height: 500,
              child: TabBarView(
                controller: _tabController,
                children: [
                  Home(),
                  Center(child: Text("Our Story")),
                  Center(child: Text("Shop")),
                  Center(child: Text("Special Offers")),
                  Center(child: Text("Contact Us")),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}