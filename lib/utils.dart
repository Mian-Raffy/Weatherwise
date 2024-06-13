import 'dart:convert';
import 'package:WeatherWise/model/model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  static const String _lastSearchedLocationKey = 'lastSearchedLocation';
  static const String _lastWeatherDataKey = 'lastWeatherData';

  void toastMessage(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Future<void> saveLastSearchedLocation(String location) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastSearchedLocationKey, location);
  }

  Future<String?> getLastSearchedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastSearchedLocationKey);
  }

  Future<void> saveLastWeatherData(ApiResponse response) async {
    final prefs = await SharedPreferences.getInstance();
    String data = jsonEncode(response.toJson());
    await prefs.setString(_lastWeatherDataKey, data);
  }

  Future<ApiResponse?> getLastWeatherData() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(_lastWeatherDataKey);
    if (data != null) {
      return ApiResponse.fromJson(jsonDecode(data));
    }
    return null;
  }
}
