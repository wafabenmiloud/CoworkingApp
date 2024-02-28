import 'package:firebase_auth/firebase_auth.dart';
import 'package:front/screens/addIgloo_screen.dart';
import 'package:front/screens/help_screen.dart';
import 'package:front/screens/languages_screen.dart';
import 'package:front/screens/paiment_screen.dart';
import 'package:front/screens/personalInfo_screen.dart';
import 'package:front/services/authservice.dart';
import 'package:front/services/firebaseservice.dart';
import 'package:front/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userInfo = {};
  @override
  void initState() {
    super.initState();
    AuthService().getUser().then((data) {
      setState(() {
        userInfo = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 35, right: 25, left: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Profil",
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PersonalInfoScreen()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 80,
                      width: 100,
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(35),
                        child: Image.asset(
                          'images/user.png',
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ' ${userInfo != null ? userInfo['fullname'] ?? '' : ''}',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 24,
                              fontFamily: 'Poppins',
                              color: Colors.black),
                        ),
                        Text(
                          'Afficher le profil',
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              color: Colors.black),
                        ),
                      ],
                    ),
                    Container(
                      child: Icon(Icons.arrow_forward_ios),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddIglooScreen()),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: 180,
                  decoration: BoxDecoration(
                    color: AppStyles.secondaryColor,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Partagez votre espace de travail sur ',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff494949),
                        ),
                      ),
                      Text(
                        'CoWorkHome',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppStyles.primaryColor,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Ne travaillez plus seul et gagnez de l\'argent en toute simplicité',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: ClipRRect(
                              child: Image.asset(
                                'images/Vector.png',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Paramètres",
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PersonalInfoScreen()),
                  );
                },
                child: Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(35),
                        child: Image.asset(
                          'images/p1.png',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Informations personnelles',
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          color: Colors.black),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
              Divider(
                color: Color(0xffcccccc),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PaiementScreen()),
                  );
                },
                child: Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(35),
                        child: Image.asset(
                          'images/p2.png',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          'Paiements et versements',
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 18,
                              fontFamily: 'Poppins',
                              color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Container(
                      child: Icon(Icons.arrow_forward_ios),
                    )
                  ],
                ),
              ),
              Divider(
                color: Color(0xffcccccc),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HelpScreen()),
                  );
                },
                child: Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(35),
                        child: Image.asset(
                          'images/p3.png',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Obtenir de l\'aide',
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          color: Colors.black),
                    ),
                    SizedBox(
                      width: 115,
                    ),
                    Container(
                      child: Icon(Icons.arrow_forward_ios),
                    )
                  ],
                ),
              ),
              Divider(
                color: Color(0xffcccccc),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LanguagesScreen()),
                  );
                },
                child: Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(35),
                        child: Image.asset(
                          'images/p4.png',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Langues',
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          color: Colors.black),
                    ),
                    SizedBox(
                      width: 192,
                    ),
                    Container(
                      child: Icon(Icons.arrow_forward_ios),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () async {
                  FirebaseService().signOutFromGoogle(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Logout',
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          color: Colors.black),
                    ),
                    Container(
                        height: 40,
                        width: 40,
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Container(
                          child: Icon(Icons.logout),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
