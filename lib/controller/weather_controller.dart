import 'package:WeatherWise/app_url.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:WeatherWise/model/model.dart';
import 'package:WeatherWise/utils.dart';

import '../ui/home_screen.dart';

class WeatherController extends GetxController {
  Rx<ApiResponse?> response = Rx<ApiResponse?>(null);
  RxBool inProgress = false.obs;
  RxString message = "Search for the location to get weather data".obs;

  @override
  void onInit() {
    super.onInit();
    checkConnectivity();
    loadLastWeatherData();
  }

  Rx<ConnectivityResult> connectivityStatus = ConnectivityResult.mobile.obs;

  void checkConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    connectivityStatus.value = result as ConnectivityResult;
  }

  Future<void> loadLastWeatherData() async {
    inProgress.value = true;
    try {
      ApiResponse? lastWeatherData = await Utils().getLastWeatherData();
      if (lastWeatherData != null) {
        response.value = lastWeatherData;
      }
    } catch (e) {
      response.value = null;
      print('The Previouses data error:$e');
    } finally {
      inProgress.value = false;
    }
  }

  Future<void> getWeatherData(String location, BuildContext context) async {
    inProgress.value = true;
    try {
      ApiResponse? data = await WeatherApi().getCurrentWeather(location);
      if (data != null) {
        response.value = data;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    } catch (e) {
      // Show error to user
      Utils().toastMessage('Internet Conection Problem');

      // Fallback to saved data
      ApiResponse? savedData = await Utils().getLastWeatherData();
      if (savedData != null) {
        response.value = savedData;
      } else {
        response.value = null;
      }
    } finally {
      inProgress.value = false;
    }
  }
}
