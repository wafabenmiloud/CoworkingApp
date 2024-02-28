// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:dio/dio.dart';
import 'package:front/screens/filter_screen.dart';
import 'package:front/screens/igloo_screen.dart';
import 'package:front/screens/igloos_screen.dart';
import 'package:front/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final Position currentPosition;

  HomeScreen({required this.currentPosition});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List igloos = [];
  List filteredIgloos = [];

  @override
  void initState() {
    super.initState();
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
      Dio dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';
      final res = await dio.get('$server/getigloos');
      return res.data;
    } catch (error) {
      print('Error fetching data: $error');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomPaint(
      painter: LogoPainter(),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 40),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('images/logo.svg'),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'IglooWorking',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                          color: Colors.white),
                    )
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Marre de télétravailler seul ?",
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                          color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                    children: [
                      TextSpan(
                        text:
                            'IglooWorking est la solution de télétravail entre ',
                      ),
                      TextSpan(
                        text: 'particuliers.',
                        style: TextStyle(
                          fontSize: 26,
                          fontFamily: 'Pecita',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Listener(
                    onPointerDown: (_) => FocusScope.of(context).unfocus(),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          filteredIgloos = igloos
                              .where((igloo) => igloo['igloo_name']
                                  .toString()
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                              .toList();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Trouves ton igloo ...',
                        suffixIcon: InkWell(
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => IglooScreen(
                                          currentPosition:
                                              widget.currentPosition,
                                        )),
                              );
                            },
                            child: Image.asset('images/filter.png')),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 25),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Villes populaires',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            fontFamily: 'Poppins',
                            color: Colors.black),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 170,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: igloos.length,
                        itemBuilder: (context, index) {
                          return Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 2),
                              height: 200,
                              width: 130,
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    height: 99,
                                    width: 115,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(35),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(35),
                                      child: Image.asset(
                                        'images/img.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${igloos[index]['ville']}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 16,
                                          fontFamily: 'Poppins',
                                          color: Colors.black),
                                    ),
                                  )
                                ],
                              ));
                        }),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Juste à coté de vous',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            fontFamily: 'Poppins',
                            color: Colors.black),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: filteredIgloos.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Igloo(
                                        igloo_id: filteredIgloos[index]['id'])),
                              );
                            },
                            child: Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 2),
                                height: 200,
                                width: 130,
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      height: 99,
                                      width: 115,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(35),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(35),
                                        child: Image.asset(
                                          'images/img.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "${filteredIgloos[index]['igloo_name']}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 16,
                                            fontFamily: 'Poppins',
                                            color: Colors.black),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        " à ${calculateDistance(widget.currentPosition.latitude, widget.currentPosition.longitude, filteredIgloos[index]['latitude'].toDouble(), filteredIgloos[index]['longitude'].toDouble()).ceil()} km de vous",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 12,
                                            fontFamily: 'Poppins',
                                            color: Color(0xff494949)),
                                      ),
                                    )
                                  ],
                                )),
                          );
                        }),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }
}

class LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var rect = Offset.zero & size;
    Paint paint = Paint();
    Path path = Path();
    paint.shader = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xffA39DE4),
        Color(0xff5CD6D6),
      ],
    ).createShader(rect);
    path.lineTo(0, size.height);
    path.conicTo(
        size.width, size.height, size.width, size.height - size.height / 80, 9);
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawShadow(path, AppStyles.primaryColor, 4, false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
