import 'package:front/services/authservice.dart';
import 'package:front/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  // Define variables to hold the user's profile data
  final TextEditingController _name = TextEditingController();
  final TextEditingController _nickname = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _location = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _country = TextEditingController();
  final TextEditingController _genre = TextEditingController();

  bool _editable = false;
  var userInfo = {};
  @override
  void initState() {
    super.initState();
    AuthService().getUser().then((data) {
      print(data);
      setState(() {
        userInfo = data;
        _name.text = userInfo['fullname'] ?? '';
        _nickname.text = userInfo['nickname'] ?? '';
        _email.text = userInfo['email'] ?? '';
        _location.text = userInfo['address'] ?? '';
        _phone.text = userInfo['phone_number'] ?? '';
        _country.text = userInfo['country'] ?? '';
        _genre.text = userInfo['gender'] ?? '';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                    width: 5,
                  ),
                  Text(
                    "Informations Personnelles",
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          color: Color(0xffF3F8FF),
                          child: TextField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                labelText: 'Full name'),
                            controller: _name,
                            readOnly: !_editable,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 35),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          color: Color(0xffF3F8FF),
                          child: TextField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                labelText: 'Nick name'),
                            controller: _nickname,
                            readOnly: !_editable,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 35),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          color: Color(0xffF3F8FF),
                          child: TextField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                labelText: 'Label'),
                            controller: _email,
                            readOnly: !_editable,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 35),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0xffF3F8FF),
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10)),
                          child: InternationalPhoneNumberInput(
                            initialValue: PhoneNumber(isoCode: 'FR'),
                            onInputChanged: (PhoneNumber number) {
                              setState(() {
                                _phone.text = number.phoneNumber.toString();
                              });
                            },
                            isEnabled: _editable,
                            inputDecoration: InputDecoration(
                              labelText: 'Phone number',
                            ),
                            selectorConfig: SelectorConfig(
                              selectorType: PhoneInputSelectorType.DROPDOWN,
                            ),
                            textFieldController: _phone,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 35),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          color: Color(0xffF3F8FF),
                          child: TextField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                labelText: 'Country'),
                            controller: _country,
                            readOnly: !_editable,
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Container(
                          color: Color(0xffF3F8FF),
                          child: TextField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                labelText: 'Genre'),
                            controller: _genre,
                            readOnly: !_editable,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 35),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          color: Color(0xffF3F8FF),
                          child: TextField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                labelText: 'Address'),
                            controller: _location,
                            readOnly: !_editable,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 35),
                  _editable
                      ? InkWell(
                          onTap: _save,
                          child: Container(
                            width: 350,
                            padding: EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                                color: AppStyles.primaryColor,
                                borderRadius: BorderRadius.circular(4)),
                            child: Center(
                              child: Text(
                                "Save",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 19,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        )
                      : InkWell(
                          onTap: _edit,
                          child: Container(
                            width: 350,
                            padding: EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                                color: AppStyles.primaryColor,
                                borderRadius: BorderRadius.circular(4)),
                            child: Center(
                              child: Text(
                                "Edit profile",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 19,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _edit() {
    setState(() {
      _editable = true;
    });
  }

  void _save() {
    setState(() {
      _editable = false;
    });
    AuthService().updateUser(_name.text, _nickname.text, _email.text,
        _phone.text, _country.text, _genre.text, _location.text);
  }
}
