import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yvnet/components/mydrawer.dart';
import 'package:yvnet/helper_function/notification_service.dart';
import 'package:yvnet/screens/home_tile.dart';
import 'package:yvnet/screens/profile_picture.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();
    // notificationServices.requestPermission();
    // notificationServices.getDeviceToken();
      notificationServices.initNotifications();
  }

  //current logged in user
  final User? currentUser = FirebaseAuth.instance.currentUser;

  
  //Future to fetch user details
final Stream<DocumentSnapshot> _usersStream = FirebaseFirestore.instance
  .collection("Users")
  .doc(FirebaseAuth.instance.currentUser!.email)
  .snapshots();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      drawer: const MyDrawer(),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: StreamBuilder(
        stream: _usersStream, 
        builder: (context, snapshot) {
          if(snapshot.hasError){
            return Text('Error ${snapshot.error}');
          }else if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }else if(snapshot.hasData){
            return  SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Hello,',style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900)),
                      snapshot.data!['isAdmin'] == true
                      ? const Text('Admin!',style: TextStyle(fontSize: 35, fontWeight: FontWeight.w900),)
                      : Text(snapshot.data!['firstName'],style: TextStyle(fontSize: 35, fontWeight: FontWeight.w900),),
                      const Text('Have a nice day!', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w300)),
                    ],
                  ),
                  const SizedBox(width: 70,),
                   Column(
                    children: [ 
                      snapshot.data!['image'] != ''
                      ?GestureDetector(
                        onTap: () =>  Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePicturePage(userEmail: currentUser!.email),)),
                        child: CircleAvatar(
                          radius: 50,
                          child: ClipOval(
                           child: Image.network(
                             snapshot.data!['image'],
                             width: 100,
                             height: 100,
                            fit: BoxFit.fill,),
                                    ),),
                      )
                      : GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePicturePage(userEmail: currentUser!.email),)),
                        child:  CircleAvatar(
                          backgroundColor: Colors.grey[400],
                          radius: 50,
                          child: const ClipOval(
                           child: Icon(Icons.camera_alt),
                                    ),),
                      )
              
              
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20,),
                        snapshot.data!['isAccepted'] == true
                        ? HomeTile(snapshot:snapshot)
                        : const Column(
              children: [
                SizedBox(height: 200,),
                Center(child: Text('Your account is being reviewed. Please wait!')),
              ],
                        )
                        ]
                        ),
                      ),
                    ),
            );
          }else{
            return const Text('no data');
          }
        },)
      
      
      

    );
  }
}
