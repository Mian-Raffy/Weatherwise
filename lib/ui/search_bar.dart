import 'dart:convert';

import 'package:WeatherWise/app_url.dart';
import 'package:WeatherWise/ui/home_screen.dart';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  final searchController = TextEditingController();

  var uuid = Uuid();
  String _sessionToken = '';
  List<dynamic> _placeList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> getSuggestion(String input) async {
    if (input.isEmpty) {
      setState(() {
        _placeList = [];
      });
      return;
    }
    String apiKey = 'AIzaSyCT1_CquKvIuNoCOxbsWOBo3U4Zq_58f2Y';
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$apiKey&sessiontoken=$_sessionToken';

    var response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      print(_placeList);
      setState(() {
        _placeList = jsonDecode(response.body.toString())['predictions'];
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                onSubmitted: (value) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ));
                  WeatherApi().getWeatherData(value);
                },
                style: TextStyle(color: Colors.white),
                cursorColor: Colors.amber,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.black)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    hintText: "Search any location",
                    hintStyle: TextStyle(color: Colors.white),
                    fillColor: Colors.black,
                    filled: true),
                controller: searchController,
                onChanged: (value) {
                  getSuggestion(value);
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _placeList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      searchController.text =
                          _placeList[index]['description'].toString();
                    },
                    title: Text(_placeList[index]['description']),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
