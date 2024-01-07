import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yvnet/components/mybuttons.dart';

class MyDrawer extends StatefulWidget {

  const MyDrawer({super.key,});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  void logOut(){
    FirebaseAuth.instance.signOut();
  }

  //current logged in user
  final User? currentUser = FirebaseAuth.instance.currentUser;


  //Future to fetch user details
final Stream<DocumentSnapshot> _usersStream = FirebaseFirestore.instance
  .collection("Users")
  .doc(FirebaseAuth.instance.currentUser!.email)
  .snapshots();

  //Future to fetch user details
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails()async{
    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser!.email)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return  Drawer(
      child: StreamBuilder(
        stream:_usersStream,
        builder: (context, snapshot) {
          if(snapshot.hasError){
            return Center(child: Text('Error ${snapshot.error}'));
          }else if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }else if(snapshot.hasData){
            return Column(
             children: [
               DrawerHeader(child: 
                snapshot.data!['image'] != ''
                    ?
                       CircleAvatar(
                        radius: 50,
                        child: ClipOval(
                         child: Image.network(
                           snapshot.data!['image'],
                           width: 100,
                           height: 100,
                          fit: BoxFit.fill,),
                                  ),)
                     : CircleAvatar(
                        backgroundColor: Colors.grey[400],
                        radius: 50,
                        child: const ClipOval(
                         child: Icon(Icons.camera_alt),
                                  ),),
                    
            ),
                  Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 35,),
          //last name
           Text(snapshot.data!['firstName'], 
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 42),),
          //first name
           Text(snapshot.data!['lastName'],
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 36),),
          const SizedBox(height: 24,),
          //email
           Row(
            children: [
              const Icon(Icons.email_outlined),
              const SizedBox(width: 10,),
              Text(snapshot.data!['email'],
                style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w300
              ),
              ),
            ],
          ),
          const SizedBox(height: 24,),
          //role
           Row(
            children: [
              const Icon(Icons.volunteer_activism, size: 24,),
              const SizedBox(width: 10,),
              snapshot.data!['isAdmin'] == true
              ? Text('Admin', style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w900,
                color: Colors.amber[400]
              ),)
              : Text('Volunteer', style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w900,
                color: Colors.amber[400]
              ),)
            ],
          ),
          const SizedBox(height: 150,),
          MyButton(text: 'Logout', 
          onTap: () {
                  logOut();    
                    },
          color: Colors.red[500],
          ),
          ],),
        ),
        ],
      );            
          }else{
            return const Center(child: Text('No Data'));
          }
        },)
      

    );
  }
}