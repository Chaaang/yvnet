import 'dart:ui';

import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:yvnet/model/meeting.dart';

class MeetingDataSource extends CalendarDataSource{
  MeetingDataSource(List<Meeting> source){
    appointments = source;
  }

  @override
  DateTime getStartTime(int index){
    return appointments![index].from;
  }
  @override
  DateTime getEndTime(int index){
    return appointments![index].to;
  }

  @override
  String getSubject(int index){
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index){
    return appointments![index].background;
  }

  String getVenue(int index){
    return appointments![index].venue;
  }

  String getDescription(int index){
    return appointments![index].description;
  }
  String getCC (int index){
    return appointments![index].cc; 
  }

    String getId (int index){
    return appointments![index].id; 
  }


}