import 'package:flutter/material.dart';

class TripDetailsScreen extends StatefulWidget {
  final int tripId;
  final bool fromNotification;
  const TripDetailsScreen({super.key, required this.tripId, this.fromNotification = false});

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {


  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
