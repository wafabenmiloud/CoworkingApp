// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:front/widgets/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' show cos, sqrt, asin;
import '../services/igloosservice.dart';
import 'igloo_screen.dart';
import 'package:front/screens/filter_screen.dart';
import 'package:front/screens/map_screen.dart';
import '../constants.dart';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';

//calculate distance in km between two addresses given their lat and long
double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const p = 0.017453292519943295;
  if (lat1 == null || lon1 == null || lat2 == null || lon2 == null) {
    throw ArgumentError("Invalid latitude and/or longitude provided.");
  }
  final a = 0.5 -
      cos((lat2 - lat1) * p) / 2 +
      cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}

class IglooScreen extends StatefulWidget {
  final Position currentPosition;

  IglooScreen({required this.currentPosition});

  @override
  State<IglooScreen> createState() => _IglooScreenState();
}

class _IglooScreenState extends State<IglooScreen> {
  int _widgetindex = 0;

  List filterlist = [];
  String filterstring = "";
  List igloos = [];
  List filteredIgloos = [];
  bool isFiltering = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      filterlist = [];
    });
    _fetchData().then((data) {
      setState(() {
        igloos = filteredIgloos = data;
      });
    });
  }

  _fetchData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      Dio dio = new Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';
      final res = await dio.get('$server/getigloos');
      return res.data;
    } catch (error) {
      print('Error fetching data: $error');
      return null;
    }
  }

  void filterIgloos(
      selectedVille,
      selectedDate,
      selectedPlaces,
      selectedStartTime,
      selectedEndTime,
      selectedType,
      selectedAvis,
      selectedOthers,
      priceRange,
      distanceRange) {
    setState(() {
      if (selectedVille == null &&
          selectedDate.text == "" &&
          selectedPlaces == null &&
          selectedStartTime.text == "" &&
          selectedEndTime.text == "" &&
          selectedType.isEmpty &&
          selectedAvis.isEmpty &&
          selectedOthers.isEmpty &&
          priceRange.start == 0 &&
          priceRange.end == 500 &&
          distanceRange.start == 0 &&
          distanceRange.end == 2000) {
        filteredIgloos = igloos;
      } else {
        filterlist.addAll(selectedType);
        filterlist.addAll(selectedOthers);
        filterstring = filterlist.join('|');

        filteredIgloos = igloos.where((igloo) {
          //ville
          final villeMatch = selectedVille == null ||
              igloo['ville']
                  .toLowerCase()
                  .contains(selectedVille.toLowerCase());
          //day
          final dateMatch = selectedDate.text == "" ||
              igloo['startDate'].contains(selectedDate.text);
          //nb places
          final placesMatch = selectedPlaces == null ||
              double.parse(selectedPlaces) == igloo['nb_places'];
          //start at
          final starttimeMatch = selectedStartTime.text == "" ||
              selectedStartTime.text == igloo['start_time'];
          //end at
          final endtimeMatch = selectedEndTime.text == "" ||
              selectedEndTime.text == igloo['end_time'];
          //price
          final priceMatch = priceRange.start <= igloo['price'] &&
              priceRange.end >= igloo['price'];

          //distance

          final distance = calculateDistance(
              widget.currentPosition.latitude,
              widget.currentPosition.longitude,
              igloo['latitude'].toDouble(),
              igloo['longitude'].toDouble());
          final distanceMatch =
              distanceRange.start <= distance && distanceRange.end >= distance;
          print(distanceMatch);

          //type
          final typeMatch = selectedType.isEmpty ||
              selectedType.any((type) =>
                  type.toLowerCase() == igloo['igloo_type'].toLowerCase());
          //rating
          final avisMatch =
              selectedAvis.isEmpty || selectedAvis.contains(igloo['rate']);
          //equipements dispo
          List<dynamic> equipements = json.decode(igloo['equipements']);
          final othersMatch = selectedOthers.isEmpty ||
              equipements.any((element) => selectedOthers.contains(element));

          return typeMatch &&
              avisMatch &&
              priceMatch &&
              villeMatch &&
              placesMatch &&
              dateMatch &&
              starttimeMatch &&
              endtimeMatch &&
              distanceMatch &&
              othersMatch;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          (_widgetindex == 0)
              ? Igloos(
                  filteredIgloos: filteredIgloos,
                  currentPosition: widget.currentPosition,
                )
              : MapScreen(
                  filteredIgloos: filteredIgloos,
                  currentPosition: widget.currentPosition,
                ),
          Positioned(
              child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Color(0xffd2d2d2)),
                ),
                margin: EdgeInsets.only(right: 20, left: 20, top: 50),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: AppStyles.primaryColor,
                          size: 30,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        filterstring,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0XFF000000),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    InkWell(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FilterScreen()),
                          );
                          if (result != null) {
                            setState(() {
                              isFiltering = result['filter'];
                            });
                            filterIgloos(
                                result['selectedVille'],
                                result['selectedDate'],
                                result['selectedPlaces'],
                                result['selectedStarttime'],
                                result['selectedEndtime'],
                                result['selectedType'],
                                result['selectedAvis'],
                                result['selectedOthers'],
                                result['priceRange'],
                                result['distanceRange']);
                          }
                        },
                        child: isFiltering
                            ? InkWell(
                                onTap: () {
                                  setState(() {
                                    filteredIgloos = igloos;
                                    isFiltering = false;
                                    filterlist = [];
                                    filterstring = "";
                                  });
                                },
                                child: Icon(
                                  Icons.close,
                                  color: AppStyles.primaryColor,
                                ))
                            : Image.asset('images/filter.png')),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: (_widgetindex == 0)
                    ? InkWell(
                        onTap: () {
                          setState(() {
                            _widgetindex = 1;
                          });
                        },
                        child: Container(
                          width: 110,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: AppStyles.secondaryColor,
                            borderRadius: BorderRadius.circular(35),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.location_on),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Carte",
                                style: TextStyle(
                                  color: Color(0XFF000000),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : InkWell(
                        onTap: () {
                          setState(() {
                            _widgetindex = 0;
                          });
                        },
                        child: Container(
                          width: 110,
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: AppStyles.secondaryColor,
                            borderRadius: BorderRadius.circular(35),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.menu),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Liste",
                                style: TextStyle(
                                  color: Color(0XFF000000),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            ],
          ))
        ],
      ),
    );
  }
}

