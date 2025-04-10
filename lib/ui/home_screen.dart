// ignore_for_file: deprecated_member_use

import 'package:WeatherWise/ui/search_bar.dart';
import 'package:WeatherWise/controller/weather_controller.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  final WeatherController weatherController = Get.put(WeatherController());

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          body: RefreshIndicator(
            onRefresh: () async {
              await weatherController.loadLastWeatherData();
            },
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'images/homebg.jpeg'), // You can replace this with a local asset or URL
                  fit: BoxFit.cover, // Cover the entire screen with the image
                ),
              ),
              padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Obx(() {
                    if (weatherController.inProgress.value) {
                      return const Center(
                          child:
                              CircularProgressIndicator(color: Colors.black));
                    } else {
                      return Expanded(
                        child: SingleChildScrollView(
                            child: buildWeatherWidget(context)),
                      );
                    }
                  }),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
              shape: const CircleBorder(),
              backgroundColor: Colors.white,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchPage(),
                    ));
              },
              child:
                  const Icon(Icons.add_location_outlined, color: Colors.blue)),
        ),
      ),
    );
  }

  Widget buildWeatherWidget(BuildContext context) {
    return Obx(() {
      if (weatherController.response.value == null) {
        return Center(child: Text(weatherController.message.value));
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 35,
                ),
                Column(
                  children: [
                    Text(
                      weatherController.response.value?.location?.name ?? "",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      weatherController.response.value?.location?.country ?? '',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Center(
              child: SizedBox(
                height: 200,
                width: double.infinity,
                child: Obx(() {
                  return (weatherController.connectivityStatus.value !=
                          ConnectivityResult.none)
                      ? Image.network(
                          "https:${weatherController.response.value?.current?.condition?.icon}"
                              .replaceAll("64x64", "128x128"),
                          scale: 0.7,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.wifi_off),
                        )
                      : Container(); // Offline, don't show image
                }),
              ),
            ),
            Center(
              child: Text(
                (weatherController.response.value?.current?.condition?.text
                        .toString() ??
                    ""),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
                  child: Text(
                    "${weatherController.response.value?.current?.tempC.toString() ?? ""} °c",
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Card(
              color: Colors.transparent,
              child: Column(
                children: [
                  _dataAndTitleWidget(
                      "Humidity",
                      weatherController.response.value?.current?.humidity
                              ?.toString() ??
                          "",
                      Icons.water_drop,
                      Colors.blue),
                  _dataAndTitleWidget(
                      "Wind Speed",
                      "${weatherController.response.value?.current?.windKph?.toString() ?? ""} km/h",
                      Icons.air,
                      Colors.white),
                  _dataAndTitleWidget(
                      "UV",
                      weatherController.response.value?.current?.uv
                              .toString() ??
                          "",
                      Icons.sunny,
                      Colors.yellow),
                  _dataAndTitleWidget(
                      "Precipitation",
                      "${weatherController.response.value?.current?.precipMm.toString() ?? ""} mm",
                      Icons.cloud,
                      Colors.blueGrey),
                  _dataAndTitleWidget(
                      "Time",
                      weatherController.response.value?.location?.localtime
                              ?.split(" ")
                              .last ??
                          "",
                      Icons.access_time,
                      Colors.black),
                  _dataAndTitleWidget(
                      "Date",
                      weatherController.response.value?.location?.localtime
                              ?.split(" ")
                              .first ??
                          "",
                      Icons.calendar_today,
                      Colors.white)
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 1 / 9,
            )
          ],
        );
      }
    });
  }

  Widget _dataAndTitleWidget(
      String title, String data, IconData icon, Color iconColor) {
    return Column(
      children: [
        ListTile(
          leading: Icon(
            icon,
            color: iconColor,
          ),
          title: Text(
            title,
            style: const TextStyle(fontSize: 15),
          ),
          trailing: Text(
            data,
            style: const TextStyle(fontSize: 15),
          ),
        ),
        const Divider()
      ],
    );
  }
}
