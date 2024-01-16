import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

class VolunteerProfile extends StatefulWidget {
  final String image;
  final String firstName;
  final String lastName;
  final String gender;
  final String dob;
  final String email;
  final String address;
  final String phoneNumber;
  final String contactName;
  final String contactNumber;
  final String contactRelationship;
  bool isEnable;

  VolunteerProfile({super.key, 
  required this.image, 
  required this.firstName, 
  required this.lastName, 
  required this.gender, 
  required this.dob, 
  required this.isEnable, 
  required this.email, 
  required this.address,
  required this.phoneNumber, 
  required this.contactName,
  required this.contactNumber, 
  required this.contactRelationship});

  @override
  State<VolunteerProfile> createState() => _VolunteerProfileState();
}

class _VolunteerProfileState extends State<VolunteerProfile> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Volunteer Profile',style: TextStyle(
                      fontSize: 35, 
                      fontWeight: FontWeight.w900, 
                      color: Colors.amber[400]),),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios_new, color: Colors.amber[400]),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              widget.image != '' 
              ?CircleAvatar(
                radius: 50,
                child: ClipOval(
                child: Image.network(
                    widget.image,
                    width: 100,
                    height: 100,
                    fit: BoxFit.fill,),
                ),)

              : CircleAvatar(
                  backgroundColor: Colors.grey[400],
                  radius: 50,
                  child: const ClipOval(
                                child: Icon(Icons.camera_alt),
                        ),
                ),
              Text('Name:', style: TextStyle(color: Colors.amber[400], fontWeight: FontWeight.bold,),),
              Text('${widget.firstName} ${widget.lastName}',style: const TextStyle(fontSize: 20),),
              
              Text('Email:', style: TextStyle(color: Colors.amber[400], fontWeight: FontWeight.bold, ),),
              Text(widget.email,style: const TextStyle(fontSize: 20)),   
          
              Text('Address:', style: TextStyle(color: Colors.amber[400], fontWeight: FontWeight.bold, ),),  
              Text(widget.address,style: const TextStyle(fontSize: 20)),
          
              Text('Phone Number:', style: TextStyle(color: Colors.amber[400], fontWeight: FontWeight.bold, ),),
              Text(widget.phoneNumber,style: const TextStyle(fontSize: 20)),     
          
              Text('Birthdate', style: TextStyle(color: Colors.amber[400], fontWeight: FontWeight.bold),),
              Text(widget.dob,style: const TextStyle(fontSize: 20)),
          
              Text('Gender', style: TextStyle(color: Colors.amber[400], fontWeight: FontWeight.bold),),
              Text(widget.gender,style: const TextStyle(fontSize: 20)),

              Divider(),

              Center(child: Text('Emergency Contact', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
              Text('Name', style: TextStyle(color: Colors.amber[400], fontWeight: FontWeight.bold),),
              Text(widget.contactName,style: const TextStyle(fontSize: 20)),
              Text('Relationship', style: TextStyle(color: Colors.amber[400], fontWeight: FontWeight.bold),),
              Text(widget.contactRelationship,style: const TextStyle(fontSize: 20)),
              Text('Contact Number', style: TextStyle(color: Colors.amber[400], fontWeight: FontWeight.bold),),
              GestureDetector(
                onTap: () async{
                  Uri dialnumber = Uri(scheme: 'tel', path: '${widget.contactNumber}');
                  await launchUrl(dialnumber);
                },
                child: Text(widget.contactNumber,style: const TextStyle(fontSize: 20))),
              
              
              Text('Action', style: TextStyle(color: Colors.amber[400], fontWeight: FontWeight.bold),),
              
              Row(
                children: [
                  Switch.adaptive(
                    splashRadius: 100,
                    value: widget.isEnable, 
                    activeColor: Colors.green,
                    onChanged: (newValue) {
                      setState(() {
                         widget.isEnable = newValue;
                         updateUser(widget.isEnable);
                         if(widget.isEnable == true){
                          sendEmail();
                         }
                      });
                  },),
                  widget.isEnable == true 
                  ? const Text('Account Enable', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),)
                  : const Text('Account Disable', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                ],
              ),
            ],
            ),
        ),
      ),
    );
  }

  void updateUser(bool isEnable){
     FirebaseFirestore.instance.collection('Users').doc(widget.email).update({
      'isAccepted' : isEnable
    });
  }

  Future sendEmail()async{
    final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
    const serviceId = 'service_abqwhq9';
    const templateId = 'template_ijaib3p';
    const userId = 'n37ijVizj_Wk_uyag';
    final response = await http.post(url,
    headers: {
      'origin'       : 'http://localhost',
      'Content-Type' : 'application/json'},
      body: json.encode({
        'service_id': serviceId,
        'template_id' : templateId,
        'user_id' : userId,
        'template_params' : {
          'recipient_name' : widget.firstName,
          'user_sendto' : widget.email,
          'subject': 'Account Verified',
          'message' : 'I hope this message finds you well. We are pleased to inform you that your email address ${widget.email} has been successfully verified.',
          'user_email' :'jeremiahjemay@gmail.com',
        }
      })
    );
    print(response.body);
    return response.statusCode;
  }
}


//I hope this message finds you well. We are pleased to inform you that your email address ([YourEmailAddress]) has been successfully verified.
