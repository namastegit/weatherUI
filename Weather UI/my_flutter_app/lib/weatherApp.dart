import 'dart:convert';
import 'dart:ui';
import 'package:intl/intl.dart'; //FOR TIME IN HOURLY SECTION
import 'package:my_flutter_app/hourly_forcast_items.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/secrets.dart';
import 'additionalinfo_item.dart';
import 'package:http/http.dart' as http;

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  // double temp = 0;
  late Future<Map<String, dynamic>> weather;

  Future<Map<String, dynamic>> getCurrentW() async {
    try {
      final result = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=Noida&APPID=$openWeatherApiKey'),
      );

      final data = jsonDecode(result.body);
      if (data['cod'] != '200') {
        throw data['message'];
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    weather = getCurrentW();
  }

  IconData getWeatherIcon(String currentSky) {
    if (currentSky == 'Clouds') {
      return Icons.cloud;
    } else if (currentSky == 'Rain') {
      return Icons.ac_unit;
    } else {
      return Icons.sunny;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather Forecast',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                weather = getCurrentW();
              });
            },
            icon: Container(
                margin: EdgeInsets.only(top: 3, right: 7),
                child: const Icon(Icons.refresh)),
          ),
        ],
      ),
      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          print(snapshot);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 26, 130, 214),
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 26, 130, 214),
                ),
              ),
            );
          }

          final data = snapshot.data!;

          final currentTemp = (data['list'][0]['main']['temp']);
          final currentSky = (data['list'][0]['weather'][0]['main']);
          final currentPressure = (data['list'][0]['main']['pressure']);
          final currentHumidity = (data['list'][0]['main']['humidity']);
          final currentWindSpeed = (data['list'][0]['wind']['speed']);

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 50,
                    color: const Color.fromARGB(255, 26, 130, 214),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 1.5,
                        sigmaY: 1.2,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                bottom: 25,
                              ),
                              child: Text(
                                '$currentTemp°K',
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Icon(
                              getWeatherIcon(currentSky),
                              size: 60,
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                top: 10,
                              ),
                              child: Text(
                                currentSky,
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 15,
                  ),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Hourly Forecast',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                ///LAZY LOADING;;
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                      //it takes full screen size so we managed its size by using sized box

                      scrollDirection: Axis.horizontal,
                      itemCount: 12,
                      itemBuilder: (context, index) {
                        final HourlyChartforcast = data['list'][index + 1];
                        final hourlySk =
                            data['list'][index + 1]['weather'][0]['main'];
                        final time = DateTime.parse(
                            HourlyChartforcast['dt_txt'].toString());
                        return HourlyChart(
                            valu: DateFormat.j().format(time),
                            ico: hourlySk == 'Clouds' || hourlySk == 'Rain'
                                ? Icons.cloud
                                : Icons.sunny,
                            valuee:
                                HourlyChartforcast['main']['temp'].toString());
                      }),
                ),

                Container(
                  margin: const EdgeInsets.only(
                    top: 10,
                  ),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Additional Information',
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    additionalInfo(
                        icon: Icons.water_drop,
                        label: 'Humidity',
                        value: currentHumidity.toString()),
                    additionalInfo(
                        icon: Icons.air,
                        label: 'Wind Speed',
                        value: currentWindSpeed.toString()),
                    additionalInfo(
                        icon: Icons.beach_access_sharp,
                        label: 'Pressure',
                        value: currentPressure.toString()),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
