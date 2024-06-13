import 'package:WeatherWise/model/model.dart';
import 'package:WeatherWise/ui/search_bar.dart';
import 'package:WeatherWise/utils.dart';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchController = TextEditingController();
  ApiResponse? response;
  bool inProgress = false;
  String message = "Search for the location to get weather data";

  @override
  void initState() {
    super.initState();

    loadLastWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
            shape: CircleBorder(),
            child: Icon(Icons.add_location_outlined, color: Colors.amber),
            backgroundColor: Colors.black,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchPage(),
                  ));
            }),
        backgroundColor: Colors.white,
        body: Container(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
          child: Column(
            children: [
              const SizedBox(height: 20),
              if (inProgress)
                CircularProgressIndicator(
                  color: Colors.black,
                )
              else
                Expanded(
                  child: SingleChildScrollView(child: buildWeatherWidget()),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildWeatherWidget() {
    if (response == null) {
      return Text(message);
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(
                Icons.location_on,
                size: 35,
              ),
              Text(
                response?.location?.name ?? "",
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                response?.location?.country ?? '',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
                child: Text(
                  (response?.current?.tempC.toString() ?? "") + " °c",
                  style: const TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 13),
            child: Row(
              children: [
                Text(
                  (response?.current?.condition?.text.toString() ?? ""),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: SizedBox(
              height: 200,
              child: Image.network(
                "https:${response?.current?.condition?.icon}"
                    .replaceAll("64x64", "128x128"),
                scale: 0.7,
              ),
            ),
          ),
          Card(
            elevation: 4,
            color: Colors.amber,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _dataAndTitleWidget("Humidity",
                        response?.current?.humidity?.toString() ?? ""),
                    _dataAndTitleWidget("Wind Speed",
                        "${response?.current?.windKph?.toString() ?? ""} km/h")
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _dataAndTitleWidget(
                        "UV", response?.current?.uv.toString() ?? ""),
                    _dataAndTitleWidget("Precipitation",
                        "${response?.current?.precipMm.toString() ?? ""} mm")
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _dataAndTitleWidget("Local Time",
                        response?.location?.localtime?.split(" ").last ?? ""),
                    _dataAndTitleWidget("Local Date",
                        response?.location?.localtime?.split(" ").first ?? ""),
                  ],
                )
              ],
            ),
          )
        ],
      );
    }
  }

  Widget _dataAndTitleWidget(String title, String data) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        children: [
          Text(
            data,
            style: const TextStyle(
              fontSize: 27,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> loadLastWeatherData() async {
    setState(() {
      inProgress = true;
    });
    try {
      ApiResponse? lastWeatherData = await Utils().getLastWeatherData();
      if (lastWeatherData != null) {
        setState(() {
          response = lastWeatherData;
        });
      } else {
        setState(() {
          const Center(child: Text('No previous data find'));
        });
      }
    } catch (e) {
      setState(() {
        const Center(child: Text('Failed to load weather data'));
        response = null;
      });
    } finally {
      setState(() {
        inProgress = false;
      });
    }
  }
}
