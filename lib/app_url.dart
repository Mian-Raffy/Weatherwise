import 'dart:convert';
import 'package:WeatherWise/model/model.dart';
import 'package:WeatherWise/utils.dart';
import 'package:http/http.dart' as http;

class WeatherApi {
  ApiResponse? response;
  String message = '';
  bool inProgress = false;
  final String baseUrl = "http://api.weatherapi.com/v1/current.json";
  String apikey = 'd057d0d6b6584673817102606242105';

  Future<ApiResponse?> getCurrentWeather(String location) async {
    String apiUrl = "$baseUrl?key=$apikey&q=$location";
    try {
      final response = await http.get(Uri.parse(apiUrl));
      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print(data);
        Utils().saveLastSearchedLocation(location);
        return ApiResponse.fromJson(
            data); // Assuming ApiResponse has a fromJson method
      } else {
        // Log the response body for better debugging
        Utils().toastMessage(
            ' ${data['error']['message'] ?? 'Unknown error'} Please correct the spelling');
        return null;
      }
    } catch (e) {
      // Log the error for better debugging
      Utils().toastMessage('Internet connection lost');
      throw Exception(" $e");
    }
  }

  getWeatherData(String location) async {
    inProgress = true;

    try {
      response = await WeatherApi().getCurrentWeather(location);
      if (response != null) {
        await Utils().saveLastWeatherData(response!);
      } else {
        message = "Failed to get weather data";
      }
    } catch (e) {
      message = "Failed to get weather";
      response = null;
    } finally {
      inProgress = false;
    }
  }
}
