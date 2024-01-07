import 'package:flutter/material.dart';

class Meeting{
  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  String venue;
  String description;
  String cc;
  String id;
  
  Meeting({
    required this.eventName, 
    required this.from, 
    required this.to, 
    required this.background, 
    required this.venue, 
    required this.description,
    required this.cc,
    required this.id
    });


}