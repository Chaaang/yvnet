import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yvnet/screens/admin/volunteerProfile_page.dart';

class VolunteersPage extends StatefulWidget {
  const VolunteersPage({super.key});

  @override
  State<VolunteersPage> createState() => _VolunteersPageState();
}

class _VolunteersPageState extends State<VolunteersPage> {
  TextEditingController personSearch = TextEditingController();
  String? value;

    //Future to fetch user details
  CollectionReference usersStream = FirebaseFirestore.instance.collection("Users");
  final statusValue = [
    'All',
    'Pending',
    'Approved',
  ];

  String? searchName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Row(
          children: [Icon(Icons.group_outlined, color: Colors.amber[400], size: 35,),
                    const SizedBox(width: 10,),
                    Text('Volunteers',
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
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
     TextField(
      controller: personSearch,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        hintText: 'Search',
        hintStyle: const TextStyle( fontSize: 12),
        prefixIcon:  const Icon(Icons.search_sharp,),
      ),
      onChanged: (value) {
        setState(() {
          searchName = value;
        });
      },

      obscureText: false,
    ),           
            const SizedBox(height: 20,),
            const Text('Status', textAlign: TextAlign.right,),
            Container(
              decoration: BoxDecoration(
                color: Colors.amber[400],
                borderRadius: BorderRadiusDirectional.circular(20)
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    isExpanded: true, 
                    value: value,
                    items: statusValue.map(buildMenuItem).toList(), 
                    onChanged: (value) => setState (() {
                      this.value = value;
                    },), 
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10,),
            StreamBuilder(
              stream:
              searchName != null && personSearch.text.isNotEmpty
              ?  FirebaseFirestore.instance
                  .collection('Users')
                  .orderBy('firstName')
                  .startAt([searchName])
                  .endAt(["$searchName  \uf8ff"])
                  .snapshots()
              : usersStream.snapshots(),
              builder: (context, snapshot) {
                if(snapshot.hasError){
                  return Center(child: Text('Error ${snapshot.error}')); 
                }else if(snapshot.connectionState == ConnectionState.waiting){
                  return const Center(child: CircularProgressIndicator());
                }else if(snapshot.hasData){
                  
              if(value == 'Pending'){
                    var docs = snapshot.data?.docs.where((e) => e['isAccepted'] == false).toList();
                  return Expanded(
                    child: ListView.builder(
                      itemCount: docs?.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          height: 120,
                          child: InkWell(
                            onTap: (){
                              //navigate to specific user profile  var docs = snapshot.data!.docs.where((e) => e['isAccept'] == true).toList();
                              Navigator.push(context, MaterialPageRoute(builder: (context) =>  VolunteerProfile(
                                image: docs?[index]['image'],
                                firstName: docs?[index]['firstName'],
                                lastName: docs?[index]['lastName'],
                                dob: docs?[index]['dob'],
                                gender: docs?[index]['gender'],
                                isEnable: docs?[index]['isAccepted'],
                                email: docs?[index]['email'],
                                address: docs?[index]['address'],
                                phoneNumber: docs?[index]['phoneNumber'],
                                contactName: docs?[index]['contactName'],
                                contactNumber: docs?[index]['contactNumber'],
                                contactRelationship: docs?[index]['contactRelationship'],

                              )));
                            },
                            child: 
                            Card(
                              color: Colors.amber[400],
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                  Text(docs?[index]['firstName'] +' '+ docs?[index]['lastName'], 
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                  Text('@${docs?[index]['email']}'),
                                
                                  Row(
                                    children: [
                                      const SizedBox(width: 200,),
                                      docs?[index]['isAccepted'] == true
                                      ?Container(
                                        width: 100,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(20)
                                        ),
                                        child: const Center(child: Text('Approved')))
                                      :Container(
                                        width: 100,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(20)
                                        ),
                                        child: const Center(child: Text('Pending'))
                                      )
                                    ],
                                  )
                                ]),
                              )
                            ),
                          ),
                        );
                      },
                      ),
                  );
                  }else if(value == 'Approved'){

                  var docs = snapshot.data?.docs.where((e) => e['isAccepted'] == true).toList();

                  return Expanded(
                    child: ListView.builder(
                      itemCount: docs?.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          height: 120,
                          child: InkWell(
                            onTap: (){
                              //navigate to specific user profile  var docs = snapshot.data!.docs.where((e) => e['isAccept'] == true).toList();
                               Navigator.push(context, MaterialPageRoute(builder: (context) =>  VolunteerProfile(
                                image: docs?[index]['image'],
                                firstName: docs?[index]['firstName'],
                                lastName: docs?[index]['lastName'],
                                dob: docs?[index]['dob'],
                                gender: docs?[index]['gender'],
                                isEnable: docs?[index]['isAccepted'],
                                email: docs?[index]['email'],
                                address: docs?[index]['address'],
                                phoneNumber: docs?[index]['phoneNumber'],
                                contactName: docs?[index]['contactName'],
                                contactNumber: docs?[index]['contactNumber'],
                                contactRelationship: docs?[index]['contactRelationship'],                                
                               )));
                            },
                            child: 
                            Card(
                              color: Colors.amber[400],
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                  Text(docs?[index]['firstName'] +' '+ docs?[index]['lastName'], 
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                  Text('@${docs?[index]['email']}'),
                                
                                  Row(
                                    children: [
                                      const SizedBox(width: 200,),
                                      docs?[index]['isAccepted'] == true
                                      ?Container(
                                        width: 100,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(20)
                                        ),
                                        child: const Center(child: Text('Approved')))
                                      :Container(
                                        width: 100,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(20)
                                        ),
                                        child: const Center(child: Text('Pending'))
                                      )
                                    ],
                                  )
                                ]),
                              )
                            ),
                          ),
                        );
                      },
                      ),
                  );
                  }else{
                  var docs = snapshot.data?.docs;

                  return Expanded(
                    child: ListView.builder(
                      itemCount: docs?.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          height: 120,
                          child: InkWell(
                            onTap: (){
                              //navigate to specific user profile  var docs = snapshot.data!.docs.where((e) => e['isAccept'] == true).toList();
                               Navigator.push(context, MaterialPageRoute(builder: (context) =>  VolunteerProfile(
                                image: docs?[index]['image'],
                                firstName: docs?[index]['firstName'],
                                lastName: docs?[index]['lastName'],
                                dob: docs?[index]['dob'],
                                gender: docs?[index]['gender'],
                                isEnable: docs?[index]['isAccepted'],
                                email: docs?[index]['email'],
                                address: docs?[index]['address'],
                                phoneNumber: docs?[index]['phoneNumber'],
                                contactName: docs?[index]['contactName'],
                                contactNumber: docs?[index]['contactNumber'],
                                contactRelationship: docs?[index]['contactRelationship'],                                
                               )));
                            },
                            child: 
                            Card(
                              color: Colors.amber[400],
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                  Text(docs?[index]['firstName'] +' '+ docs?[index]['lastName'], 
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                  Text('@${docs?[index]['email']}'),
                                
                                  Row(
                                    children: [
                                      const SizedBox(width: 200,),
                                      docs?[index]['isAccepted'] == true
                                      ?Container(
                                        width: 100,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(20)
                                        ),
                                        child: const Center(child: Text('Approved')))
                                      :Container(
                                        width: 100,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(20)
                                        ),
                                        child: const Center(child: Text('Pending'))
                                      )
                                    ],
                                  )
                                ]),
                              )
                            ),
                          ),
                        );
                      },
                      ),
                  );
                  }


                }else{
                   return const Center(child: Text('Empty'));
                }
              },)
          ],
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
    value: item,
    child: Text(
      item,
      style: const  TextStyle( fontSize: 14),
    )
  );
}