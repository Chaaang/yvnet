import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yvnet/components/mybuttons.dart';
import 'package:yvnet/helper_function/helper_function.dart';
import 'package:http/http.dart' as http;

class ModulePage extends StatefulWidget {
  final bool? isAdmin;
  const ModulePage({super.key, required this.isAdmin});

  @override
  State<ModulePage> createState() => _ModulePageState();
}

class _ModulePageState extends State<ModulePage> {
  //Future to fetch user details
  CollectionReference modulesStream = FirebaseFirestore.instance.collection("modules");
  TextEditingController moduleLink = TextEditingController();
  TextEditingController titleController = TextEditingController();
  String? fileName;
  File? file;
  bool isUrlValid = false;
  FirebaseFirestore firestoreRef = FirebaseFirestore.instance;
 


  void pickFile()async{

    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if(pickedFile != null){

       fileName = pickedFile.files[0].name;

       file = File(pickedFile.files[0].path!);

      setState(() {
        moduleLink.text = file.toString();
      });

    }else{
      showSnackBar('Image not Found!', const Duration(milliseconds: 1000), context);
    }
  }

  Future openDialog() => showDialog(
    context: context, 
    builder: (context) {
      return  AlertDialog(
        title: const Center(child: Text('Module')),
        content:  Container(
          height: 150,
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.title),
                  hintText: 'Title' 
                ),
              ),
              TextField(
                controller: moduleLink,
                decoration: InputDecoration(
                  prefixIcon: InkWell(
                    onTap:pickFile,
                    child: const Icon(Icons.file_copy)),
                  hintText: 'PDF or Link' 
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: ()async{
              Navigator.pop(context); 
              setState(() {
                
              });
              
            }, child: const Text('Ok')),
        ],
      );


    },);

  
  Future uploadPdfMethod()async{
    progressIndication(context);  
  
    isUrlValid =  await checkLinkValidity(moduleLink.text.trim());
    print('test $isUrlValid');
    if(isUrlValid){
      moduleLink.text.startsWith('https://www.');
      try{
        firestoreRef.collection('modules').add({
          "title": titleController.text,
          "name" : 'website',
          "url"  : moduleLink.text
        }).whenComplete(() {
        Navigator.pop(context);
        showSnackBar('Upload Sucess!', const Duration(milliseconds: 1000), context);
            setState(() {
      moduleLink.clear();
    });

      } );

      }catch (err){
        print('${err}');
      }
    }else if((fileName != null && file != null)){
    final storageRef = FirebaseStorage.instance.ref().child('modules').child('/pdfs$fileName');
    
    final uploadTask = storageRef.putFile(file!);

    await uploadTask.whenComplete(() {});

    final downloadLink = await storageRef.getDownloadURL();


    //Upload to firestore the pdf file
     
      firestoreRef.collection('modules').add({
        "title": titleController.text,
        "name" : fileName,
        "url"  : downloadLink
      }).whenComplete(() {
        Navigator.pop(context);
        showSnackBar('Upload Sucess!', const Duration(milliseconds: 1000), context);
            setState(() {
      moduleLink.clear();
    });
      } );
  }else{
    Navigator.pop(context);
    showSnackBar('Invalid Link!', const Duration(milliseconds: 1000), context);
    moduleLink.clear();
    titleController.clear();
    setState(() {
      
    });
  }
  }

  void deleteModule(id){
    FirebaseFirestore.instance.collection('modules').doc(id).delete();
  }


  Future<void> downloadModule(String url)async{
    progressIndication(context);
    FileDownloader.downloadFile(
      url: url,
      onDownloadError: (String errorMessage) {
        //print("Download error: $errorMessage");
      },
      onDownloadCompleted: (path) {
        Navigator.pop(context);
        //path directory
        //final File filepath = File(path);
        showSnackBar('Download Sucess!', const Duration(milliseconds: 1000), context);
      },
      );
  }

  Future<void> goToLink(String link)async{
    final Uri _url = Uri.parse(link);
    if(!await launchUrl(_url)){
      throw Exception('Could not launch $_url');
    }
  }

    Future<bool> checkLinkValidity(String url) async {
      
        // bool validUrl = Uri.parse(url).isAbsolute;

        // return validUrl;

    bool isValid = url.startsWith('https://');

    if(isValid){

      try {
      final response = await http.head(Uri.parse(url));
      return response.statusCode == 200;
      // bool validUrl = Uri.parse(url).isAbsolute;
        // return validUrl;
      } catch (e) {
      // An error occurred (e.g., network error)
      print('Error: $e');
      return false;
      }
    }else{

      try {
      final response = await http.head(Uri.parse('https://$url'));
      moduleLink.text = 'https://$url';
      return response.statusCode == 200;
        // bool validUrl = Uri.parse('https://$url').isAbsolute;
        // return validUrl;
      } catch (e) {
      // An error occurred (e.g., network error)
      print('Error: $e');
      return false;
      }
    }
 
  }

  void sendPushMessage()async{
    String token = 'cYBgLDaFToyZXsgz0MxkT7:APA91bG2wySmkd9Xn4gCv8Kahia8Czz1T7D52ej-AVBH_goETu9TOqmUB7jCCKFkBhk8OeW--UYlbBm8jB8nFpgkDiwMNuRVnteVM9clAgwUKoeVHP4Z7eTj4TnDFjnqHEOmc8DkOXHb';
    try{
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type' : 'application/json',
          'Authorization' : 'key=AAAArhIG-0Q:APA91bEVr9bnm2rqGheqVsqmrX2WZ0HWQF75KFC0GMZrW56xOAemkCMQEUQDCF6nEVnvdTvw0p_5HpBBMpDTn1LXs24b3UwZe7C8tpp7vu5RgGiwN_UHfv1G6lYbi5qVNBIXonQ8Qr_g'
        },
        body: jsonEncode(
          <String, dynamic>{
            'priority' : 'high',
            'data' : <String, dynamic>{
              'click_action' : 'FLUTTER_NOTIFICATION_CLICK',
              'status' : 'done',
              'body' : 'Test body notif',
              'title' : 'Test title notif'
            },

            'notification' : <String, dynamic>{
              'title' : 'Test body notification',
              'body' : 'Test body notification',
              'android_channel_id' : 'dbfood,'
            },
            "to": token,
          }
        )
      );
    }catch (e){
      print('error $e');
    }
  }
  @override
  void dispose() {
    moduleLink.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Row(
          children: [Icon(Icons.menu_book, color: Colors.amber[400], size: 35,),
                    const SizedBox(width: 10,),
                    Text('Modules',
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
      body: Column(children: [
        widget.isAdmin == true
        ? Center(
          child: GestureDetector(
            onTap: () => openDialog(),//pickFile(),
            child: Container(
              width: 350,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.amber[200],
                borderRadius: BorderRadius.circular(20)
              ),
              child: 
              moduleLink.text.isEmpty
              ? const Center(child: Text(
                  'Tap to Choose File', 
                  style: TextStyle(
                  fontSize: 16),))
              :  Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(child: Text(
                    moduleLink.text, 
                    style: const TextStyle(
                    fontSize: 16),)),
              )
            ),
          ),
        )
        : Container(),
        widget.isAdmin == true ?
        Padding(
          padding: const EdgeInsets.only(left: 50, right: 50,top: 35),
          child: MyButton(
            text: 'Upload',
            onTap: (){
              if((fileName != null && file != null) || moduleLink.text.isNotEmpty){
                uploadPdfMethod();
              }else{
                showSnackBar('Invalid Link', const Duration(milliseconds: 1000), context);
              }
              //sendPushMessage();
            },
            ),
        )
        :Container(),
        const SizedBox(height: 10,),
        StreamBuilder(
          stream: modulesStream.snapshots(), 
          builder: (context, snapshot) {
            if(snapshot.hasError){
              return Center(child: Text('Error ${snapshot.error}'));
            }else if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }else if(snapshot.hasData){
            var docs = snapshot.data!.docs;
            return Expanded(
              child: ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  return Slidable(
                    enabled: widget.isAdmin ?? true,
                    endActionPane: ActionPane(
                      motion: const StretchMotion(), 
                      children: [
                        widget.isAdmin == true ?
                        SlidableAction(
                          backgroundColor: Colors.red,
                          icon: Icons.delete,
                          onPressed: (context){
                            deleteModule(docs[index].id);
                          })
                          : Container(),                          
                      ]),
                    child: 
                     docs[index]['name'] == 'website'
                     ? ListTile(
                       leading: const Icon(Icons.link_sharp),
                       title: Text(docs[index]['title'], style: const TextStyle(fontSize: 15),),
                       trailing: InkWell(
                        onTap: () => goToLink(docs[index]['url']),
                        child: const Icon(Icons.open_in_new_sharp, color: Colors.red,)))

                      :ListTile(
                       leading: const Icon(Icons.link_sharp),
                       title: Text(docs[index]['title'], style: const TextStyle(fontSize: 15),),
                       trailing: InkWell(
                        onTap: () => downloadModule(docs[index]['url'].toString()),
                        child: const Icon(Icons.download, color: Colors.green,)))
                  );
              },),
            );
          }else{
            return const Center(child: Text('Empty'));
          }
          },)
      ]),
    );
  }
}