import 'package:flutter/material.dart';
import 'package:orbit/colors.dart';
import 'package:shimmer/shimmer.dart';
import '../mongodb.dart';
import 'package:intl/intl.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Map<String, dynamic>> alerts = [];
  String selectedFilter = 'All';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAlerts();
  }

  Future<void> fetchAlerts() async {
    var fetchedAlerts = await MongoDatabase.getVerifiedAndCompletedAlerts();
    setState(() {
      alerts = fetchedAlerts;
      isLoading = false;
    });
  }

  List<Map<String, dynamic>> getFilteredAlerts() {
    if (selectedFilter == 'All') return alerts;
    return alerts.where((alert) => alert['Verification'] == selectedFilter.toLowerCase()).toList();
  }

  Widget buildShimmerEffect() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey.shade400,
                  child: Icon(Icons.warning_amber_rounded, color: Colors.grey.shade300),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 10, width: 100, color: Colors.grey.shade400),
                      const SizedBox(height: 5),
                      Container(height: 10, width: 150, color: Colors.grey.shade400),
                      const SizedBox(height: 5),
                      Container(height: 10, width: 120, color: Colors.grey.shade400),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String formatDate(dynamic timestamp) {
    try {
      // Check if the timestamp is a DateTime object
      if (timestamp is DateTime) {
        return DateFormat('yyyy-MM-dd').format(timestamp); // Format the date
      } else if (timestamp is String) {
        DateTime date = DateTime.parse(timestamp); // Parse string to DateTime
        return DateFormat('yyyy-MM-dd').format(date);
      }
    } catch (e) {
      return 'Invalid Date';
    }
    return 'Invalid Date';
  }

  String formatTime(dynamic timestamp) {
    try {
      // Check if the timestamp is a DateTime object
      if (timestamp is DateTime) {
        return DateFormat('HH:mm:ss').format(timestamp); // Format the time
      } else if (timestamp is String) {
        DateTime date = DateTime.parse(timestamp); // Parse string to DateTime
        return DateFormat('HH:mm:ss').format(date);
      }
    } catch (e) {
      return 'Invalid Time';
    }
    return 'Invalid Time';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Alerts',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<String>(
                    value: selectedFilter,
                    items: ['All', 'Verified', 'Completed'].map((filter) {
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
                  ),
                ],
              ),
              const SizedBox(height: 20),
              isLoading
                  ? Expanded(child: buildShimmerEffect())
                  : getFilteredAlerts().isEmpty
                  ? Center(child: Text('No alerts found.'))
                  : Expanded(
                child: ListView.builder(
                  itemCount: getFilteredAlerts().length,
                  itemBuilder: (context, index) {
                    var alert = getFilteredAlerts()[index];
                    String status = alert['Verification'];

                    Color cardColor = (status == 'verified')
                        ? Colors.orange.shade100
                        : (status == 'completed')
                        ? Colors.green.shade100
                        : Colors.grey.shade300;

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      padding: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: (status == 'verified')
                                ? Colors.orange
                                : (status == 'completed')
                                ? Colors.green
                                : Colors.grey,
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${alert['Type']} Detected',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text('Floor: ${alert['FloorNo']}'),
                                Text('Camera: ${alert['CameraNo']}'),
                                Text('Date: ${formatDate(alert['TimeStamp'])}'),
                                Text('Time: ${formatTime(alert['TimeStamp'])}'),
                              ],
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios, color: Colors.grey),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
