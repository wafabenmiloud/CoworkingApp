import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:front/screens/login_screen.dart';
import 'package:front/services/authservice.dart';
import 'package:front/constants.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool passToggle = true;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: AppStyles.primaryColor,
                        size: 30,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10, left: 27),
                      child: Text(
                        "Inscription",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                            color: Colors.black),
                      ),
                    ),
                    Icon(
                      Icons.person_outline,
                      color: AppStyles.primaryColor,
                      size: 30,
                    )
                  ],
                ),
              ),
              Center(
                child: Text(
                  "Bienvenue chez CoWorkHome !",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Poppins',
                      color: Colors.black),
                ),
              ),
              SizedBox(height: 15),
              Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      },
                      child: Container(
                        width: 130,
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.transparent,
                        ),
                        child: Center(
                          child: Text(
                            "Connexion",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 130,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                      decoration: BoxDecoration(
                        color: AppStyles.primaryColor,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                        child: Text(
                          "Inscription",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                  height: 200,
                  width: 310,
                  child: SvgPicture.asset("images/signup.svg"),
                ),
              ),
              SizedBox(
                height: 35,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 36),
                        child: SizedBox(
                          height: 75,
                          child: Material(
                            borderRadius: BorderRadius.circular(30),
                            child: TextFormField(
                              controller: _nameController,
                              textAlignVertical: TextAlignVertical.bottom,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: AppStyles.secondaryColor,
                                hintText: "Nom & Prénom",
                              ),
                              validator: (value) {
                                if (value?.trim().isEmpty ?? true) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 36),
                        child: SizedBox(
                          height: 75,
                          child: Material(
                            borderRadius: BorderRadius.circular(30),
                            child: TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                textAlignVertical: TextAlignVertical.bottom,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: AppStyles.secondaryColor,
                                  hintText: "Adresse e-mail",
                                ),
                                validator: (value) {
                                  if (value?.trim().isEmpty ?? true) {
                                    return 'Please enter your email';
                                  }
                                  if (!RegExp(
                                          r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b')
                                      .hasMatch(value!)) {
                                    return 'Please enter a valid email address';
                                  }
                                  return null;
                                }),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 36),
                        child: SizedBox(
                          height: 75,
                          child: Material(
                            borderRadius: BorderRadius.circular(30),
                            child: TextFormField(
                              controller: _passwordController,
                              textAlignVertical: TextAlignVertical.bottom,
                              validator: (value) {
                                if (value?.trim().isEmpty ?? true) {
                                  return 'Please enter your password';
                                } else if (value!.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                              obscureText: passToggle ? true : false,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: AppStyles.secondaryColor,
                                suffixIcon: InkWell(
                                  onTap: () {
                                    if (passToggle == true) {
                                      passToggle = false;
                                    } else {
                                      passToggle = true;
                                    }
                                    setState(() {});
                                  },
                                  child: passToggle
                                      ? Icon(
                                          CupertinoIcons.eye_slash_fill,
                                          color: AppStyles.primaryColor,
                                        )
                                      : Icon(
                                          CupertinoIcons.eye_fill,
                                          color: AppStyles.primaryColor,
                                        ),
                                ),
                                hintText: "Mot de passe",
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 36),
                        child: SizedBox(
                          height: 75,
                          child: Material(
                            borderRadius: BorderRadius.circular(30),
                            child: TextFormField(
                              controller: _confirmPasswordController,
                              textAlignVertical: TextAlignVertical.bottom,
                              validator: (value) {
                                if (value?.trim().isEmpty ?? true) {
                                  return 'Please confirm your password';
                                }
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                              obscureText: passToggle ? true : false,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: AppStyles.secondaryColor,
                                suffixIcon: InkWell(
                                  onTap: () {
                                    if (passToggle == true) {
                                      passToggle = false;
                                    } else {
                                      passToggle = true;
                                    }
                                    setState(() {});
                                  },
                                  child: passToggle
                                      ? Icon(
                                          CupertinoIcons.eye_slash_fill,
                                          color: AppStyles.primaryColor,
                                        )
                                      : Icon(
                                          CupertinoIcons.eye_fill,
                                          color: AppStyles.primaryColor,
                                        ),
                                ),
                                hintText: "Confirmation de Mot de passe",
                              ),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              AuthService()
                                  .register(
                                      _nameController.text,
                                      _emailController.text,
                                      _passwordController.text)
                                  .then((val) {
                                if (val['success'] == true) {
                                  Fluttertoast.showToast(
                                      msg: 'User added successfully',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.green,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen()),
                                  );
                                }
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 14),
                            width: 330,
                            decoration: BoxDecoration(
                                color: AppStyles.primaryColor,
                                borderRadius: BorderRadius.circular(4)),
                            child: Center(
                              child: Text(
                                "Créer mon compte",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 19,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
