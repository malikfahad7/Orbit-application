import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:orbit/colors.dart';
import 'package:orbit/responsive.dart';
import 'package:orbit/screens/main_screen.dart';
import 'package:orbit/screens/profile_screen.dart';
import 'package:orbit/screens/alert_screen.dart';
import 'package:orbit/mongodb.dart';
import 'package:orbit/screens/stats%20page.dart'; // Import MongoDB class

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  int _selectedIndex = 0;
  int _unverifiedAlertCount = 0; // Initialize alert count

  List<Widget> _pages = [
    MainScreen(),
    StatsScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _fetchUnverifiedAlerts();
    Timer.periodic(Duration(seconds: 10), (timer) {
      _fetchUnverifiedAlerts(); // Refresh every 10 seconds
    });
  }

  Future<void> _fetchUnverifiedAlerts() async {
    try {
      var alerts = await MongoDatabase.getUnverifiedAlerts();
      setState(() {
        _unverifiedAlertCount = alerts.length; // Update the count
      });
    } catch (e) {
      print("Error fetching unverified alerts: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          automaticallyImplyLeading: false,
          toolbarHeight: MediaQuery.of(context).size.height * 0.1,
          centerTitle: true,
          title: Image.asset(
            'assets/Logo.png',
            height: getwidth(context) * 0.04,
          ),
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.notifications,
                    size: getheight(context) * 0.04,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AlertScreen(),
                      ),
                    );
                  },
                ),
                if (_unverifiedAlertCount > 0) // Show red badge only if count > 0
                  Positioned(
                    right: 11,
                    top: 11,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$_unverifiedAlertCount',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        // Use IndexedStack here instead of directly using _pages[_selectedIndex]
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
        bottomNavigationBar: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          child: GNav(
            gap: 10,
            backgroundColor: Colors.white,
            color: Colors.black,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.blueAccent,
            padding: EdgeInsets.all(15),
            tabBorderRadius: 16,
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'Home',
                iconSize: 24,
                iconColor: Colors.black,
              ),
              GButton(
                icon: Icons.auto_graph_outlined,
                text: 'Stats',
                iconSize: 24,
                iconColor: Colors.black,
              ),
              GButton(
                icon: Icons.person,
                text: 'Profile',
                iconSize: 24,
                iconColor: Colors.black,
              ),
            ],
            tabActiveBorder: Border.all(color: Colors.blue, width: 1.5),
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
        ),
      ),
    );
  }
}
