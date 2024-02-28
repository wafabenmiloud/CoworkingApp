import 'dart:convert';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:front/screens/preconfirmation_screen.dart';
import 'package:front/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/igloosservice.dart';

class Igloo extends StatefulWidget {
  const Igloo({Key? key, required this.igloo_id}) : super(key: key);
  final int igloo_id;
  @override
  State<Igloo> createState() => _IglooState();
}

class _IglooState extends State<Igloo> {
  Map<String, dynamic> _data = {};
  List equipements = [];
  List days = [];

  int nb_places = 1;
  @override
  void initState() {
    super.initState();

    _fetchData().then((data) {
      setState(() {
        _data = data;
        days.addAll(json.decode(_data['days']));
        equipements.addAll(json.decode(_data['equipements']));
        equipements.addAll(json.decode(_data['internet']));
        equipements.addAll(json.decode(_data['transport']));
        equipements.addAll(json.decode(_data['coworking_place']));
        equipements.addAll(json.decode(_data['animals']));
      });
    });
  }

  _fetchData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      Dio dio = new Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';
      final res = await dio.get('$server/getigloos/${widget.igloo_id}');
      return res.data;
    } catch (error) {
      print('Error fetching data: $error');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(children: [
        Expanded(
          child: ListView(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 35),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
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
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "${_data['igloo_name']}",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              fontFamily: 'Poppins',
                              color: Colors.black),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.message_outlined,
                          color: Color(0xffcccccc),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        InkWell(
                          onTap: () async {
                            await IgloosService().likeDislike(_data['id']);
                            final updatedData = await _fetchData();
                            setState(() {
                              _data = updatedData;
                            });
                          },
                          child: Icon(
                            _data['liked'] == true
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: AppStyles.primaryColor,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    child: Image.asset(
                      'images/img.png',
                      fit:
                          BoxFit.cover, // To cover the container with the image
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      child: Container(
                        width: 350,
                        margin:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${_data['igloo_name']}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    fontFamily: 'Poppins',
                                    color: Colors.black,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      'images/igloo.png',
                                      width: 25,
                                      height: 25,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "${_data['rate']}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Poppins'),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.location_on),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "${_data['location']}",
                                  style: TextStyle(
                                      color: Color(0xff2e62e7),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Poppins'),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: Row(
                                children: [
                                  Text(
                                    "${_data['price']} £/jours",
                                    style: TextStyle(
                                        color: Color(0xff2e62e7),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Poppins'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
                              child: Text(
                            _data['startDate'] != null
                                ? DateFormat('dd MMM yyyy', 'fr')
                                    .format(DateTime.parse(_data['startDate']))
                                : '',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          )),
                        ],
                      ),
                    )),
                    Text(
                      " A ",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins'),
                    ),
                    Expanded(
                        child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
                              child: Text(
                            _data['endDate'] != null
                                ? DateFormat('dd MMM yyyy', 'fr')
                                    .format(DateTime.parse(_data['endDate']))
                                : '',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          )),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    right: 14, left: 14, top: 0, bottom: 20),
                child: SizedBox(
                  height: 40,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: days.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(right: 10),
                          width: 80,
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: AppStyles.secondaryColor,
                              border: Border.all(
                                color: Colors.transparent,
                              )),
                          child: Center(
                            child: Text(
                              '${days[index]}',
                              style: TextStyle(
                                  color: Color(0xff494949),
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins'),
                            ),
                          ),
                        );
                      }),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
                                child: Text(
                              "${_data['start_time']}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins'),
                            )),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      " A ",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins'),
                    ),
                    Expanded(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
                                child: Text(
                              "${_data['end_time']}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins'),
                            )),
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
                            Icon(Icons.person),
                            SizedBox(width: 10),
                            DropdownButton<int>(
                              dropdownColor: AppStyles.secondaryColor,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins'),
                              underline: Container(),
                              padding: EdgeInsets.all(0),
                              value: nb_places,
                              onChanged: (newValue) {
                                setState(() {
                                  nb_places = newValue!;
                                });
                              },
                              items: _data['nb_places'] != null
                                  ? List.generate(
                                      int.parse(_data['nb_places'].toString()),
                                      (index) {
                                      return DropdownMenuItem(
                                        value: index + 1,
                                        child: Text("${index + 1}"),
                                      );
                                    })
                                  : null,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    right: 14, left: 14, top: 10, bottom: 10),
                child: SizedBox(
                  height: 40,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: equipements.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(right: 10),
                          width: 160,
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: AppStyles.secondaryColor,
                              border: Border.all(
                                color: Colors.transparent,
                              )),
                          child: Center(
                            child: Text(
                              '${equipements[index]}',
                              style: TextStyle(
                                  color: Color(0xff494949),
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins'),
                            ),
                          ),
                        );
                      }),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                decoration: BoxDecoration(
                  color: AppStyles.secondaryColor,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  "${_data['description']}",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins'),
                ),
              ),
            ],
          ),
        ),
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PreconfScreen(
                        data: _data,
                        places: nb_places,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 400,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                      color: AppStyles.primaryColor,
                      borderRadius: BorderRadius.circular(4)),
                  child: Center(
                    child: Text(
                      "Réserver",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ),
            ))
      ]),
    );
  }
}
