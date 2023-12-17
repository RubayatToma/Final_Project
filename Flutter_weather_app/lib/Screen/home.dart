import 'package:flutter/material.dart';
import 'package:flutter_weather_app/Resource/api_key.dart';
import 'package:flutter_weather_app/Screen/Self_Location.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);
  Weather? _weather;
  String _selectedCity = "Dhaka";

  @override
  void initState() {
    super.initState();
    _getWeatherData();
  }

  void _getWeatherData() {
    _wf.currentWeatherByCityName(_selectedCity).then((w) {
      setState(() {
        _weather = w;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
        centerTitle: true,

      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    if (_weather == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              // Navigate to DetailPage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SelfLocation()),
              );
            },
            child: Text('Self Location Weather'),
          ),
          _buildCityInput(),

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          _dateTimeInfo(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          _weatherIcon(),

          _currentTemp(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          _extraInfo(),
        ],
      ),
    );
  }



  Widget _buildCityInput() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Enter City',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _selectedCity = value;
                });
              },
            ),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {
              _getWeatherData();
            },
            child: Text('Get Weather'),
          ),
        ],
      ),
    );
  }


  Widget _locationHeader(){
    return Text(
      _weather?.areaName ?? "",
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    );
  }
  Widget _dateTimeInfo(){
    DateTime now = _weather!.date!;
    return Column(
      children: [
        Text(
          DateFormat("h:mm a").format(now),
          style: const TextStyle(
            fontSize: 35,
          ),
      ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              DateFormat("EEE").format(now),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              "${DateFormat("d.M.y").format(now)}",
              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        )

      ],
    );
  }
  Widget _weatherIcon(){
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.sizeOf(context).height * 0.20,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage("http://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png")
            )
          ),
        ),
        Text(
          _weather?.weatherDescription ?? "",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ],
    );
  }
  Widget _currentTemp(){
       return Text(
         "${_weather?.temperature?.celsius?.toStringAsFixed(0)}°C",
         style: const TextStyle(
           color: Colors.black,
           fontSize: 90,
           fontWeight: FontWeight.w500,
         ),
       );
  }
  Widget _extraInfo(){
    print("Weather Object: $_weather");
    return Container(
      height: MediaQuery.sizeOf(context).height*0.15,
      width: MediaQuery.sizeOf(context).width*0.80,
      decoration: BoxDecoration(
        color: Colors.deepPurple,
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
                  "Max ${_weather?.tempMax?.celsius?.toStringAsFixed(0)}°C",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  )
              ),
              Text(
                  "Min ${_weather?.tempMin?.celsius?.toStringAsFixed(0)}°C",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  )
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                  "Wind ${_weather?.windSpeed?.toStringAsFixed(0)} m/s",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  )
              ),
              Text(
                  "Humidity ${_weather?.humidity?.toStringAsFixed(0)}%",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  )
              ),
            ],

          )
        ],
      ),
    );
  }

}
