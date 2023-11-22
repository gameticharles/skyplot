import 'package:advance_math/advance_math.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:skyplot/skyplot.dart';
import 'package:raw_gnss/raw_gnss.dart';

import 'src/example.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'SkyPlot Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late RawGnss _rawGnss;
  var _hasPermissions = false;

  @override
  void initState() {
    super.initState();
    _rawGnss = RawGnss();

    Permission.location
        .request()
        .then((value) => setState(() => _hasPermissions = value.isGranted));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: SkyPlotGNSS(
              rawGnss: _rawGnss,
              hasPermissions: _hasPermissions,
              options: SkyPlotOptions(
                azimuthTextStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.normal),
                directionTextStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
                elevationTextStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.normal),
                showSkyObjectNotInFix: true,
                directionDetail: DirectionDetail.eight,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        children: [
          FloatingActionButton(
            onPressed: () {},
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: () {},
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: () {},
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: () {},
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        ].insertBetween<Widget>(const SizedBox(height: 5.0)).toList(),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
