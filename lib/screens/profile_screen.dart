import 'package:flutter/material.dart';
import '../UserData.dart';
import '../colors.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  Widget build(BuildContext context) {
    // Retrieve the logged-in manager's name and floor number from UserData
    String managerName = UserData().username!;
    String floorNumber = UserData().floor!;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Picture
              CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage('assets/dummy.jpg'), // Use the image from assets folder
                backgroundColor: Colors.grey[200],
              ),
              SizedBox(height: 20),

              // Display Manager's Name
              Text(
                managerName.isNotEmpty ? managerName : 'Loading...',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10),

              // Display Manager's Floor Number
              Text(
                'Floor $floorNumber Manager',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 20),

              // Edit Profile Button
              ElevatedButton(
                onPressed: () {
                  // Add action to edit profile if needed
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: AppColors.primaryColor, // Text color
                ),
                child: Text('Edit Profile'),
              ),
              SizedBox(height: 30),

              // Profile Details Section
              Container(
                decoration: BoxDecoration(
                  color: Colors.white54,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: Icon(Icons.person, color: Colors.black87),
                  title: Text(
                    'Personal Information',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, color: AppColors.primaryColor),
                  onTap: () {
                    // Navigate to personal information page or perform any action
                  },
                ),
              ),

              // Logout Section
              Container(
                decoration: BoxDecoration(
                  color: Colors.white54,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: Icon(Icons.logout, color: Colors.black87),
                  title: Text(
                    'Logout',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, color: AppColors.primaryColor),
                  onTap: () {
                    // Clear the navigation stack and go to the login screen
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                          (Route<dynamic> route) => false, // Remove all previous routes
                    );
                  },
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
