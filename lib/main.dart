import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sample_food_order_app/ui/product_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> _onTap() async {
    await showCupertinoModalBottomSheet(
      expand: true,
      enableDrag: false,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ProductPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            'Press Plus to go to next page',
            style: Theme.of(context).textTheme.headline4,
            textAlign: TextAlign.center,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onTap,
        tooltip: 'Increment',
        child: Icon(Icons.arrow_forward),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
