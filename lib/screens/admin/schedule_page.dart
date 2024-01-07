import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yvnet/components/mybuttons.dart';
import 'package:yvnet/helper_function/helper_function.dart';


class SchedulePage extends StatefulWidget {
const SchedulePage({super.key});
  @override
  State<SchedulePage> createState() => _SchedulePageState();
}
class _SchedulePageState extends State<SchedulePage> {
final TextEditingController titleController = TextEditingController();
final TextEditingController typeController = TextEditingController();
final TextEditingController linkorVenueController = TextEditingController();
final TextEditingController dateController = TextEditingController();
final TextEditingController startTimeController = TextEditingController();
final TextEditingController endTimeController = TextEditingController();
final TextEditingController descriptionController = TextEditingController();
final TextEditingController ccController = TextEditingController();

FirebaseFirestore firestoreRef = FirebaseFirestore.instance;

final _formKey = GlobalKey<FormState>();
TimeOfDay _startOfTime = TimeOfDay.now();
TimeOfDay _endOfTime = TimeOfDay.now();
String valueChoose = 'Meeting';
List<String> listItem = ['Meeting', 'Training'];


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(child: 
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
        
              const Text('Title'),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                        controller: titleController,
                        decoration: InputDecoration(
                        border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                                hintText: 'Meeting title',
                                hintStyle: const TextStyle( fontSize: 12), 
                                  ),
                                obscureText: false,
                                validator: (value) {
                                  if(value!.isEmpty){
                                    return 'Required!';
                                  }
                                    return null;
                                  },
                    ),
              const SizedBox(height: 15,),
        
              const Text('Link or Venue'),
              TextFormField(
                  controller: linkorVenueController,
                  decoration: InputDecoration(
                  border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                          hintText: 'Link or Venue',
                          hintStyle: const TextStyle( fontSize: 12), 
                            ),
                          obscureText: false,
                          validator: (value) {
                            if(value!.isEmpty){
                              return 'Required!';
                            }
                              return null;
                            },
              ),
                  ],
                ),
              ),
        const SizedBox(height: 15,),
        Center(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black)
            ),
            width: 350,
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                value: valueChoose,
                items: listItem.map((item) => DropdownMenuItem(
                  value: item,
                  child: Center(child: Text(item))
                  )).toList(), 
                onChanged: (value) {
                  setState(() {
                    valueChoose = value!;
                    if(valueChoose == 'Training'){
                      typeController.text = 'red';
                    }else{
                       typeController.text = 'yellow';
                    }
                    print(typeController.text);
                    
                  });
                },
                ),
            ),
          ),
        ),
              const SizedBox(height: 15,),
              const Text('Date'),
              InkWell(
                onTap:()async {
                      DateTime? pickedDate = await showDatePicker(
                                context: context, 
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000), 
                                lastDate: DateTime(2100));
                
                              if(pickedDate != null){
                                    setState(() {
                                      dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                                    });
                              }                
                },
                child: Container(
                  height: 65,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.date_range_outlined),
                        const SizedBox(width: 20,),
                        Text(dateController.text)
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15,),
              const Row(
                children: [
                  Text('Start Time'),
                  SizedBox(width: 115,),
                  Text('End Time'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap:()async {
                          TimeOfDay ? picked = await showTimePicker(
                            context: context, 
                            initialTime: _startOfTime);
                            
                          if(picked != null){
                            setState(() {
                              _startOfTime = picked;
                              startTimeController.text = '${_startOfTime.hour.toString().padLeft(2,'0')}:${_startOfTime.minute.toString().padLeft(2,'0')}';
                            });
                          }                  
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Icon(Icons.schedule),
                              const SizedBox(width: 20,),
                              startTimeController.text.isNotEmpty 
                              ? Text('${_startOfTime.hour.toString().padLeft(2,'0')}:${_startOfTime.minute.toString().padLeft(2,'0')}')
                              : Container()
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              const SizedBox(width: 15,),
              Expanded(
                child: InkWell(
                  onTap:()async {
                      TimeOfDay ? picked = await showTimePicker(
                        context: context, 
                        initialTime: _endOfTime);
                        
                      if(picked != null){
                        setState(() {
                          _endOfTime = picked;
                          endTimeController.text ='${_endOfTime.hour.toString().padLeft(2,'0')}:${_endOfTime.minute.toString().padLeft(2,'0')}';
                        });
                      }                  
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Icon(Icons.schedule),
                          const SizedBox(width: 20,),
                          endTimeController.text.isNotEmpty 
                          ? Text('${_endOfTime.hour.toString().padLeft(2,'0')}:${_endOfTime.minute.toString().padLeft(2,'0')}')
                          : Container()
                        ],
                      ),
                    ),
                  ),
                ),
              ),
                ],
              ),
              

              const SizedBox(height: 15,),

              const Text('Agenda'),
              TextField(
                  minLines: 1,
                  maxLines: 10,
                  controller: descriptionController,
                  decoration: InputDecoration(
                  border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                          hintStyle: const TextStyle( fontSize: 12), 
                            ),
              ), 
              const Text('CC:'),
              TextField(
                  minLines: 1,
                  maxLines: 10,
                  controller: ccController,
                  decoration: InputDecoration(
                  border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                          hintStyle: const TextStyle( fontSize: 12), 
                            ),
              ),        
              const SizedBox(height: 50,),
              MyButton(text: 'Save', onTap: () {
                if(_formKey.currentState!.validate()){
                  if(dateController.text.isEmpty || startTimeController.text.isEmpty || endTimeController.text.isEmpty){
                    return showSnackBar('Fill out everything!', const Duration(milliseconds: 1000), context);
                  }else{
                    uploadMeeting();
                  }
                }
              },),
              
            ],
          ),
        ),
      )),
    );
  }
Future<void> uploadMeeting()async{
progressIndication(context); 

  try{
    firestoreRef.collection('meetings').add({
      'subject' : titleController.text,
      'startTime' : '${dateController.text} ${startTimeController.text}',
      'endTime' : '${dateController.text} ${endTimeController.text}',
      'linkOrVenue' : linkorVenueController.text,
      'description' : descriptionController.text,
      'type'        : typeController.text,
      'cc'          : ccController.text
       }).whenComplete(() {
          Navigator.pop(context);
          showSnackBar('Upload Sucess!', const Duration(milliseconds: 1000), context);
            });
  }catch (err){
      print('${err}');
  }
  
}


    Future<void> goToLink(String link)async{
    final Uri _url = Uri.parse(link);
    if(!await launchUrl(_url)){
      throw Exception('Could not launch $_url');
    }
  }
} 

