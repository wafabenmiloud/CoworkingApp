import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:front/screens/resetpass_screen.dart';
import 'package:front/services/authservice.dart';
import 'package:front/constants.dart';
import 'package:front/widgets/navbar.dart';

class Forget extends StatefulWidget {
  const Forget({super.key});

  @override
  State<Forget> createState() => _ForgetState();
}

class _ForgetState extends State<Forget> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

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
                  'Et bien bravo, vous avez oublié votre mot de passe !',
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
                                  .forgetpass(_emailController.text)
                                  .then((val) {
                                    print(val);
                                if (val.data['success']==true) {
                                  Fluttertoast.showToast(
                                      msg: 'Reset code sent! Check your email!',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.green,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CodeVerification()),
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
                                "Envoyer un mail",
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

class CodeVerification extends StatefulWidget {
  const CodeVerification({super.key});

  @override
  State<CodeVerification> createState() => _CodeVerificationState();
}

class _CodeVerificationState extends State<CodeVerification> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

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
                                controller: _codeController,
                                textAlignVertical: TextAlignVertical.bottom,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: AppStyles.secondaryColor,
                                  hintText: "Verification code",
                                ),
                                validator: (value) {
                                  if (value?.trim().isEmpty ?? true) {
                                    return 'Please enter your verification code';
                                  }

                                  return null;
                                }),
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
                                  .verifycode(_codeController.text)
                                  .then((val) {
                                if (val.data['success']) {
                                  Fluttertoast.showToast(
                                      msg: 'Code verified',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.green,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Reset(
                                              code: _codeController.text,
                                            )),
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
                                "Verify Code",
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
