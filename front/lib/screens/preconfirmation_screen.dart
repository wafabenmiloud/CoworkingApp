import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:front/constants.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:dio/dio.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:front/screens/reservation_screen.dart';
import 'dart:math';

import 'package:intl/intl.dart';

import '../services/igloosservice.dart';

int generateReservationId() {
  Random random = new Random();
  int reservationId = random.nextInt(900000) + 100000;
  return reservationId;
}

class PreconfScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final int places;
  const PreconfScreen({
    Key? key,
    required this.data,
    required this.places,
  }) : super(key: key);

  @override
  State<PreconfScreen> createState() => _PreconfScreenState();
}

class _PreconfScreenState extends State<PreconfScreen> {
  String message = "";
  int nbplaces = 1;
  bool modified = false;
  Map<String, dynamic>? paymentIntent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(children: [
        Expanded(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    right: 18, left: 18, top: 35, bottom: 25),
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
                          "Confirmation",
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
                          widget.data['liked'] == true
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: AppStyles.primaryColor,
                          size: 30,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      height: 160,
                      width: 160,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: ClipRRect(
                        child: Image.asset(
                          'images/img.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.data['igloo_name']}",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            fontFamily: 'Poppins',
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "${widget.data['price']} £/jours",
                          style: TextStyle(
                              color: Color(0xffA1A0E4),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Poppins'),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "${widget.data['location']}",
                          style: TextStyle(
                              color: Color(0xffA1A0E4),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Poppins'),
                        ),
                        SizedBox(
                          height: 5,
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
                              "${widget.data['rate']}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins'),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Votre réservation",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Date",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins'),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            widget.data['startDate'] != null
                                ? DateFormat('dd MMM yyyy', 'fr').format(
                                    DateTime.parse(widget.data['startDate']))
                                : '',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins'),
                          ),
                          Text(
                            'A',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins'),
                          ),
                          Text(
                            widget.data['endDate'] != null
                                ? DateFormat('dd MMM yyyy', 'fr').format(
                                    DateTime.parse(widget.data['endDate']))
                                : '',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins'),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Nombre de personne",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins'),
                          ),
                          InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(""),
                                    content: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 14),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                            color: Color(0xffd2d2d2)),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.person),
                                          SizedBox(width: 10),
                                          DropdownButton<int>(
                                            dropdownColor:
                                                AppStyles.secondaryColor,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Poppins',
                                            ),
                                            underline: Container(),
                                            padding: EdgeInsets.all(0),
                                            value: nbplaces,
                                            onChanged: (newValue) {
                                              setState(() {
                                                nbplaces = newValue!;
                                                modified = true;
                                              });
                                              Navigator.of(context).pop();
                                            },
                                            items: widget.data['nb_places'] !=
                                                    null
                                                ? List.generate(
                                                    widget.data['nb_places'],
                                                    (index) {
                                                    return DropdownMenuItem(
                                                      value: index + 1,
                                                      child:
                                                          Text("${index + 1}"),
                                                    );
                                                  })
                                                : null,
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Text(
                              "Modifier",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        modified == false
                            ? "${widget.places} personnes"
                            : "${nbplaces} personnes",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Conditions d\'annulation",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins'),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "50% de remboursement 24h avant",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins'),
                      ),
                      Text(
                        "100% de remboursement 48h avant",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Détails du prix",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins'),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${widget.data['price']}£ x 1 jour",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins'),
                          ),
                          Text(
                            "${widget.data['price']}£",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins'),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Envoyer un message pour accompagner votre réservation",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins'),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          color: Color(0xffebebeb),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: TextField(
                          onChanged: (value) {
                            message = value;
                          },
                          minLines: 8,
                          maxLines: null,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Ecris un message à ton pingouin !',
                          ),
                        ),
                      ),
                    ]),
              )
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
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "Moyens de paiement",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                  color: Colors.black,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Icon(Icons.close),
                              ),
                            ],
                          ),
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                onTap: () async {
                                  await makePayment();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 28, horizontal: 36),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.25),
                                        offset: Offset(0, 4),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: Image.asset('images/stripe.png'),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UsePaypal(
                                            sandboxMode: true,
                                            clientId: "$PaypalClintID",
                                            secretKey: "$PaypalSecret",
                                            returnURL:
                                                "https://samplesite.com/return",
                                            cancelURL:
                                                "https://samplesite.com/cancel",
                                            transactions: const [
                                              {
                                                "amount": {
                                                  "total": '10.12',
                                                  "currency": "USD",
                                                  "details": {
                                                    "subtotal": '10.12',
                                                    "shipping": '0',
                                                    "shipping_discount": 0
                                                  }
                                                },
                                                "description":
                                                    "The payment transaction description.",
                                                "item_list": {
                                                  "items": [
                                                    {
                                                      "name": "A demo product",
                                                      "quantity": 1,
                                                      "price": '10.12',
                                                      "currency": "USD"
                                                    }
                                                  ],
                                                }
                                              }
                                            ],
                                            note:
                                                "Contact us for any questions on your order.",
                                            onSuccess: (Map params) async {
                                              print("onSuccess: $params");
                                            },
                                            onError: (error) {
                                              print("onError: $error");
                                            },
                                            onCancel: (params) {
                                              print('cancelled: $params');
                                            })),
                                  );
                                },
                                child: Container(
                                    padding: EdgeInsets.all(18),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.25),
                                          offset: Offset(0, 4),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: Image.asset('images/paypal.png')),
                              )
                            ],
                          ));
                    },
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
                      "Payer ${widget.data['price']} £",
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

//stripe payment
  Future<void> makePayment() async {
    try {
      paymentIntent =
          await createPaymentIntent('${widget.data['price']}', 'EUR');
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent!['client_secret'],
                  style: ThemeMode.dark,
                  merchantDisplayName: 'Wafa'))
          .then((value) {});

      displayPaymentSheet();
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                          Text("Payment Successfull"),
                        ],
                      ),
                    ],
                  ),
                ));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Reservation(
              reservationId: generateReservationId(),
            ),
          ),
        );

        paymentIntent = null;
      }).onError((error, stackTrace) {
        print('Error is:--->$error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      print('$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      var dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $StripeKey';
      dio.options.headers['Content-Type'] = 'application/x-www-form-urlencoded';

      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await dio.post(
        'https://api.stripe.com/v1/payment_intents',
        data: body,
      );
      print('Payment Intent Body->>> ${response.data.toString()}');
      return response.data;
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100;
    return calculatedAmout.toString();
  }
}
