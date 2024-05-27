// import 'dart:convert';

// import 'package:WeatherWise/app_url.dart';
// import 'package:WeatherWise/model/model.dart';
// import 'package:WeatherWise/utils.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:uuid/uuid.dart';
// import 'package:http/http.dart' as http;

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   var uuid = Uuid();
//   String _sessionToken = '12345';
//   final searchController = TextEditingController();
//   ApiResponse? response;
//   bool inProgress = false;
//   String message = "Search for the location to get weather data";
//   List<dynamic> _placeList = [];

//   @override
//   void initState() {
//     super.initState();
//     searchController.addListener(() {
//       onChanged();
//     });
//     _loadLastWeatherData();
//   }

//   void onChanged() {
//     setState(() {
//       if (_sessionToken == null) {
//         _sessionToken = uuid.v4();
//       } else {
//         getSuggestion(searchController.text);
//       }
//     });
//   }

//   void getSuggestion(String input) async {
//     String apiKey = 'AIzaSyCT1_CquKvIuNoCOxbsWOBo3U4Zq_58f2Y';
//     String baseURL =
//         'https://maps.googleapis.com/maps/api/place/autocomplete/json';
//     String request =
//         '$baseURL?input=$input&key=$apiKey&sessiontoken=$_sessionToken';
//     var response = await http.get(Uri.parse(request));
//     print(response);
//     if (response.statusCode == 200) {
//       setState(() {
//         _placeList = jsonDecode(response.body.toString())['prediction'];
//       });
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: Container(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               _buildSearchWidget(),
//               const SizedBox(height: 20),
//               if (inProgress)
//                 CircularProgressIndicator()
//               else
//                 Expanded(
//                   child: SingleChildScrollView(child: _buildWeatherWidget()),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSearchWidget() {
//     return TextField(
//       cursorColor: Colors.amber,
//       decoration: InputDecoration(
//           border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(15),
//               borderSide: BorderSide(color: Colors.black)),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//           hintText: "Search any location",
//           fillColor: Colors.white,
//           filled: true),
//       controller: searchController,
//       onChanged: (value) {
//         setState(() {});
//       },
//       onSubmitted: (value) {
//         _getWeatherData(value);
//       },
//     );
//   }

//   Widget _buildWeatherWidget() {
//     if (response == null) {
//       return Text(message);
//     } else {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               const Icon(
//                 Icons.location_on,
//                 size: 50,
//               ),
//               Text(
//                 response?.location?.name ?? "",
//                 style: const TextStyle(
//                   fontSize: 40,
//                   fontWeight: FontWeight.w300,
//                 ),
//               ),
//               Text(
//                 response?.location?.country ?? '',
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w300,
//                 ),
//               )
//             ],
//           ),
//           const SizedBox(height: 10),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
//                 child: Text(
//                   (response?.current?.tempC.toString() ?? "") + " °c",
//                   style: const TextStyle(
//                     fontSize: 60,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: Row(
//               children: [
//                 Text(
//                   (response?.current?.condition?.text.toString() ?? ""),
//                   style: const TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Center(
//             child: SizedBox(
//               height: 200,
//               child: Image.network(
//                 "https:${response?.current?.condition?.icon}"
//                     .replaceAll("64x64", "128x128"),
//                 scale: 0.7,
//               ),
//             ),
//           ),
//           Card(
//             elevation: 4,
//             color: Colors.amber,
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     _dataAndTitleWidget("Humidity",
//                         response?.current?.humidity?.toString() ?? ""),
//                     _dataAndTitleWidget("Wind Speed",
//                         "${response?.current?.windKph?.toString() ?? ""} km/h")
//                   ],
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     _dataAndTitleWidget(
//                         "UV", response?.current?.uv.toString() ?? ""),
//                     _dataAndTitleWidget("Precipitation",
//                         "${response?.current?.precipMm.toString() ?? ""} mm")
//                   ],
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     _dataAndTitleWidget("Local Time",
//                         response?.location?.localtime?.split(" ").last ?? ""),
//                     _dataAndTitleWidget("Local Date",
//                         response?.location?.localtime?.split(" ").first ?? ""),
//                   ],
//                 )
//               ],
//             ),
//           )
//         ],
//       );
//     }
//   }

//   Widget _dataAndTitleWidget(String title, String data) {
//     return Padding(
//       padding: const EdgeInsets.all(18.0),
//       child: Column(
//         children: [
//           Text(
//             data,
//             style: const TextStyle(
//               fontSize: 27,
//               color: Colors.black87,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           Text(
//             title,
//             style: const TextStyle(
//               color: Colors.black87,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _getWeatherData(String location) async {
//     setState(() {
//       inProgress = true;
//     });

//     try {
//       response = await WeatherApi().getCurrentWeather(location);
//       if (response != null) {
//         await Utils().saveLastWeatherData(response!);
//       } else {
//         setState(() {
//           message = "Failed to get weather data";
//         });
//       }
//     } catch (e) {
//       setState(() {
//         message = "Failed to get weather";
//         response = null;
//       });
//     } finally {
//       setState(() {
//         inProgress = false;
//       });
//     }
//   }

//   void _loadLastWeatherData() async {
//     setState(() {
//       inProgress = true;
//     });
//     try {
//       ApiResponse? lastWeatherData = await Utils().getLastWeatherData();
//       if (lastWeatherData != null) {
//         setState(() {
//           response = lastWeatherData;
//         });
//       } else {
//         setState(() {
//           message = "No previous weather data";
//         });
//       }
//     } catch (e) {
//       setState(() {
//         message = "Failed to load weather data";
//         response = null;
//       });
//     } finally {
//       setState(() {
//         inProgress = false;
//       });
//     }
//   }
// }
