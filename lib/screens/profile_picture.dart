
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yvnet/components/mybuttons.dart';
import 'package:yvnet/helper_function/helper_function.dart';
class ProfilePicturePage extends StatefulWidget {
   final String? userEmail;
   const ProfilePicturePage({super.key, required this.userEmail});

  @override
  State<ProfilePicturePage> createState() => _ProfilePicturePageState();
}

class _ProfilePicturePageState extends State<ProfilePicturePage> {
  File? _image;
  String? downloadURL;
  

  final imagePicker = ImagePicker();

  //image picker

  Future imagePickerMethod() async{
    //pick the image
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if(pick != null){
        _image = File(pick.path);
      }else{
        showSnackBar('No file selected!', const Duration(milliseconds: 1000), context);
        // showSnackBar('No file selected!', const Duration(milliseconds: 1000));
        
      }
    });
  }

  Future uploadImageMethod()async{
     progressIndication(context);
    Reference firestorageref = FirebaseStorage.instance.ref().child('images').child('/${widget.userEmail}').child('profileImage.png');
    FirebaseFirestore firestoreRef = FirebaseFirestore.instance;

    //upload to firestorage
    await firestorageref.putFile(_image!);

    //get the url after uploading to firestorage
    downloadURL = await firestorageref.getDownloadURL();

    //upload to firestore
    
    await firestoreRef.collection('Users').doc(widget.userEmail).update({
      'image'      : downloadURL
    });
    Navigator.pop(context);
    showSnackBar('Profile Picture Uploaded!', const Duration(milliseconds: 1000), context);

  }

  // showSnackBar(String snackText, Duration d){
  //   final snackbar = SnackBar(content: Text(snackText), duration: d,);

  //   ScaffoldMessenger.of(context).showSnackBar(snackbar);
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios_new, color: Colors.amber[400]),
        ),
      ),
      body:  Column(
        children: [
          const SizedBox(height: 100,),
          _image != null
          ? GestureDetector(
            onTap: () {
              imagePickerMethod();
            },
            child: CircleAvatar(
              radius: 100,
              child: ClipOval(
                child: Image.file(
                  fit: BoxFit.fill,
                  width: 200,
                  height: 200,
                  _image!),
              ),),
          )
          : GestureDetector(
            onTap: () {
              imagePickerMethod();
            },
            child: CircleAvatar(
                          backgroundColor: Colors.grey[400],
                          radius: 100,
                          child: const ClipOval(
                           child: Text('Choose Image', style: TextStyle(color: Colors.black),),
                                    ),),
          ),
        Padding(
          padding: const EdgeInsets.all(100.0),
          child: MyButton(text: 'Save', onTap: (){
                if(_image == null){
                  // showSnackBar('Image not Found!', const Duration(milliseconds: 1000));
                     showSnackBar('Image not Found!', const Duration(milliseconds: 1000), context);
                }else{
                  uploadImageMethod();
                }
                
                },),
        )

        ],
      ),

    );
  }
}