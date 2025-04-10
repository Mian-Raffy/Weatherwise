import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchbarController extends GetxController {
  var searchontroller = TextEditingController();
  var _sessionToken = '';
  // var _placeList = <dynamic>[];

  RxList<dynamic> placeList = <dynamic>[].obs;

  // This method fetches the suggestions based on the user input
  Future<void> getSuggestions(String input) async {
    if (input.isEmpty) {
      placeList.clear();
      return;
    }

    String apiKey = 'AIzaSyCT1_CquKvIuNoCOxbsWOBo3U4Zq_58f2Y';
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$apiKey&sessiontoken=$_sessionToken';

    var response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body.toString());
      placeList.value = result['predictions'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  void updateSessionToken(String token) {
    _sessionToken = token;
  }
}
