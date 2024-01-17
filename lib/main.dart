import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WeatherApp(),
    );
  }
}

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  String apiKey = "YOUR_API_KEY";
  Position? currentPosition;
  String currentLocation = "City, Country"; // Default location

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // Function to get the current location
  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        currentPosition = position;
      });
      // Call function to fetch weather data based on location
      _fetchWeatherData();
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  // Function to fetch weather data based on location
  void _fetchWeatherData() {
    // Implement the logic to fetch weather data from the API
    // using the currentPosition.latitude and currentPosition.longitude
    // and update the UI accordingly.
    // You may use a package like http or dio for making API requests.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Current Location:',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              currentLocation,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            if (currentPosition != null)
              Text(
                'Latitude: ${currentPosition!.latitude}\nLongitude: ${currentPosition!.longitude}',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
