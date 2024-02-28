import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:front/screens/login_screen.dart';
import 'package:front/services/authservice.dart';
import 'package:front/constants.dart';

class Reset extends StatefulWidget {
  final String code;

  const Reset({Key? key, required this.code}) : super(key: key);

  @override
  State<Reset> createState() => _ResetState();
}

class _ResetState extends State<Reset> {
  bool passToggle = true;
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 20, bottom: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20, bottom: 0, right: 20, left: 15),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: AppStyles.primaryColor,
                        size: 30,
                      ),
                    ),
                  ),
                  Text(
                    "Mot de passe oublié",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        color: Colors.black),
                  ),
                ],
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
              SizedBox(
                height: 35,
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                  height: 187,
                  width: 310,
                  child: SvgPicture.asset("images/login.svg"),
                ),
              ),
              SizedBox(
                height: 35,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 36, vertical: 20),
                child: Text(
                  'Réinitialiser votre mot de passe !',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w300),
                ),
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
                      SizedBox(
                        height: 100,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 36, vertical: 8),
                        child: TextButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              AuthService()
                                  .resetpass(
                                      _passwordController.text, widget.code)
                                  .then((val) {
                                if (val.data['success']) {
                                  Fluttertoast.showToast(
                                      msg: 'Password reset successfully!',
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
                                horizontal: 26, vertical: 14),
                            width: 340,
                            decoration: BoxDecoration(
                                color: AppStyles.primaryColor,
                                borderRadius: BorderRadius.circular(4)),
                            child: Center(
                              child: Text(
                                "Réinitialiser mot de passe",
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
