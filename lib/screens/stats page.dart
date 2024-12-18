import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:orbit/colors.dart';
import '../UserData.dart';
import '../mongodb.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  int reportsSubmitted = 0;
  bool isLoading = true;
  String selectedFilter = 'All'; // Default filter

  @override
  void initState() {
    super.initState();
    _loadReportsCount();
  }

  Future<void> _loadReportsCount() async {
    String? userId = await MongoDatabase.getUserId(UserData().email ?? '');
    userId = userId?.toString().replaceAll('ObjectId("', '').replaceAll('")', '');
    if (userId != null) {
      int count = await MongoDatabase.getReportsCountByUserId(userId);
      setState(() {
        reportsSubmitted = count;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: height * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("My Stats", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: height * 0.03),
              // Filter Bar above Reports Submitted Card
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: width * 0.35, // Set width for the filter dropdown
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: DropdownButton<String>(
                      value: selectedFilter,
                      isExpanded: true,
                      items: ['All', 'This Week', 'This Month', 'Last 3 Months'].map((filter) {
                        return DropdownMenuItem(
                          value: filter,
                          child: Text(filter),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedFilter = value!;
                        });
                      },
                      underline: SizedBox(), // Remove the underline from the dropdown
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.03),
              if (isLoading)
                Center(
                  child: SpinKitFadingCircle(color: AppColors.primaryColor),
                )
              else
                _buildStatBlock('Reports Submitted', '$reportsSubmitted', width, height),
            ],
          ),
        ),
      ),
    );
  }

  // Stat block displaying the reports submitted count (full width)
  Widget _buildStatBlock(String title, String value, double width, double height) {
    return Container(
      width: width, // Full width for the stat block
      height: height * 0.2,
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          Text(value, style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
