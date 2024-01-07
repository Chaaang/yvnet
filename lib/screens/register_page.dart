//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yvnet/components/mybuttons.dart';
import 'package:intl/intl.dart';
import 'package:yvnet/helper_function/helper_function.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //text controller
  final TextEditingController firstNameController               = TextEditingController();
  final TextEditingController lastNameController                = TextEditingController();
  final TextEditingController genderController                  = TextEditingController();
  final TextEditingController dobController                     = TextEditingController();
  final TextEditingController emailController                   = TextEditingController();
  final TextEditingController passwordController                = TextEditingController();
  final TextEditingController confirmpasswordController         = TextEditingController();
  final TextEditingController phoneNumberController             = TextEditingController();
  final TextEditingController addressController                 = TextEditingController();
  final TextEditingController contactNameController             = TextEditingController();
  final TextEditingController contactRelationshipController     = TextEditingController();
  final TextEditingController contactNumberController           = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final listItem = ['Male','Female'];
  String valueChoose = 'Male';
  //String value = 'Male';
  


  //register method
  Future<void> registerUser() async {
    //show loading circle
    progressIndication(context);
    //make sure password match
    if(passwordController.text != confirmpasswordController.text){
      //pop loading  circle
      Navigator.pop(context);
      //display error
      displayErrorMessage('Password don\'t match!',context);

    }else{
      //try creating user
      try{
        // ignore: unused_local_variable
        UserCredential? userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text, 
          password: passwordController.text);

        //create user document and store to firestore
        createUserDocument(userCredential);

        //pop loading  circle
        if(!mounted) return;
        Navigator.pop(context);
       
      }on FirebaseAuthException catch (e){
        //pop loading  circle
        if(!mounted) return;
        Navigator.pop(context);

        //display error message
        displayErrorMessage(e.code, context);
      }
    }
  }

  Future<void> createUserDocument(UserCredential? userCredential)async{
    if(userCredential != null && userCredential.user != null){
      await FirebaseFirestore.instance.collection('Users')
            .doc(userCredential.user!.email)
            .set({
              'firstName'  : firstNameController.text,
              'lastName'   : lastNameController.text,
              'gender'     : genderController.text,
              'dob'        : dobController.text,
              'email'      : emailController.text,
              'isAdmin'    : false,
              'isAccepted' : false,
              'image'      : '',
              'phoneNumber': phoneNumberController.text,
              'address'    : addressController.text,
              'contactName': contactNameController.text,
              'contactRelationship': contactRelationshipController.text,
              'contactNumber': contactNumberController.text
            });
  }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // firstNameController.dispose();
    // lastNameController.dispose();
    // emailController.dispose();
    // passwordController.dispose();
    // confirmpasswordController.dispose();
    // dobController.dispose();
    // genderController.dispose();
    // phoneNumberController.dispose();
    // addressController.dispose();
    // contactNameController.dispose();
    // contactRelationshipController.dispose();
    // contactNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    genderController.text = valueChoose;
    return  Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text("Register", 
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),),
                    //User
                    const SizedBox(height: 15),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [  
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: firstNameController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12)),
                                  hintText: 'First Name',
                                  hintStyle: const TextStyle( fontSize: 12), 
                                  prefixIcon: const Icon(Icons.person),
                                ),
                                obscureText: false,
                                validator: (value) {
                                  if(value!.isEmpty){
                                    return 'Required!';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          SizedBox(width: 15,),
                        Expanded(
                          child: TextFormField(
                            controller: lastNameController,
                            decoration: InputDecoration(
                            border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)),
                            hintText: 'Last Name',
                            hintStyle: const TextStyle( fontSize: 12), 
                            prefixIcon: const Icon(Icons.person),
                           ),
                            obscureText: false,
                            validator: (value) {
                          if(value!.isEmpty){
                            return 'Required!';
                          }
                          return null;
                                                      },                            
                                                    ),
                        ),                            
                          ],
                        ),
                          
                        const SizedBox(height: 15),
                      
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12)),
                            hintText: 'Email',
                            hintStyle: const TextStyle( fontSize: 12), 
                            prefixIcon: const Icon(Icons.email),
                          ),
                          obscureText: false,
                          validator: (value) {
                            if(value!.isEmpty){
                              return 'Required!';
                            }
                            return null;
                          },                              
                        ),
                        const SizedBox(height: 15),
                      
                        TextFormField(
                          controller: addressController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12)),
                            hintText: 'Address',
                            hintStyle: const TextStyle( fontSize: 12), 
                            prefixIcon: const Icon(Icons.location_city),
                          ),
                          obscureText: false,
                          validator: (value) {
                            if(value!.isEmpty){
                              return 'Required!';
                            }
                            return null;
                          },                              
                        ),

                        const SizedBox(height: 15),
                      
                        TextFormField(
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(11),
                          ],
                          controller: phoneNumberController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12)),
                            hintText: 'Phone Number',
                            hintStyle: const TextStyle( fontSize: 12), 
                            prefixIcon: const Icon(Icons.phone_android),
                          ),
                          obscureText: false,
                          validator: (value) {
                            if(value!.isEmpty){
                              return 'Required!';
                            }
                            return null;
                          },                              
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12)),
                            hintText: 'Password',
                            hintStyle: const TextStyle( fontSize: 12), 
                            prefixIcon: const Icon(Icons.key),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if(value!.isEmpty){
                              return 'Required!';
                            }
                            return null;
                          },                              
                        ),                          
              
                        //password
                                  
                       const SizedBox(height: 15),
              
                        TextFormField(
                          controller: confirmpasswordController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12)),
                            hintText: 'Confirm Password',
                            hintStyle: const TextStyle( fontSize: 12), 
                            prefixIcon: const Icon(Icons.key),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if(value!.isEmpty){
                              return 'Required!';
                            }
                            return null;
                          },                              
                        ), 
              
                       const SizedBox(height: 15),
              
                        TextFormField(
                          controller: dobController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12)),
                            hintText: 'Date of Birth',
                            hintStyle: const TextStyle( fontSize: 12), 
                            prefixIcon: const Icon(Icons.calendar_month),
                          ),
                          obscureText: false,
                          validator: (value) {
                            if(value!.isEmpty){
                              return 'Required!';
                            }
                            return null;
                          }, 
                          onTap: ()async{
                            DateTime? pickedDate = await showDatePicker(
                              context: context, 
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1990), 
                              lastDate: DateTime(2100));
              
                            if(pickedDate != null){
                              setState(() {
                                dobController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                              });
                            }
                  
                          },                             
                        ),
              
                        const SizedBox(height: 15), 
                  DropdownButtonHideUnderline(
                    child: DropdownButton(
                    hint:  Center(child: Text(genderController.text, textAlign: TextAlign.center,)),
                    isExpanded: true, 
                    value: valueChoose,
                    items:listItem.map((item) => DropdownMenuItem(
                          value: item,
                    child: Center(child: Text(item))
                )).toList(), 
                    onChanged: (value) {
                setState(() {
                  valueChoose = value!;
                  if(valueChoose == 'Male'){
                    genderController.text = 'Male';
                  }else{
                    genderController.text = 'Female';
                  }
                  print(genderController.text);
                  
                }); 
                    },
                ),
              ),


              Divider(),

              Text('Emergency Contact',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),  

              const SizedBox(height: 15),
              
              TextFormField(
                controller: contactNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)),
                  hintText: 'Complete Name',
                  hintStyle: const TextStyle( fontSize: 12),
                  prefixIcon: const Icon(Icons.person),
                ),
                validator: (value) {
                  if(value!.isEmpty){
                    return 'Required';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: contactRelationshipController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)),
                  hintText: 'Relationship',
                  hintStyle: const TextStyle( fontSize: 12),
                  prefixIcon: const Icon(Icons.group),
                ),
                validator: (value) {
                  if(value!.isEmpty){
                    return 'Required';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),            

              TextFormField(
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(11),
                ],
                controller: contactNumberController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)),
                  hintText: 'Contact Number',
                  hintStyle: const TextStyle( fontSize: 12),
                  prefixIcon: const Icon(Icons.phone_android),
                ),
                validator: (value) {
                  if(value!.isEmpty){
                    return 'Required';
                  }
                  return null;
                },
              ),                                             
                        ],
                      )
                    ),
              

        
                          
                    //Login Button
                    const SizedBox(height: 40),
                    MyButton(text: 'Register', onTap: () {
                      if(_formKey.currentState!.validate()){
                          registerUser();
                            //print(genderController.text);
                      }
                      
                    },),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         const Text(
                          'Already have an account? '
                          ,style: TextStyle(fontSize: 12),),
                         GestureDetector(
                          onTap: widget.onTap,
                          child: const Text(
                            'Log in', 
                            style: TextStyle(
                              color: Colors.black, 
                              fontSize: 12, 
                              fontWeight: FontWeight.bold),
                            ),
                         ),
                       ],
                     )
              ]),
            ),
        
        ),
      ),
    );
  }
}

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
    alignment: Alignment.center,
    value: item,
    child: Text(
      item,
      style: const  TextStyle( fontSize: 14),
    )
  );