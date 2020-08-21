import 'package:flutter/material.dart';
import 'package:rshb/screens/products_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'rshb',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CatalogProducts(),
    );
  }
}

class CatalogProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'Каталог',
            style: TextStyle(color: Colors.black),
          ),
          leading: BackButton(color: Colors.black),
          backgroundColor: Colors.white,
         // elevation: 5.0,
        ),
        body: Container(
          margin: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
          child: Navigation(),
        ));
  }
}

class Navigation extends StatefulWidget {
  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize( //нужен для того, чтобы задать определенную высоту аппбара
              preferredSize: Size.fromHeight(50.0),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: AppBar(
                  elevation: 2,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                  backgroundColor: Colors.grey[100],
                  bottom: TabBar(
                      unselectedLabelColor: Colors.black,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                          border: Border.all(color: Colors.grey[100], width: 4),
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.green),
                      tabs: [
                        Tab(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text("Продукты"),
                          ),
                        ),
                        Tab(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text("Фермеры"),
                          ),
                        ),
                        Tab(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text("Агротуы"),
                          ),
                        ),
                      ]),
                ),
              )),
          body: TabBarView(
              children: [ProductsScreen(), Text('Фермеры'), Text('Агротуы')]),
        ));
  }
}
