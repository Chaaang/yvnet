import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yvnet/model/meeting.dart';

class ViewEventDetails extends StatefulWidget {
  final Meeting appointment;
  const ViewEventDetails({super.key, required this.appointment,});

  @override
  State<ViewEventDetails> createState() => _ViewEventDetailsState();
}

class _ViewEventDetailsState extends State<ViewEventDetails> {
  TextEditingController updateVenue = TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Event Details' ,style: TextStyle(
                      fontSize: 35, 
                      fontWeight: FontWeight.w900, 
                      color: Colors.amber)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Icon(Icons.arrow_back_ios_new, color: Colors.amber[400]),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20,),
              Text('Title:', style: TextStyle(color: Colors.amber[400], fontWeight: FontWeight.bold,),),
              Text(widget.appointment.eventName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
          
              const SizedBox(height: 20,),
          
              Text('Agenda:', style: TextStyle(color: Colors.amber[400], fontWeight: FontWeight.bold,),),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Text(
                          widget.appointment.description, 
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),)))),
                ],
              ),
          
              //const SizedBox(height: 20,),
              Text('Venue:', style: TextStyle(color: Colors.amber[400], fontWeight: FontWeight.bold,),),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: InkWell(
                          onTap: () {
                            goToLink(widget.appointment.venue);
                          },
                          onDoubleTap: () {
                            openDialog(context);
                          },
                          child: Text(
                            widget.appointment.venue,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                        )))),
                ],
              ),
          
              const SizedBox(height: 20,),
              
              Text('Start Time:', style: TextStyle(color: Colors.amber[400], fontWeight: FontWeight.bold,),),
              Text('${widget.appointment.from.hour.toString().padLeft(2,'0')}:${widget.appointment.from.minute.toString().padLeft(2,'0')}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          
              const SizedBox(height: 20,),
          
              Text('End Time:', style: TextStyle(color: Colors.amber[400], fontWeight: FontWeight.bold,),),
              Text('${widget.appointment.to.hour.toString().padLeft(2,'0')}:${widget.appointment.to.minute.toString().padLeft(2,'0')}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          
              const SizedBox(height: 20,),
              
              Text('Type', style: TextStyle(color: Colors.amber[400], fontWeight: FontWeight.bold,),),
              widget.appointment.background == Colors.red
              ? const Text('Training', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
              : const Text('Meeting', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20,),
          
              Text('CC:', style: TextStyle(color: Colors.amber[400], fontWeight: FontWeight.bold,),),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 27,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Text(
                          widget.appointment.cc, 
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),)))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

    Future<void> goToLink(String link)async{
    final Uri _url = Uri.parse(link);
    if(!await launchUrl(_url)){
       //throw Exception('Could not launch $_url');
       await launchUrl(_url); 
    }else{
            print('Could not launch $_url');
    }
  }

    Future openDialog(BuildContext context) => showDialog(
    context: context, 
    builder: (context) {
      return  AlertDialog(
        title: const Center(child: Text('Update Venue')),
        content:  Container(
          height: 75,
          child: Column(
            children: [
              TextField(
                controller: updateVenue,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: ()async{
              // venue = updateVenue.text;
              // setState(() {
                
              // });
              // updateLinkOrVenue(venue);
              // Navigator.pop(context); 
              
            }, child: const Text('Update')),
        ],
      );


    },);

      void updateLinkOrVenue(String venue){
     FirebaseFirestore.instance.collection('meetings').doc(widget.appointment.id).update({
      'linkOrVenue' : venue
    });
  }
}