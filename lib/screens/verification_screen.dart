import 'dart:math';
import 'package:flutter/material.dart';
import 'package:orbit/screens/home_screen.dart';
import '../UserData.dart';
import '../colors.dart';
import '../responsive.dart';
import '../mongodb.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class VerificationScreen extends StatefulWidget {
  final Map<String, dynamic> alert;

  VerificationScreen({required this.alert});

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  bool isAlertValid = false;
  final _descriptionController = TextEditingController();
  final _evidenceController = TextEditingController();
  final _notesController = TextEditingController();
  bool isSubmitting = false;
  String? userEmail = UserData().email;

  Future<void> updateAlertStatus(String id, bool isValid) async {
    await MongoDatabase.updateAlertStatus(id, isValid ? 'verified' : 'unverified');
  }

  Future<void> submitActionReport() async {
    if (_descriptionController.text.isEmpty || _evidenceController.text.isEmpty || _notesController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All fields are required"), backgroundColor: Colors.red));
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    if (userEmail == null) {
      print("User email is null");
      setState(() {
        isSubmitting = false;
      });
      return;
    }

    var userObjectId = await MongoDatabase.getUserId(userEmail!);
    String suspiciousActivityId = widget.alert['SuspiciousActivityId'];
    String location = "Floor ${Random().nextInt(10) + 1}";

    var actionReportData = {
      '_id': mongo.ObjectId(),
      'userId': userObjectId.toString().replaceAll('ObjectId("', '').replaceAll('")', ''),
      'SuspiciousActivityId': suspiciousActivityId,
      'SubmissionDate': DateTime.now(),
      'location': location,
      'IncidentDescription': _descriptionController.text,
      'Evidence': _evidenceController.text,
      'AdditionalNotes': _notesController.text,
    };

    await MongoDatabase.insertActionReport(actionReportData);
    setState(() {
      isSubmitting = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Report submitted successfully!"), backgroundColor: Colors.green));

    // Navigate to Home Screen after data is submitted successfully
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => homeScreen()),
          (Route<dynamic> route) => false, // This removes all the previous routes.
    );

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: AppColors.primaryColor,
          title: Image.asset(
            'assets/Logo.png',
            height: getwidth(context) * 0.04,
          ),
          toolbarHeight: MediaQuery.of(context).size.height * 0.1,
          centerTitle: true,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Verification', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text('Verify the alert. Upon verification, you have to submit the action report.', style: TextStyle(fontSize: 16)),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Valid Alert', style: TextStyle(fontSize: 18)),
                    Switch(
                      value: isAlertValid,
                      onChanged: (value) {
                        setState(() {
                          isAlertValid = value;
                          String alertId = widget.alert['_id'].toHexString();
                          updateAlertStatus(alertId, isAlertValid);
                        });
                      },
                      activeColor: AppColors.primaryColor,
                    ),
                  ],
                ),
                if (isAlertValid) ...[
                  SizedBox(height: getheight(context) * 0.03),
                  Text('Action Report', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  Text('Description'),
                  SizedBox(height: 10),
                  TextField(
                    controller: _descriptionController,
                    cursorColor: AppColors.primaryColor,
                    maxLines: 3,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primaryColor)),
                      border: OutlineInputBorder(),
                      hintText: 'Enter Description',
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Evidence'),
                  SizedBox(height: 10),
                  TextField(
                    controller: _evidenceController,
                    cursorColor: AppColors.primaryColor,
                    maxLines: 2,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primaryColor)),
                      border: OutlineInputBorder(),
                      hintText: 'Enter Evidence',
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Additional Notes'),
                  SizedBox(height: 10),
                  TextField(
                    controller: _notesController,
                    cursorColor: AppColors.primaryColor,
                    maxLines: 2,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primaryColor)),
                      border: OutlineInputBorder(),
                      hintText: 'Enter Additional Notes',
                    ),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: isSubmitting ? null : submitActionReport,
                    child: isSubmitting
                        ? SpinKitCircle(color: Colors.white, size: 30)
                        : Text('Submit', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      backgroundColor: AppColors.primaryColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
