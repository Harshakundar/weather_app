import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

class WeatherServices {
  final String apiKey = '6d2d8c939674b7c52b113f48f8b6a34c';

  Future<Map<String, dynamic>> getWeather(String cityName) async {
    const String apiKey = '6d2d8c939674b7c52b113f48f8b6a34c';
    final String url =
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));
      print(response);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Failed to load data: $e');
    }
  }

  Future<Map<String, dynamic>> fetchWeather() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double lat = position.latitude, long = position.longitude;
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&long=$long&appid=$apiKey&units=metric'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('failed to load data');
    }
  }
}
