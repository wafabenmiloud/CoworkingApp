import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:front/screens/profile_screen.dart';
import 'package:front/services/igloosservice.dart';
import 'package:front/constants.dart';
import 'package:flutter/material.dart';
import 'package:front/widgets/navbar.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;

// convert address to latitude and longitude
Future<LatLng> convertAddressToLatLng(String address) async {
  if (address == null || address.isEmpty) {
    return LatLng(0, 0);
  }
  try {
    List<Location> locations = await locationFromAddress(address);
    if (locations != null && locations.isNotEmpty) {
      Location location = locations[0];
      return LatLng(location.latitude, location.longitude);
    }
  } catch (e) {
    print("Error converting address to LatLng: $e");
  }
  return LatLng(0, 0);
}

class AddIglooScreen extends StatefulWidget {
  const AddIglooScreen({super.key});

  @override
  State<AddIglooScreen> createState() => _AddIglooScreenState();
}

class _AddIglooScreenState extends State<AddIglooScreen> {
  final List<String> type = ['Maison', 'Appart', 'Chalet', 'Studio'];
  int _selectedType = -1;
  String selectedType = "";

  final List<String> place = [
    'Salon',
    'salle à manger',
    'Bureau individuel',
    'Terasse'
  ];

  List<String> _selectedPlace = [];
  final List<String> cnx = ['Fibre', 'ADLS', '4G/5G', 'Connexion rapide'];
  List<String> _selectedCnx = [];
  final List<String> transport = ['Bus', 'RER', 'Metro', 'TGM', 'TRAMWAY'];
  List<String> _selectedTransport = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 35, left: 6),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: AppStyles.primaryColor,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(left: 30, top: 10),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 36,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: 'Télétravailler entre ',
                    ),
                    TextSpan(
                        text: 'particuliers ',
                        style: TextStyle(fontFamily: 'Pecita')),
                    TextSpan(
                      text: 'avec ',
                    ),
                    TextSpan(
                        text: 'IglooWorking ',
                        style: TextStyle(color: AppStyles.primaryColor)),
                    TextSpan(
                      text: 'vous pourriez gagner',
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Text(
                '130£',
                style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.w600,
                    color: AppStyles.primaryColor,
                    shadows: [
                      Shadow(
                        color: Color.fromRGBO(0, 0, 0, 0.25),
                        offset: Offset(0, 4),
                        blurRadius: 4,
                      ),
                    ],
                    fontFamily: 'Poppins'),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 30, top: 10, bottom: 10),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                        text: '5 jours x 4 semaines ',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          shadows: [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.25),
                              offset: Offset(0, 4),
                              blurRadius: 4,
                            ),
                          ],
                        )),
                    TextSpan(
                      text:
                          'de co-working avec une estimation de 7 euros par jours pour ',
                    ),
                    TextSpan(
                        text: '1 personne. ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          shadows: [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.25),
                              offset: Offset(0, 4),
                              blurRadius: 4,
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Text(
                "Parlez nous de votre logement",
                style: AppStyles.bodyStyle,
              ),
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: List.generate(
                    type.length,
                    (index) => InkWell(
                      onTap: () {
                        setState(() {
                          if (_selectedType == index) {
                            _selectedType = -1;
                          } else {
                            _selectedType = index;
                            selectedType = type[index];
                          }
                        });
                      },
                      child: Container(
                        width: 180,
                        height: 35,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: AppStyles.secondaryColor,
                            border: Border.all(
                              color: _selectedType == index
                                  ? AppStyles.primaryColor
                                  : Colors.transparent,
                            )),
                        child: Center(
                          child: Text(
                            '${type[index]}',
                            style: TextStyle(
                                color: _selectedType == index
                                    ? AppStyles.primaryColor
                                    : Colors.black,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins'),
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Text(
                "Ou aura lieu le co-working",
                style: AppStyles.bodyStyle,
              ),
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: List.generate(
                    place.length,
                    (index) => InkWell(
                      onTap: () {
                        setState(() {
                          if (_selectedPlace.contains(place[index])) {
                            _selectedPlace.remove(place[index]);
                          } else {
                            _selectedPlace.add(place[index]);
                          }
                        });
                      },
                      child: Container(
                        width: 180,
                        height: 35,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: AppStyles.secondaryColor,
                            border: Border.all(
                              color: _selectedPlace.contains(place[index])
                                  ? AppStyles.primaryColor
                                  : Colors.transparent,
                            )),
                        child: Center(
                          child: Text(
                            '${place[index]}',
                            style: TextStyle(
                                color: _selectedPlace.contains(place[index])
                                    ? AppStyles.primaryColor
                                    : Colors.black,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins'),
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Text(
                "Dites-nous en plus sur votre connexion internet",
                style: AppStyles.bodyStyle,
              ),
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: List.generate(
                    cnx.length,
                    (index) => InkWell(
                      onTap: () {
                        setState(() {
                          if (_selectedCnx.contains(cnx[index])) {
                            _selectedCnx.remove(cnx[index]);
                          } else {
                            _selectedCnx.add(cnx[index]);
                          }
                        });
                      },
                      child: Container(
                        width: 180,
                        height: 35,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: AppStyles.secondaryColor,
                            border: Border.all(
                              color: _selectedCnx.contains(cnx[index])
                                  ? AppStyles.primaryColor
                                  : Colors.transparent,
                            )),
                        child: Center(
                          child: Text(
                            '${cnx[index]}',
                            style: TextStyle(
                                color: _selectedCnx.contains(cnx[index])
                                    ? AppStyles.primaryColor
                                    : Colors.black,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins'),
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Text(
                "Transport à proximité",
                style: AppStyles.bodyStyle,
              ),
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: List.generate(
                    transport.length,
                    (index) => InkWell(
                      onTap: () {
                        setState(() {
                          if (_selectedTransport.contains(transport[index])) {
                            _selectedTransport.remove(transport[index]);
                          } else {
                            _selectedTransport.add(transport[index]);
                          }
                        });
                      },
                      child: Container(
                        width: 110,
                        height: 35,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: AppStyles.secondaryColor,
                            border: Border.all(
                              color:
                                  _selectedTransport.contains(transport[index])
                                      ? AppStyles.primaryColor
                                      : Colors.transparent,
                            )),
                        child: Center(
                          child: Text(
                            '${transport[index]}',
                            style: TextStyle(
                                color: _selectedTransport
                                        .contains(transport[index])
                                    ? AppStyles.primaryColor
                                    : Colors.black,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins'),
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
            Container(
              padding: const EdgeInsets.only(right: 20, top: 15, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      if (_selectedType == -1 ||
                          _selectedPlace.isEmpty ||
                          _selectedCnx.isEmpty ||
                          _selectedTransport.isEmpty) {
                        Fluttertoast.showToast(
                            msg: 'Enter all fields !!!',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SecondStepScreen(
                              selectedType: selectedType,
                              selectedPlace: _selectedPlace,
                              selectedCnx: _selectedCnx,
                              selectedTransport: _selectedTransport,
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      width: 350,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                          color: AppStyles.primaryColor,
                          borderRadius: BorderRadius.circular(4)),
                      child: Center(
                        child: Text(
                          "Suivant",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SecondStepScreen extends StatefulWidget {
  final String selectedType;
  final List<String> selectedPlace;
  final List<String> selectedCnx;
  final List<String> selectedTransport;

  const SecondStepScreen({
    Key? key,
    required this.selectedType,
    required this.selectedPlace,
    required this.selectedCnx,
    required this.selectedTransport,
  }) : super(key: key);

  @override
  _SecondStepScreenState createState() => _SecondStepScreenState();
}

class _SecondStepScreenState extends State<SecondStepScreen> {
  TextEditingController _selectedStartDate = TextEditingController();
  TextEditingController _selectedEndDate = TextEditingController();

  TextEditingController _selectedStartTime = TextEditingController();
  TextEditingController _selectedEndTime = TextEditingController();
  String _selectedDescription = "";
  final List<Map<String, dynamic>> equipements = [
    {'icon': 'images/eq1.png', 'title': 'Caffetière'},
    {'icon': 'images/eq2.png', 'title': 'Four'},
    {'icon': 'images/eq3.png', 'title': 'Micro-onde'},
    {'icon': 'images/eq4.png', 'title': 'Frigo'},
    {'icon': 'images/eq5.png', 'title': 'Imprimante'},
    {'icon': 'images/eq6.png', 'title': 'Toilette'},
    {'icon': 'images/eq7.png', 'title': 'Parking gratuit'},
    {'icon': 'images/eq8.png', 'title': 'Parking Payant'},
    {'icon': 'images/eq9.png', 'title': 'Jeu vidéo'},
    {'icon': 'images/eq10.png', 'title': 'Siège à roue'},
    {'icon': 'images/eq11.png', 'title': 'Bureau'},
    {'icon': 'images/eq12.png', 'title': 'Salle à manger'},
  ];
  List<String> _selectedEquipements = [];
  List<String> selectedDays = [];
  List<String> coworkingDays = [];
  void updateSelectedDays() {
    selectedDays.clear();

    if (_selectedStartDate.text.isNotEmpty &&
        _selectedEndDate.text.isNotEmpty) {
      DateTime startDate =
          DateFormat('d MMM y', 'fr_FR').parse(_selectedStartDate.text);
      DateTime endDate =
          DateFormat('d MMM y', 'fr_FR').parse(_selectedEndDate.text);

      while (
          startDate.isBefore(endDate) || startDate.isAtSameMomentAs(endDate)) {
        String day = DateFormat('E', 'fr_FR').format(startDate);
        selectedDays.add(day);

        startDate = startDate.add(Duration(days: 1));
      }
    }
  }

  @override
  void initState() {
    _selectedStartDate.text = "";
    _selectedEndDate.text = "";

    _selectedStartTime.text = "";
    _selectedEndTime.text = "";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 35, left: 6),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: AppStyles.primaryColor,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Text(
                "Dites nous en plus sur les équipements de votre logement",
                style: AppStyles.bodyStyle,
              ),
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: List.generate(
                    equipements.length,
                    (index) => InkWell(
                      onTap: () {
                        setState(() {
                          if (_selectedEquipements
                              .contains(equipements[index]['title'])) {
                            _selectedEquipements
                                .remove(equipements[index]['title']);
                          } else {
                            _selectedEquipements
                                .add(equipements[index]['title']);
                          }
                        });
                      },
                      child: Container(
                        width: 90,
                        height: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: _selectedEquipements
                                    .contains(equipements[index]['title'])
                                ? AppStyles.primaryColor
                                : AppStyles.secondaryColor,
                            border: Border.all(
                              color: Colors.transparent,
                            )),
                        child: Column(children: [
                          Container(
                            height: 40,
                            width: 40,
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(35),
                              child: Image.asset(
                                equipements[index]['icon'],
                              ),
                            ),
                          ),
                          Text(
                            '${equipements[index]['title']}',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 10.0,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins'),
                          ),
                        ]),
                      ),
                    ),
                  ),
                )),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Text(
                "Quelques mots sur votre logement",
                style: AppStyles.bodyStyle,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: AppStyles.secondaryColor,
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                onChanged: (value) {
                  _selectedDescription = value;
                },
                minLines: 6,
                maxLines: null,
                decoration: InputDecoration(
                    hintText: 'Enter your text here...',
                    border: InputBorder.none),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 14, top: 8, bottom: 8),
              child: Text(
                "Période d'ouverture",
                style: AppStyles.bodyStyle,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 20.0),
                    margin: EdgeInsets.only(left: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Color(0xffd2d2d2)),
                    ),
                    child: TextField(
                      controller: _selectedStartDate,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        suffixIcon: Icon(Icons.keyboard_arrow_down),
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1950),
                            lastDate: DateTime(2100));

                        if (pickedDate != null) {
                          String formattedDate =
                              DateFormat('d MMM y', 'fr_FR').format(pickedDate);

                          setState(() {
                            _selectedStartDate.text = formattedDate;
                            updateSelectedDays();
                          });
                        } else {}
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "A",
                    style: AppStyles.bodyStyle2,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 20.0),
                    margin: EdgeInsets.only(right: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Color(0xffd2d2d2)),
                    ),
                    child: TextField(
                      controller: _selectedEndDate,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        suffixIcon: Icon(Icons.keyboard_arrow_down),
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1950),
                            lastDate: DateTime(2100));

                        if (pickedDate != null) {
                          String formattedDate =
                              DateFormat('d MMM y', 'fr_FR').format(pickedDate);

                          setState(() {
                            _selectedEndDate.text = formattedDate;
                            updateSelectedDays();
                          });
                        } else {}
                      },
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Text(
                "Quand souhaitez-vous co-worker ?",
                style: AppStyles.bodyStyle,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
              child: Wrap(
                alignment: WrapAlignment.start,
                spacing: 8,
                runSpacing: 10,
                children: selectedDays.map((day) {
                  final bool isSelected = coworkingDays.contains(day);

                  return InkWell(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          coworkingDays.remove(day);
                        } else {
                          coworkingDays.add(day);
                        }
                      });
                    },
                    child: Chip(
                      label: Text(day, style: AppStyles.bodyStyle2),
                      backgroundColor: isSelected
                          ? AppStyles.primaryColor
                          : AppStyles.secondaryColor,
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Text(
                "& niveau horaire ?",
                style: AppStyles.bodyStyle,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 20.0),
                    margin: EdgeInsets.only(left: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Color(0xffd2d2d2)),
                    ),
                    child: TextField(
                      controller: _selectedStartTime,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          suffixIcon: Icon(Icons.keyboard_arrow_down)),
                      readOnly: true,
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                        );

                        if (pickedTime != null) {
                          String formattedTime = DateFormat('HH:mm:ss').format(
                              DateTime(2023, 1, 1, pickedTime.hour,
                                  pickedTime.minute));

                          setState(() {
                            _selectedStartTime.text = formattedTime;
                          });
                        } else {
                          print("Time is not selected");
                        }
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "A",
                    style: AppStyles.bodyStyle2,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 20.0),
                    margin: EdgeInsets.only(right: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Color(0xffd2d2d2)),
                    ),
                    child: TextField(
                      controller: _selectedEndTime,
                      decoration: InputDecoration(
                          suffixIcon: Icon(Icons.keyboard_arrow_down),
                          border: InputBorder.none),
                      readOnly: true,
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                        );

                        if (pickedTime != null) {
                          String formattedTime = DateFormat('HH:mm:ss').format(
                              DateTime(2023, 1, 1, pickedTime.hour,
                                  pickedTime.minute));

                          setState(() {
                            _selectedEndTime.text = formattedTime;
                          });
                        } else {
                          print("Time is not selected");
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(top: 15, bottom: 5, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      if (_selectedEquipements.isEmpty ||
                          coworkingDays.isEmpty ||
                          _selectedDescription == "" ||
                          _selectedStartDate.text == "" ||
                          _selectedEndDate.text == "" ||
                          _selectedStartTime.text == "" ||
                          _selectedEndTime.text == "" ||
                          _selectedStartDate.text == "") {
                        Fluttertoast.showToast(
                            msg: 'Enter all fields !!!',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ThirdStepScreen(
                                selectedType: widget.selectedType,
                                selectedPlace: widget.selectedPlace,
                                selectedCnx: widget.selectedCnx,
                                selectedTransport: widget.selectedTransport,
                                selectedEquipements: _selectedEquipements,
                                selectedDescription: _selectedDescription,
                                selectedStartTime: _selectedStartTime,
                                selectedEndTime: _selectedEndTime,
                                selectedStartDate: _selectedStartDate,
                                selectedEndDate: _selectedEndDate,
                                selectedDays: coworkingDays),
                          ),
                        );
                      }
                    },
                    child: Container(
                      width: 370,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                          color: AppStyles.primaryColor,
                          borderRadius: BorderRadius.circular(4)),
                      child: Center(
                        child: Text(
                          "Suivant",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ThirdStepScreen extends StatefulWidget {
  final String selectedType;
  final List<String> selectedPlace;
  final List<String> selectedDays;

  final List<String> selectedCnx;
  final List<String> selectedTransport;
  final TextEditingController selectedStartDate;
  final TextEditingController selectedEndDate;

  final TextEditingController selectedStartTime;
  final TextEditingController selectedEndTime;
  final String selectedDescription;
  final List<String> selectedEquipements;

  const ThirdStepScreen(
      {Key? key,
      required this.selectedType,
      required this.selectedPlace,
      required this.selectedCnx,
      required this.selectedTransport,
      required this.selectedStartDate,
      required this.selectedEndDate,
      required this.selectedStartTime,
      required this.selectedEndTime,
      required this.selectedDescription,
      required this.selectedEquipements,
      required this.selectedDays})
      : super(key: key);
  @override
  State<ThirdStepScreen> createState() => _ThirdStepScreenState();
}

class _ThirdStepScreenState extends State<ThirdStepScreen> {
  final List<String> animals = ['Chien', 'Chat', 'Reptile', 'Pingouin'];
  List<String> _selectedAnimals = [];
  final List<String> acceptAnimals = ['Non', 'Oui'];
  int _animals = -1;
  final List<String> environnement = ['Au calme', 'En musique'];
  int _environnement = -1;
  final List<String> fauteil = ['Non', 'Oui'];
  int _fauteil = -1;
  final List<String> ascenseur = ['Non', 'Oui'];
  int _ascenseur = -1;
  final List<String> cuisine = ['Non', 'Oui'];
  int _cuisine = -1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 35, left: 6),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: AppStyles.primaryColor,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Text(
                "Quels animaux avez vous ?",
                style: AppStyles.bodyStyle,
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: List.generate(
                    animals.length,
                    (index) => InkWell(
                      onTap: () {
                        setState(() {
                          if (_selectedAnimals.contains(animals[index])) {
                            _selectedAnimals.remove(animals[index]);
                          } else {
                            _selectedAnimals.add(animals[index]);
                          }
                        });
                      },
                      child: Container(
                        width: 80,
                        height: 35,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: AppStyles.secondaryColor,
                            border: Border.all(
                              color: _selectedAnimals.contains(animals[index])
                                  ? AppStyles.primaryColor
                                  : Colors.transparent,
                            )),
                        child: Center(
                          child: Text(
                            '${animals[index]}',
                            style: TextStyle(
                                color: _selectedAnimals.contains(animals[index])
                                    ? AppStyles.primaryColor
                                    : Colors.black,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins'),
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Text(
                "Acceptez-vous d\'accueilir des animaux ?",
                style: AppStyles.bodyStyle,
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: List.generate(
                    acceptAnimals.length,
                    (index) => InkWell(
                      onTap: () {
                        setState(() {
                          if (_animals == index) {
                            _animals = -1;
                          } else {
                            _animals = index;
                          }
                        });
                      },
                      child: Container(
                        width: 180,
                        height: 35,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: AppStyles.secondaryColor,
                            border: Border.all(
                              color: _animals == index
                                  ? AppStyles.primaryColor
                                  : Colors.transparent,
                            )),
                        child: Center(
                          child: Text(
                            '${acceptAnimals[index]}',
                            style: TextStyle(
                                color: _animals == index
                                    ? AppStyles.primaryColor
                                    : Colors.black,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins'),
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Text(
                "Vous avez l\'habitude de travailler",
                style: AppStyles.bodyStyle,
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: List.generate(
                    environnement.length,
                    (index) => InkWell(
                      onTap: () {
                        setState(() {
                          if (_environnement == index) {
                            _environnement = -1;
                          } else {
                            _environnement = index;
                          }
                        });
                      },
                      child: Container(
                        width: 180,
                        height: 35,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: AppStyles.secondaryColor,
                            border: Border.all(
                              color: _environnement == index
                                  ? AppStyles.primaryColor
                                  : Colors.transparent,
                            )),
                        child: Center(
                          child: Text(
                            '${environnement[index]}',
                            style: TextStyle(
                                color: _environnement == index
                                    ? AppStyles.primaryColor
                                    : Colors.black,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins'),
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Text(
                "Votre logement est-il accessible en fauteil-roulant ?",
                style: AppStyles.bodyStyle,
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: List.generate(
                    fauteil.length,
                    (index) => InkWell(
                      onTap: () {
                        setState(() {
                          if (_fauteil == index) {
                            _fauteil = -1;
                          } else {
                            _fauteil = index;
                          }
                        });
                      },
                      child: Container(
                        width: 180,
                        height: 35,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: AppStyles.secondaryColor,
                            border: Border.all(
                              color: _fauteil == index
                                  ? AppStyles.primaryColor
                                  : Colors.transparent,
                            )),
                        child: Center(
                          child: Text(
                            '${fauteil[index]}',
                            style: TextStyle(
                                color: _fauteil == index
                                    ? AppStyles.primaryColor
                                    : Colors.black,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins'),
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Text(
                "Disposez-vous d\'un ascenseur ? ",
                style: AppStyles.bodyStyle,
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: List.generate(
                    ascenseur.length,
                    (index) => InkWell(
                      onTap: () {
                        setState(() {
                          if (_ascenseur == index) {
                            _ascenseur = -1;
                          } else {
                            _ascenseur = index;
                          }
                        });
                      },
                      child: Container(
                        width: 180,
                        height: 35,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: AppStyles.secondaryColor,
                            border: Border.all(
                              color: _ascenseur == index
                                  ? AppStyles.primaryColor
                                  : Colors.transparent,
                            )),
                        child: Center(
                          child: Text(
                            '${ascenseur[index]}',
                            style: TextStyle(
                                color: _ascenseur == index
                                    ? AppStyles.primaryColor
                                    : Colors.black,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins'),
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Text(
                "Avons-nous la possibilité de cuisiner sur place ?",
                style: AppStyles.bodyStyle,
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: List.generate(
                    cuisine.length,
                    (index) => InkWell(
                      onTap: () {
                        setState(() {
                          if (_cuisine == index) {
                            _cuisine = -1;
                          } else {
                            _cuisine = index;
                          }
                        });
                      },
                      child: Container(
                        width: 180,
                        height: 35,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: AppStyles.secondaryColor,
                            border: Border.all(
                              color: _cuisine == index
                                  ? AppStyles.primaryColor
                                  : Colors.transparent,
                            )),
                        child: Center(
                          child: Text(
                            '${cuisine[index]}',
                            style: TextStyle(
                                color: _cuisine == index
                                    ? AppStyles.primaryColor
                                    : Colors.black,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins'),
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(right: 20, top: 120, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      if (_selectedAnimals.isEmpty ||
                          _animals == -1 ||
                          _environnement == -1 ||
                          _fauteil == -1 ||
                          _ascenseur == -1 ||
                          _cuisine == -1) {
                        Fluttertoast.showToast(
                            msg: 'Enter all fields !!!',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FourthStepScreen(
                                selectedType: widget.selectedType,
                                selectedPlace: widget.selectedPlace,
                                selectedCnx: widget.selectedCnx,
                                selectedTransport: widget.selectedTransport,
                                selectedEquipements: widget.selectedEquipements,
                                selectedDescription: widget.selectedDescription,
                                selectedStartTime: widget.selectedStartTime,
                                selectedEndTime: widget.selectedEndTime,
                                selectedStartDate: widget.selectedStartDate,
                                selectedEndDate: widget.selectedEndDate,
                                selectedDays: widget.selectedDays,
                                selectedAnimals: _selectedAnimals,
                                animalsbool: _animals,
                                environnementbool: _environnement,
                                fauteilbool: _fauteil,
                                ascenseurbool: _ascenseur,
                                cuisinebool: _cuisine),
                          ),
                        );
                      }
                    },
                    child: Container(
                      width: 350,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                          color: AppStyles.primaryColor,
                          borderRadius: BorderRadius.circular(4)),
                      child: Center(
                        child: Text(
                          "Suivant",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FourthStepScreen extends StatefulWidget {
  final String selectedType;
  final List<String> selectedPlace;
  final List<String> selectedDays;

  final List<String> selectedCnx;
  final List<String> selectedTransport;
  final TextEditingController selectedStartDate;
  final TextEditingController selectedEndDate;

  final TextEditingController selectedStartTime;
  final TextEditingController selectedEndTime;
  final String selectedDescription;
  final List<String> selectedEquipements;

  final List<String> selectedAnimals;
  final int animalsbool;
  final int environnementbool;
  final int fauteilbool;
  final int ascenseurbool;
  final int cuisinebool;

  const FourthStepScreen({
    Key? key,
    required this.selectedType,
    required this.selectedPlace,
    required this.selectedCnx,
    required this.selectedDays,
    required this.selectedTransport,
    required this.selectedStartDate,
    required this.selectedEndDate,
    required this.selectedStartTime,
    required this.selectedEndTime,
    required this.selectedDescription,
    required this.selectedEquipements,
    required this.selectedAnimals,
    required this.animalsbool,
    required this.environnementbool,
    required this.fauteilbool,
    required this.ascenseurbool,
    required this.cuisinebool,
  }) : super(key: key);
  @override
  State<FourthStepScreen> createState() => _FourthStepScreenState();
}

class _FourthStepScreenState extends State<FourthStepScreen> {
  String _selectedVille = "";
  String _selectedName = "";
  String _selectedLocation = "";
  double _selectedPrice = 0;
  int _selectedNbPlaces = 0;

  List<XFile>? _images;
  List<File>? _files;

  Future<void> _selectImages() async {
    final List<XFile>? selectedImages = await ImagePicker().pickMultiImage();
    if (selectedImages != null && selectedImages.isNotEmpty) {
      setState(() {
        _images = selectedImages;
      });
    }
  }

  Future<void> _selectFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'doc',
        'docx'
      ], // Add the allowed file extensions here
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        if (_files != null) {
          _files!.addAll(result.files.map((file) => File(file.path!)));
        } else {
          _files = result.files.map((file) => File(file.path!)).toList();
        }
      });
    }
  }

  String getFileExtension(String filePath) {
    return path.extension(filePath).toLowerCase();
  }

  Color getFileIconColor(String extension) {
    if (extension == '.pdf') {
      return Colors.red;
    } else if (extension == '.doc' || extension == '.docx') {
      return Colors.blue;
    } else {
      return Colors.black;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 35, left: 6),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: AppStyles.primaryColor,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Text(
                "Dites-nous ou se trouve votre igloo ?",
                style: AppStyles.bodyStyle,
              ),
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                padding: EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Color(0xfff5f5f5),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Color(0xffd2d2d2)),
                ),
                child: TextField(
                  onChanged: (value) {
                    _selectedVille = value;
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Ville ...',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  ),
                )),
            SizedBox(
              height: 20,
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                padding: EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Color(0xfff5f5f5),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Color(0xffd2d2d2)),
                ),
                child: TextField(
                  onChanged: (value) {
                    _selectedLocation = value;
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Avenue ...',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Text(
                "On part sur quel prix ?",
                style: AppStyles.bodyStyle,
              ),
            ),
            Container(
              width: 150,
              margin: EdgeInsets.symmetric(horizontal: 30),
              padding: EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Color(0xffd2d2d2)),
              ),
              child: TextField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: Icon(
                    Icons.euro,
                    color: AppStyles.primaryColor,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _selectedPrice = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Text(
                "Combien de personnes vous acceptez ?",
                style: AppStyles.bodyStyle,
              ),
            ),
            Container(
              width: 150,
              margin: EdgeInsets.symmetric(horizontal: 30),
              padding: EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Color(0xffd2d2d2)),
              ),
              child: TextField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: Icon(
                    Icons.person,
                    color: AppStyles.primaryColor,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _selectedNbPlaces = int.parse(value);
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Text(
                "Comment souhaitez-vous appeler votre igloo ?",
                style: AppStyles.bodyStyle,
              ),
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                padding: EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Color(0xfff5f5f5),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Color(0xffd2d2d2)),
                ),
                child: TextField(
                  onChanged: (value) {
                    _selectedName = value;
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Soyez original ...',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Plus qu\'a rajouter des photos de ton logement",
                      style: AppStyles.bodyStyle,
                    ),
                  ),
                  InkWell(
                      onTap: _selectImages,
                      child: Image.asset("images/upload.png"))
                ],
              ),
            ),
            _images != null && _images!.isNotEmpty
                ? Container(
                    height: 130,
                    margin: EdgeInsets.symmetric(horizontal: 14),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _images!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Image.file(
                            File(_images![index].path),
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                          ),
                        );
                      },
                    ),
                  )
                : Container(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Text(
                "Ultime étape : ",
                style: AppStyles.bodyStyle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Joins nous une pièce d’identité.",
                    style: AppStyles.bodyStyle2,
                  ),
                  InkWell(
                      onTap: _selectFiles,
                      child: Image.asset("images/upload.png")),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Joins nous justificatif de domicile.",
                    style: AppStyles.bodyStyle2,
                  ),
                  InkWell(
                      onTap: _selectFiles,
                      child: Image.asset("images/upload.png"))
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),

            // Display selected files
            if (_files != null && _files!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _files!.map((file) {
                  String extension = getFileExtension(file.path);
                  IconData? icon;
                  Color iconColor = getFileIconColor(extension);

                  if (extension == '.pdf') {
                    icon = Icons.picture_as_pdf;
                  } else if (extension == '.doc' || extension == '.docx') {
                    icon = Icons.description;
                  } else {
                    icon = Icons.attach_file;
                  }
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 25, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          path.basename(file.path),
                          style: AppStyles.bodyStyle3,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Icon(
                          icon,
                          color: iconColor,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            Padding(
              padding: const EdgeInsets.only(right: 20, top: 15, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      if (_selectedName == "" ||
                          _selectedVille == "" ||
                          _selectedLocation == "" ||
                          _selectedPrice == 0 ||
                          _selectedNbPlaces == 0 ||
                          _images!.isEmpty ||
                          _files!.isEmpty) {
                        Fluttertoast.showToast(
                            msg: 'Enter all fields !!!',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      } else {
                        convertAddressToLatLng(_selectedLocation)
                            .then((latLng) {
                          IgloosService()
                              .addIgloo(
                                  widget.selectedType,
                                  widget.selectedPlace,
                                  widget.selectedCnx,
                                  widget.selectedDays,
                                  widget.selectedTransport,
                                  widget.selectedStartDate,
                                  widget.selectedEndDate,
                                  widget.selectedStartTime,
                                  widget.selectedEndTime,
                                  widget.selectedDescription,
                                  widget.selectedEquipements,
                                  widget.selectedAnimals,
                                  widget.animalsbool,
                                  widget.environnementbool,
                                  widget.fauteilbool,
                                  widget.ascenseurbool,
                                  widget.cuisinebool,
                                  _selectedName,
                                  _selectedVille,
                                  _selectedLocation,
                                  _selectedPrice,
                                  _selectedNbPlaces,
                                  _images,
                                  _files,
                                  latLng.latitude,
                                  latLng.longitude)
                              .then((val) {
                            if (val["success"] == true) {
                              Fluttertoast.showToast(
                                  msg: 'Igloo saved successfully',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Navbar()),
                              );
                            }
                          });
                        }).catchError((error) {
                          print('Error: $error');
                        });
                      }
                    },
                    child: Container(
                      width: 350,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                          color: AppStyles.primaryColor,
                          borderRadius: BorderRadius.circular(4)),
                      child: Center(
                        child: Text(
                          "Valider",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
