import 'package:WeatherWise/controller/weather_controller.dart';
import 'package:WeatherWise/controller/search_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchPage extends StatelessWidget {
  final WeatherController weatherController = Get.put(WeatherController());
  final SearchbarController searchController = Get.put(SearchbarController());

  SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/searchbg.jpg'),
              fit: BoxFit.cover, // Cover the entire screen with the image
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: searchController.searchontroller,
                  style: const TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    hintText: "Search any location",
                    hintStyle: const TextStyle(color: Colors.black),
                    fillColor: Colors.transparent,
                    filled: true,
                  ),
                  onChanged: (value) {
                    // Fetch suggestions as the user types
                    searchController.getSuggestions(value);
                  },
                  onSubmitted: (value) async {
                    await weatherController.getWeatherData(value, context);
                  },
                ),
              ),
              Obx(() {
                if (weatherController.inProgress.value) {
                  return Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 1 / 3,
                      ),
                      const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    ],
                  );
                }

                if (weatherController.inProgress.value == false) {
                  return Center(child: Text(weatherController.message.value));
                }
                return Container();
              }),
              // Display place suggestions from SearchController
              Expanded(
                child: Obx(() {
                  return ListView.builder(
                    itemCount: searchController.placeList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          searchController.searchontroller.text =
                              searchController.placeList[index]['description']
                                  .toString();
                        },
                        title: Text(
                            searchController.placeList[index]['description']),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
