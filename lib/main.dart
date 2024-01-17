// main.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

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
  String apiKey = "e583354804fb5ed82c9c19cf604f7b56"; // Replace with your actual API key
  Position? currentPosition;
  String currentLocation = "City, Country"; // Default location
  dynamic weatherData;

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
  Future<void> _fetchWeatherData() async {
    try {
      String apiUrl = 'https://api.openweathermap.org/data/2.5/weather';
      String units = 'metric'; // You can change this to 'imperial' for Fahrenheit

      final response = await http.get(Uri.parse(
          '$apiUrl?lat=${currentPosition!.latitude}&lon=${currentPosition!.longitude}&appid=$apiKey&units=$units'));

      if (response.statusCode == 200) {
        setState(() {
          weatherData = json.decode(response.body);
        });
      } else {
        print("Error fetching weather data. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching weather data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
        centerTitle: true,
        backgroundColor: Colors.pink,
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
            SizedBox(height: 20),
            if (weatherData != null)
              Column(
                children: [
                  Text(
                    'Weather: ${weatherData['weather'][0]['main']}',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    'Temperature: ${weatherData['main']['temp']} °C',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
