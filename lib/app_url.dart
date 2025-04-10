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

      print('API Response: $data'); // Add this to see the API response

      if (response.statusCode == 200) {
        Utils().saveLastWeatherData(ApiResponse.fromJson(data));
        return ApiResponse.fromJson(data);
      } else {
        Utils().toastMessage(
            ' ${data['error']['message'] ?? 'Unknown error'} Please correct the spelling');
        return null;
      }
    } catch (e) {
      Utils().toastMessage('Internet connection lost');
      throw Exception("Error: $e");
    }
  }
}
