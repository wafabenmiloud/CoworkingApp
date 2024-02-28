// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:front/screens/favorite_screen.dart';
import 'package:front/screens/home_screen.dart';
import 'package:front/screens/igloos_screen.dart';
import 'package:front/screens/messages_screen.dart';
import 'package:front/screens/profile_screen.dart';
import 'package:front/constants.dart';
import 'package:geolocator/geolocator.dart';

//request location permission from the user
Future<void> _requestLocationPermission() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print('User denied location permission');
    }
  }
  if (permission == LocationPermission.deniedForever) {
    print('User permanently denied location permission');
  }
}

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  //get user current location
  Position? _currentPosition;
  _getCurrentLocation() async {
    try {
      await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .then((Position position) async {
        setState(() {
          _currentPosition = position;
        });
        print(_currentPosition);
      }).catchError((e) {
        print(e);
      });
    } catch (e) {
      print("Unknown error getting location: $e");
    }
  }

  int _selectedIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    final _screens = [
      if (_currentPosition != null)
        HomeScreen(currentPosition: _currentPosition!),
      if (_currentPosition != null)
        FavoriteScreen(currentPosition: _currentPosition!),
      if (_currentPosition != null)
        IglooScreen(currentPosition: _currentPosition!),
      NotificationScreen(),
      ProfileScreen(),
    ];
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 25,
        selectedItemColor: AppStyles.primaryColor,
        unselectedItemColor: Color(0xffcccccc),
        selectedLabelStyle:
            TextStyle(color: AppStyles.primaryColor, fontSize: 12),
        unselectedLabelStyle: TextStyle(
            color: Color(0xff000000),
            fontSize: 12,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w300),
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home_filled,
              ),
              label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoris',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'images/igloo.png',
              width: 55,
              height: 55,
            ),
            label: 'Recherche',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            label: 'Message',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
