import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:yvnet/screens/admin/schedule_page.dart';
import 'package:yvnet/screens/volunteer/calendar_page.dart';

class scheduleView extends StatefulWidget {
  const scheduleView({super.key});

  @override
  State<scheduleView> createState() => _scheduleViewState();
}

class _scheduleViewState extends State<scheduleView> {
  int _currentIndex = 0;
  PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Row(
          children: [Icon(Icons.calendar_month_outlined, color: Colors.amber[400], size: 35,), 
                    const SizedBox(width: 10,),
                    Text('Schedule',
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
      body: PageView(
        controller: pageController,
        children: [
          const SchedulePage(),
          CalenderView(hideAppBar: true),
        ],
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: GNav(
        onTabChange: (index) {
          setState(() {
             pageController.jumpToPage(index);
          });
         
        },
        tabs: const [
          GButton(icon: Icons.calendar_month, text: 'Set Meeting',),
          GButton(icon: Icons.view_array_rounded, text: 'View Meeting',)
        ]
      ),
    );
  }
}