import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:front/screens/forgetpass_screen.dart';
import 'package:front/screens/signup_screen.dart';
import 'package:front/services/authservice.dart';
import 'package:front/constants.dart';
import 'package:front/widgets/googlebutton.dart';
import 'package:front/widgets/navbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool passToggle = true;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10, left: 20),
                      child: Text(
                        "Connexion",
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
              Padding(
                padding: const EdgeInsets.only(right: 15, left: 20),
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
                    Container(
                      width: 130,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: AppStyles.primaryColor,
                      ),
                      child: Center(
                        child: Text(
                          "Connexion",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUp()),
                        );
                      },
                      child: Container(
                        width: 130,
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Center(
                          child: Text(
                            "Inscription",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Forget()),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 46),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Mot de passe oublié ?',
                                style: TextStyle(
                                    color: AppStyles.primaryColor,
                                    fontFamily: 'poppins',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 5),
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.black45,
                            ),
                          ),
                          Center(
                            child: Container(
                              color: Colors.white,
                              child: Text('ou',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(child: GoogleSignInButton()),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Tu n'a pas encore de compte ?",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400)),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUp()),
                              );
                            },
                            child: Text(' Inscris toi ici',
                                style: TextStyle(
                                    color: AppStyles.primaryColor,
                                    fontFamily: 'poppins',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800)),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              AuthService()
                                  .login(_emailController.text,
                                      _passwordController.text)
                                  .then((val) {
                                if (val.data['success']) {
                                  Fluttertoast.showToast(
                                      msg: 'LoggedIn successfully',
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
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 14),
                            width: 340,
                            decoration: BoxDecoration(
                                color: AppStyles.primaryColor,
                                borderRadius: BorderRadius.circular(4)),
                            child: Center(
                              child: Text(
                                "Connexion",
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
