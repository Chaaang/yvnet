import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yvnet/screens/admin/home_admin.dart';
import 'package:yvnet/screens/volunteer/home_volunteer.dart';

class HomeTile extends StatelessWidget {
  final AsyncSnapshot<DocumentSnapshot<Object?>> snapshot;
  const HomeTile({super.key, required this.snapshot});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
            const Text('Management', style: TextStyle(fontWeight: FontWeight.w900),),
            const SizedBox(height: 10,),
           snapshot.data!['isAdmin'] == true 
            ? const HomeAdmin()
            : const HomeVolunteer()
      ],
    );
  }
}