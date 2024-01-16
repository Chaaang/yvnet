import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:yvnet/helper_function/helper_function.dart';
import 'package:yvnet/model/meeting.dart';
import 'package:yvnet/model/meetingDataSource.dart';
import 'package:yvnet/screens/volunteer/viewEvent_details.dart';

class CalenderView extends StatefulWidget {
  final bool hideAppBar;
  const CalenderView({super.key, required this.hideAppBar});

  @override
  State<CalenderView> createState() => _CalenderViewState();
}

class _CalenderViewState extends State<CalenderView> {




    Future<List<Meeting>> _getDataSource()async{
    List<Meeting> meetings = <Meeting>[];

    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('meetings').get();
    if(snapshot.docs.isNotEmpty){
      for (dynamic meeting in snapshot.docs){
        meetings.add(Meeting(
          id: meeting.id,
          eventName: meeting['subject'], 
          from: DateTime.parse(meeting['startTime']), 
          to: DateTime.parse(meeting['endTime']), 
          background: convertStringToColor(meeting['type']), 
          venue: meeting['linkOrVenue'], 
          description: meeting['description'],
          cc: meeting['cc']
          ));
      }
    }
    return meetings;
  }



//   Stream<List<Meeting>> _getDataSource() async* {
//   List<Meeting> meetings = <Meeting>[];

//   try {
//     QuerySnapshot<Map<String, dynamic>> snapshot =
//         await FirebaseFirestore.instance.collection('meetings').get();

//     for (QueryDocumentSnapshot<Map<String, dynamic>> meeting in snapshot.docs) {
//       meetings.add(Meeting(
//         eventName: meeting['subject'],
//         from: DateTime.parse(meeting['startTime']),
//         to: DateTime.parse(meeting['endTime']),
//         background: convertStringToColor(meeting['type']),
//         venue: meeting['linkOrVenue'],
//         description: meeting['description'],
//         cc: meeting['cc'],
//       ));
//     }

//     yield meetings;
//   } catch (error) {
//     // Handle error, e.g., print or log it
//     print("Error fetching meetings: $error");
//     yield []; // Return an empty list in case of an error
//   }
// }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
         appBar: widget.hideAppBar ? null : AppBar(
        backgroundColor: Colors.transparent,
        title: Row(
          children: [Icon(Icons.calendar_month_outlined, color: Colors.amber[400], size: 35,), 
                    const SizedBox(width: 10,),
                    Text('Schedule',
                    style: TextStyle(
                      fontSize: 35, 
                      fontWeight: FontWeight.w900, 
                      color: Colors.amber[400]),),
        ]),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios_new, color: Colors.amber[400]),
        ),
         ),
        body: FutureBuilder(
            future: _getDataSource(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if(snapshot.data != null && snapshot.connectionState ==  ConnectionState.done){
                return SfCalendar(
                  dataSource: MeetingDataSource(snapshot.data),
                  monthViewSettings: const MonthViewSettings(
                    appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
                    showAgenda: true),
                  view: CalendarView.month,
                  onTap: (CalendarTapDetails details) {
              if (details.appointments != null && details.targetElement == CalendarElement.appointment) {
                 final Meeting tappedAppointment = details.appointments![0] as Meeting;
                 Navigator.push(context, MaterialPageRoute(builder: (context) => ViewEventDetails(appointment: tappedAppointment),));
              }
                  },
                );
              }else if(snapshot.connectionState == ConnectionState.waiting){
                return const Center(child: CircularProgressIndicator());
              }else{
                return const Center(child: Text('No Data'));
              }
            },
        ),
      ),
    );

    //     return StreamBuilder(
    //     stream: _getDataSource(),
    //     builder: (BuildContext context, AsyncSnapshot snapshot) {
    //       if(snapshot.data != null && snapshot.connectionState ==  ConnectionState.done){
    //         return SfCalendar(
    //           dataSource: MeetingDataSource(snapshot.data),
    //           monthViewSettings: const MonthViewSettings(
    //             appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
    //             showAgenda: true),
    //           view: CalendarView.month,
    //           onTap: (CalendarTapDetails details) {
    //       if (details.appointments != null && details.targetElement == CalendarElement.appointment) {
    //         final Meeting tappedAppointment = details.appointments![0] as Meeting;
    //         Navigator.push(context, MaterialPageRoute(builder: (context) => ViewEventDetails(appointment: tappedAppointment),));
    //       }
    //           },
    //         );
    //       }else if(snapshot.connectionState == ConnectionState.waiting){
    //         return const Center(child: CircularProgressIndicator());
    //       }else{
    //         return const Center(child: Text('No Data'));
    //       }
    //     },
    // );
  }
} 