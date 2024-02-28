import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Reservation extends StatefulWidget {
  final int reservationId;

  const Reservation({Key? key, required this.reservationId}) : super(key: key);
  @override
  State<Reservation> createState() => _ReservationState();
}

class _ReservationState extends State<Reservation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Réservation n°${widget.reservationId}",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Réservation validée!",
              style: TextStyle(
                fontSize: 18,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
