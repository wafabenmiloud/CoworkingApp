// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  bool isFiltering = false;

  TextEditingController _selectedDate = TextEditingController();
  TextEditingController _selectedStartTime = TextEditingController();
  TextEditingController _selectedEndTime = TextEditingController();
  var _selectedVille;
  var _selectedPlaces;

  RangeValues _currentPriceRange = RangeValues(0, 500);
  double _minPrice = 0;
  double _maxPrice = 500;

  RangeValues _currentDistanceRange = RangeValues(0, 2000);
  double _minDistance = 0;
  double _maxDistance = 2000;

  final List<String> type = ['Maison', 'Appart', 'Chalet', 'Studio'];
  List<String> _selectedType = [];
  final List<int> avis = [1, 2, 3, 4, 5];
  List<int> _selectedAvis = [];

  final List<String> others = [
    'Bureau',
    'Cuisine possible',
    'Fumeurs',
    'Animaux',
    'Parking gratuit',
    'Fibre'
  ];
  List<String> _selectedOthers = [];

  @override
  void initState() {
    _selectedDate.text = "";
    _selectedStartTime.text = "";
    _selectedEndTime.text = "";
    _selectedType = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: ListView(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Filtres',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Color(0xff494949),
                            fontSize: 26,
                            fontWeight: FontWeight.w600)),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                        color: AppStyles.primaryColor,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 14),
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                height: 10,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Color(0xffd2d2d2)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _selectedDate,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Select a date',
                                ),
                                readOnly: true,
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1950),
                                    lastDate: DateTime(2100),
                                  );
                                  if (pickedDate != null) {
                                    String formattedDate =
                                        DateFormat('d MMM y', 'fr_FR')
                                            .format(pickedDate);
                                    setState(() {
                                      _selectedDate.text = formattedDate;
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Color(0xffd2d2d2)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.person),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                onChanged: (value) {
                                  _selectedPlaces = value;
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '... places',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Color(0xffd2d2d2)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.timer),
                            SizedBox(width: 10),
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  TimeOfDay? pickedTime = await showTimePicker(
                                    initialTime: TimeOfDay.now(),
                                    context: context,
                                  );
                                  if (pickedTime != null) {
                                    String formattedTime =
                                        DateFormat('HH:mm:ss').format(
                                      DateTime(2023, 1, 1, pickedTime.hour,
                                          pickedTime.minute),
                                    );
                                    setState(() {
                                      _selectedStartTime.text = formattedTime;
                                    });
                                    print(_selectedStartTime.text);
                                  } else {
                                    print("Time is not selected");
                                  }
                                },
                                child: AbsorbPointer(
                                  child: TextField(
                                    controller: _selectedStartTime,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Start',
                                    ),
                                    readOnly: true,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Color(0xffd2d2d2)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.timer),
                            SizedBox(width: 10),
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  TimeOfDay? pickedTime = await showTimePicker(
                                    initialTime: TimeOfDay.now(),
                                    context: context,
                                  );
                                  if (pickedTime != null) {
                                    String formattedTime =
                                        DateFormat('HH:mm:ss').format(
                                      DateTime(2023, 1, 1, pickedTime.hour,
                                          pickedTime.minute),
                                    );
                                    setState(() {
                                      _selectedEndTime.text = formattedTime;
                                    });
                                    print(_selectedEndTime.text);
                                  } else {
                                    print("Time is not selected");
                                  }
                                },
                                child: AbsorbPointer(
                                  child: TextField(
                                    controller: _selectedEndTime,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'End',
                                    ),
                                    readOnly: true,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Text(
                  "Tranche de prix",
                  style: AppStyles.headerStyle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_currentPriceRange.start.toInt().toString()} £',
                      style: TextStyle(
                          color: Color(0xff000000),
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    Text(
                      '${_currentPriceRange.end.toInt().toString()} £',
                      style: TextStyle(
                          color: Color(0xff000000),
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              RangeSlider(
                values: _currentPriceRange,
                min: _minPrice,
                max: _maxPrice,
                onChanged: (RangeValues values) {
                  setState(() {
                    _currentPriceRange = values;
                  });
                },
                divisions: 100,
                labels: RangeLabels(
                  '${_currentPriceRange.start.toInt().toString()} £',
                  '${_currentPriceRange.end.toInt().toString()} £',
                ),
                activeColor: AppStyles.primaryColor,
                inactiveColor: AppStyles.secondaryColor,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Text(
                  "Distance",
                  style: AppStyles.headerStyle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_currentDistanceRange.start.toInt().toString()} Km',
                      style: TextStyle(
                          color: Color(0xff000000),
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    Text(
                      '${_currentDistanceRange.end.toInt().toString()} Km',
                      style: TextStyle(
                          color: Color(0xff000000),
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              RangeSlider(
                values: _currentDistanceRange,
                min: _minDistance,
                max: _maxDistance,
                onChanged: (RangeValues values) {
                  setState(() {
                    _currentDistanceRange = values;
                  });
                },
                divisions: 200,
                labels: RangeLabels(
                  '${_currentDistanceRange.start.toInt().toString()} Km',
                  '${_currentDistanceRange.end.toInt().toString()} Km',
                ),
                activeColor: AppStyles.primaryColor,
                inactiveColor: AppStyles.secondaryColor,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Text(
                  "Type d'igloo",
                  style: AppStyles.headerStyle,
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: List.generate(
                      type.length,
                      (index) => InkWell(
                        onTap: () {
                          setState(() {
                            if (_selectedType.contains(type[index])) {
                              _selectedType.remove(type[index]);
                            } else {
                              _selectedType.add(type[index]);
                            }
                          });
                        },
                        child: Container(
                          width: 85,
                          height: 35,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: AppStyles.secondaryColor,
                              border: Border.all(
                                color: _selectedType.contains(type[index])
                                    ? AppStyles.primaryColor
                                    : Colors.transparent,
                              )),
                          child: Center(
                            child: Text(
                              '${type[index]}',
                              style: TextStyle(
                                  color: _selectedType.contains(type[index])
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Text(
                  "Avis",
                  style: AppStyles.headerStyle,
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: List.generate(
                      avis.length,
                      (index) => InkWell(
                        onTap: () {
                          setState(() {
                            if (_selectedAvis.contains(avis[index])) {
                              _selectedAvis.remove(avis[index]);
                            } else {
                              _selectedAvis.add(avis[index]);
                            }
                          });
                        },
                        child: Container(
                          width: 67,
                          height: 35,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: AppStyles.secondaryColor,
                              border: Border.all(
                                color: _selectedAvis.contains(avis[index])
                                    ? AppStyles.primaryColor
                                    : Colors.transparent,
                              )),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                '${avis[index]}',
                                style: TextStyle(
                                    color: _selectedAvis.contains(avis[index])
                                        ? AppStyles.primaryColor
                                        : Colors.black,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins'),
                              ),
                              Image.asset(
                                'images/igloo.png',
                                width: 25,
                                height: 25,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Text(
                  "+ de filtres",
                  style: AppStyles.headerStyle,
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: List.generate(
                      others.length,
                      (index) => InkWell(
                        onTap: () {
                          setState(() {
                            if (_selectedOthers.contains(others[index])) {
                              _selectedOthers.remove(others[index]);
                            } else {
                              _selectedOthers.add(others[index]);
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
                                color: _selectedOthers.contains(others[index])
                                    ? AppStyles.primaryColor
                                    : Colors.transparent,
                              )),
                          child: Center(
                            child: Text(
                              '${others[index]}',
                              style: TextStyle(
                                  color: _selectedOthers.contains(others[index])
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
            ],
          )),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    isFiltering = true;
                  });
                  Navigator.pop(context, {
                    "selectedVille": _selectedVille,
                    "selectedDate": _selectedDate,
                    "selectedPlaces": _selectedPlaces,
                    "selectedStarttime": _selectedStartTime,
                    "selectedEndtime": _selectedEndTime,
                    "selectedType": _selectedType,
                    "selectedAvis": _selectedAvis,
                    "selectedOthers": _selectedOthers,
                    "priceRange": _currentPriceRange,
                    "distanceRange": _currentDistanceRange,
                    "filter": isFiltering
                  });
                },
                child: Container(
                  width: 400,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                      color: AppStyles.primaryColor,
                      borderRadius: BorderRadius.circular(4)),
                  child: Center(
                    child: Text(
                      "Rechercher des igloos",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
