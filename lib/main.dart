import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:weater_app/services/weather_services.dart';
import 'package:weater_app/widget/weather_data_tile.dart';

void main() {
  runApp(const WetherApp());
}

class WetherApp extends StatelessWidget {
  const WetherApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WetherPage(),
    );
  }
}

class WetherPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WetherPageState();
}

class _WetherPageState extends State<WetherPage> {
  final TextEditingController _controller = TextEditingController();
  String _bgImg = 'assets/images/clear.jpg';
  String _iconImg = 'assets/icons/clear.png';
  String _cityName = '';
  String _temperature = '';
  String _tempMax = '';
  String _tempMin = '';
  String _sunset = '';
  String _sunrise = '';
  String _main = '';
  String _preassure = '';
  String _humidity = '';
  String _visiblity = '';
  String _windSpeed = '';
  // const WetherApp({super.key});
  getData(String cityName) async {
    final weatherService = WeatherServices();
    var weatherData;
    if (cityName == '') {
      weatherData = await weatherService.fetchWeather();
    } else {
      weatherData = await weatherService.getWeather(cityName);
    }

    debugPrint(weatherData.toString());
    setState(() {
      _cityName = weatherData['name'];
      _temperature = weatherData['main']['temp'].toString();
      _main = weatherData['weather'][0]['main'];
      _tempMax = weatherData['main']['temp_max'].toString();
      _tempMin = weatherData['main']['temp_min'].toString();
      _sunrise = DateFormat('hh:mm a').format(
          DateTime.fromMillisecondsSinceEpoch(
              weatherData['sys']['sunrise'] * 1000));
      _sunset = DateFormat('hh:mm a').format(
          DateTime.fromMillisecondsSinceEpoch(
              weatherData['sys']['sunset'] * 1000));
      _preassure = weatherData['main']['preasure'].toString();
      _humidity = weatherData['main']['humidity'].toString();
      _visiblity = weatherData['main']['visiblity'].toString();
      _windSpeed = weatherData['main']['speed'].toString();
      if (_main == 'Clear') {
        _bgImg = 'assets/images/clear.jpg';
        _iconImg = 'assets/icons/clear.png';
      } else if (_main == 'Clouds') {
        _bgImg = 'assets/images/clouds.jpg';
        _iconImg = 'assets/icons/clouds.png';
      } else if (_main == 'Rain') {
        _bgImg = 'assets/images/rain.jpg';
        _iconImg = 'assets/icons/rain.png';
      } else if (_main == 'Fog') {
        _bgImg = 'assets/images/fog.jpg';
        _iconImg = 'assets/icons/fog.png';
      } else if (_main == 'Thunderstorm') {
        _bgImg = 'assets/images/thunderstorm.jpg';
        _iconImg = 'assets/icons/storm.png';
      } else {
        _bgImg = 'assets/images/haze.jpg';
        _iconImg = 'assets/icons/haze.png';
      }
    });
  }

  Future<bool> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
      getData('');
    }
    getData('');
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Image.asset(
        _bgImg,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
      Padding(
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
            ),
            TextField(
              controller: _controller,
              onSubmitted: (value) => {getData(value)},
              decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.search),
                  filled: true,
                  hintText: 'Enter city name',
                  fillColor: Colors.black26,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)))),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_on),
                Text(
                  _cityName,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500),
                )
              ],
            ),
            SizedBox(height: 50),
            Text('$_temperature°c',
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 90,
                    fontWeight: FontWeight.bold)),
            Row(
              children: [
                Text(
                  _main,
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500),
                ),
                Image.asset(_iconImg, height: 80)
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              children: [
                const Icon(Icons.arrow_upward),
                Text(
                  '$_tempMax°c',
                  style: TextStyle(fontSize: 22, fontStyle: FontStyle.italic),
                ),
                const Icon(Icons.arrow_downward),
                Text(
                  '$_tempMin°c',
                  style: TextStyle(fontSize: 22, fontStyle: FontStyle.italic),
                )
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Card(
                elevation: 5,
                color: Colors.transparent,
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      WeatherDataTile(
                          index1: 'Sunrise',
                          index2: 'Sunset',
                          value1: _sunrise,
                          value2: _sunset),
                      SizedBox(
                        height: 15,
                      ),
                      WeatherDataTile(
                          index1: 'Humidity',
                          index2: 'Visiblity',
                          value1: _humidity,
                          value2: _visiblity),
                      SizedBox(
                        height: 15,
                      ),
                      WeatherDataTile(
                          index1: 'Pressure',
                          index2: 'Wind Speed',
                          value1: _preassure,
                          value2: _windSpeed),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ))
          ],
        )),
      )
    ]));
  }
}
