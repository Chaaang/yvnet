import 'package:flutter/material.dart';
import 'package:yvnet/screens/admin/module_page.dart';
import 'package:yvnet/screens/volunteer/calendar_page.dart';

class HomeVolunteer extends StatelessWidget {
  const HomeVolunteer({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        // Container(
        //   height: 400,
        //   child: const CalenderView()),
            GestureDetector(
              onTap: () =>  Navigator.push(context, MaterialPageRoute(builder: (context) =>  CalenderView(hideAppBar: false),)),
              child: Stack(
                children: [
                  Container(
                    height: 150,
                    decoration: BoxDecoration(color: Colors.amber[400], borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Container(
                    height: 150,
                    width: 170,
                    decoration: BoxDecoration(
                      color: Colors.red[400], 
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(100), topRight:Radius.circular(100)),
                    image: const DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('Images/schedule.jpg'))
                  ),
                  ),
                  Positioned(
                    right: 20,
                    top: 10,
                    child: Container( 
                      width: 120,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white, 
                         borderRadius: BorderRadius.circular(30)
                    ),
                    child: Center(child: Text('Schedule', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.amber[400]),)),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: Container(
                      width: 60,
                      height: 60, 
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: Icon(Icons.calendar_month_outlined, color: Colors.amber[400],)
                    )
                  )
                ],
              ),
            ),
            const SizedBox(height: 10,),
            //Modules
            GestureDetector(
              onTap: () =>  Navigator.push(context, MaterialPageRoute(builder: (context) => const ModulePage(isAdmin: false),)),
              child: Stack(
                children: [
                  Container(
                    height: 150,
                    decoration: BoxDecoration(color: Colors.amber[400], borderRadius: BorderRadius.circular(10),
                  ),
                  ),
                  Container(
                    height: 150,
                    width: 170,
                    decoration: BoxDecoration(
                      color: Colors.red[400], 
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(100), topRight:Radius.circular(100)),
                    image: const DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('Images/module.jpg'))
                  ),
                  ),
                  Positioned(
                    right: 20,
                    top: 10,
                    child: Container( 
                      width: 120,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white, 
                         borderRadius: BorderRadius.circular(30)
                    ),
                    child: Center(child: Text('Modules', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.amber[400]),)),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: Container(
                      width: 60,
                      height: 60, 
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: Icon(Icons.menu_book, color: Colors.amber[400],)
                    )
                  )                
                ],
              ),
            ),          
      ],
    );
  }
}