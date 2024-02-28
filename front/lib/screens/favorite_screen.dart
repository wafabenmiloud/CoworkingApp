import 'package:dio/dio.dart';
import 'package:front/screens/igloo_screen.dart';
import 'package:front/screens/igloos_screen.dart';
import 'package:front/constants.dart';
import 'package:flutter/material.dart';
import 'package:front/services/igloosservice.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

var igloos = [];

class FavoriteScreen extends StatefulWidget {
  final Position currentPosition;

  FavoriteScreen({required this.currentPosition});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  var likedIgloos = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      Dio dio = new Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';
      final res = await dio.get('$server/getigloos');
      final data = res.data;
      setState(() {
        igloos = data;
        likedIgloos = igloos.where((igloo) => igloo['liked'] == true).toList();
      });
    } catch (error) {
      print('Error fetching data: $error');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 25, left: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Favoris",
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: likedIgloos.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Igloo(igloo_id: igloos[index]['id'])),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 40, right: 25, left: 25),
                    decoration: BoxDecoration(
                        color: AppStyles.secondaryColor,
                        borderRadius: BorderRadius.circular(25)),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                                                  "${igloos[index]['rate']}",
                                                  style: TextStyle(
                                                      color: Color(0xff494949),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
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
                                            " ${igloos[index]['price']}£",
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
                                            "${igloos[index]['nb_places']} places",
                                            style: TextStyle(
                                                color: Color(0xff494949),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'Poppins'),
                                          ),
                                        ),
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        await IgloosService()
                                            .likeDislike(igloos[index]['id']);
                                        fetchData();
                                      },
                                      child: Icon(
                                        igloos[index]['liked']
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: AppStyles.primaryColor,
                                        size: 30,
                                      ),
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
                                " ${igloos[index]['igloo_name']}",
                                style: TextStyle(
                                    color: Color(0XFF000000),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins'),
                              ),
                              Column(
                                children: [
                                  Text(
                                    " ${igloos[index]['ville']}",
                                    style: TextStyle(
                                        color: Color(0xff494949),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Poppins'),
                                  ),
                                  Text(
                                    " à ${calculateDistance(widget.currentPosition.latitude, widget.currentPosition.longitude, igloos[index]['latitude'].toDouble(), igloos[index]['longitude'].toDouble()).ceil()} km de vous",
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
      ),
    );
  }
}
