import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_weather_app/Widget/Self_Location_Widget.dart';

class SelfLocation extends StatelessWidget {
  final WeatherService weatherService = WeatherService('YOUR_API_KEY');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Weather App with Location'),
          centerTitle: true,
        ),
        body: LocationWeatherWidget(weatherService),
      ),
    );
  }
}

class LocationWeatherWidget extends StatefulWidget {
  final WeatherService weatherService;

  LocationWeatherWidget(this.weatherService);

  @override
  _LocationWeatherWidgetState createState() => _LocationWeatherWidgetState();
}

class _LocationWeatherWidgetState extends State<LocationWeatherWidget> {
  String latitude = 'Latitude: ';
  String longitude = 'Longitude: ';
  Map<String, dynamic>? weatherData;
  DateTime currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        latitude = 'Latitude: ${position.latitude}';
        longitude = 'Longitude: ${position.longitude}';
      });

      // Fetch weather data using obtained location
      _getWeather(position.latitude, position.longitude);
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _getWeather(double latitude, double longitude) async {
    try {
      final data = await widget.weatherService.getWeather(latitude, longitude);

      // Extract date information from the API response
      final timestamp = data?['dt'];
      if (timestamp != null) {
        setState(() {
          currentTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
        });
      }

      setState(() {
        weatherData = data;
      });
    } catch (e) {
      print('Error fetching weather data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (weatherData != null)
            Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                         '${_formatTime(currentTime)} ',
                      style: const TextStyle(fontSize: 35,),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      ' ${_formatDate(currentTime)} ',
                      style: const TextStyle(fontWeight: FontWeight.w700,),
                    ),
                  ],
                ),
                Container(
                  height: MediaQuery.sizeOf(context).height * 0.08,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        "http://openweathermap.org/img/wn/${weatherData?['weather']?[0]?['icon']}@4x.png",
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      ' ${weatherData?['weather']?[0]?['description']}',
                        style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,),
                    ),
                  ],
                ),
                  Text(
                  ' ${weatherData?['main']?['temp']}°C',
                  style: const TextStyle(
                  color: Colors.black,
                  fontSize: 50,
                  fontWeight: FontWeight.w500,
                  ),
                  ),
                Container(
                  height: MediaQuery.sizeOf(context).height*0.15,
                  width: MediaQuery.sizeOf(context).width*0.80,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                              'Humidity: ${weatherData?['main']?['humidity']}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,)
                          ),
                          Text(
                            'Wind Speed: ${weatherData?['wind']?['speed']} m/s',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                              'Max Temperature: ${weatherData?['main']?['temp_max']}°C',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,)
                          ),
                          Text(
                            'Min Temperature: ${weatherData?['main']?['temp_min']}°C',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    int hour = dateTime.hour;
    return '${hourOfPeriod(hour)}:${dateTime.minute.toString().padLeft(2, '0')} ${periodOfDay(hour)}';
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  String hourOfPeriod(int hour) {
    return (hour == 0 || hour == 12) ? '12' : (hour % 12).toString();
  }

  String periodOfDay(int hour) {
    return hour < 12 ? 'AM' : 'PM';
  }
}