class Igloos extends StatefulWidget {
  final List filteredIgloos;
  final Position currentPosition;

  Igloos({required this.filteredIgloos, required this.currentPosition});
  @override
  State<Igloos> createState() => _IgloosState();
}

class _IgloosState extends State<Igloos> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 180,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: widget.filteredIgloos.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Igloo(
                            igloo_id: widget.filteredIgloos[index]['id'])),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 40, right: 25, left: 25),
                  decoration: BoxDecoration(
                      color: AppStyles.secondaryColor,
                      borderRadius: BorderRadius.circular(25)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Column(
                      children: [
                        Stack(children: [
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(25.0),
                              child: Image.asset('images/img.png'),
                            ),
                          ),
                          Positioned(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 14, vertical: 5),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(35),
                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                "${widget.filteredIgloos[index]['rate']}",
                                                style: TextStyle(
                                                    color: Color(0xff494949),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'Poppins'),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Image.asset(
                                                'images/igloo.png',
                                                width: 20,
                                                height: 20,
                                              ),
                                            ],
                                          )),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(35),
                                        ),
                                        child: Text(
                                          " ${widget.filteredIgloos[index]['price']}£",
                                          style: TextStyle(
                                              color: Color(0XFF494949),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Poppins'),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(35),
                                        ),
                                        child: Text(
                                          "${widget.filteredIgloos[index]['nb_places']} places",
                                          style: TextStyle(
                                              color: Color(0xff494949),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Poppins'),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    widget.filteredIgloos[index]['liked']
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: AppStyles.primaryColor,
                                    size: 30,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              " ${widget.filteredIgloos[index]['igloo_name']}",
                              style: TextStyle(
                                  color: Color(0XFF000000),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins'),
                            ),
                            Column(
                              children: [
                                Text(
                                  " ${widget.filteredIgloos[index]['ville']}",
                                  style: TextStyle(
                                      color: Color(0xff494949),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Poppins'),
                                ),
                                Text(
                                  " à ${calculateDistance(widget.currentPosition.latitude, widget.currentPosition.longitude, widget.filteredIgloos[index]['latitude'].toDouble(), widget.filteredIgloos[index]['longitude'].toDouble()).ceil()} km de vous",
                                  style: TextStyle(
                                      color: Color(0xff494949),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Poppins'),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
