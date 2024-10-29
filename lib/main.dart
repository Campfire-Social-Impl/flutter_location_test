import 'package:flutter/material.dart';
import 'package:location/location.dart';

void main() {
  runApp(const MyApp());
}

Future<bool> enableLocationPermission() async {
  Location location = Location();
  bool serviceEnabled;
  PermissionStatus permissionGranted;

  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return false;
    }
  }
  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return false;
    }
  }
  return true;
}

Future<LocationData> getLocation() async {
  Location location = Location();
  LocationData data = await location.getLocation();
  return data;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  LocationData? _locationData;

  @override
  void initState() {
    enableLocationPermission().then((value) {
      if (value) {
        getLocation().then((value) {
          setState(() {
            _locationData = value;
          });
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              final status = await enableLocationPermission();
              if (status) {
                final data = await getLocation();
                setState(() {
                  _locationData = data;
                });
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _locationData != null
              ? [
                  Text(
                    "lng: ${_locationData!.longitude.toString()}",
                  ),
                  Text(
                    "lat: ${_locationData!.latitude.toString()}",
                  ),
                  Text(
                    "accuracy: ${_locationData!.accuracy.toString()}",
                  ),
                  Text(
                    "altitude: ${_locationData!.altitude.toString()}",
                  )
                ]
              : [
                  const CircularProgressIndicator(),
                  const Text('Getting location...'),
                  const Text('Press refresh button to retry'),
                ],
        ),
      ),
    );
  }
}
