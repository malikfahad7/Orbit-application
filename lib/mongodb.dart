import 'dart:developer';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:bcrypt/bcrypt.dart'; // For password hashing
import 'constants.dart'; // Ensure constants contain MONGO_URL and COLLECTION_NAME
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class MongoDatabase {

  // Establish a connection to the MongoDB database
  static Future<Db> connect() async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    return db;
  }

  // Fetch the user by email and compare the password using bcrypt
  static Future<Map<String, dynamic>?> getUser(String email, String password) async {
    Db? db;
    try {
      db = await connect();
      var collection = db.collection(COLLECTION_NAME);

      // Fetch the user by email
      var user = await collection.findOne({
        'email': email,
        'role': 'Floor Manager' // Check the role of Floor Manager
      });

      if (user != null) {
        // Compare hashed password using bcrypt
        bool passwordMatch = BCrypt.checkpw(password, user['password']);
        if (passwordMatch) {
          return user; // Return user details if password matches
        }
      }
      return null; // Return null if password doesn't match or user not found
    } catch (e) {
      log('Error in getUser: $e');
      return null;
    } finally {
      if (db != null) {
        await db.close();
      }
    }
  }

  // Fetch unverified alerts
  static Future<List<Map<String, dynamic>>> getUnverifiedAlerts() async {
    Db? db;
    try {
      db = await connect();
      var collection = db.collection('suspiciousactivities');

      // Query for unverified alerts
      var alerts = await collection.find({'Verification': 'unverified'}).toList();
      return alerts; // Return the list of unverified alerts
    } catch (e) {
      log('Error in getUnverifiedAlerts: $e');
      return [];
    } finally {
      if (db != null) {
        await db.close();
      }
    }
  }

  // Delete an alert by ID
  static Future<void> deleteAlert(String id) async {
    Db? db;
    try {
      db = await connect();
      var collection = db.collection('suspiciousactivities');
      await collection.remove(where.id(ObjectId.parse(id)));
    } catch (e) {
      log('Error in deleting alert: $e');
    } finally {
      if (db != null) {
        await db.close();
      }
    }
  }

  // Update alert status
  static Future<void> updateAlertStatus(String id, String status) async {
    Db? db;
    try {
      db = await connect();
      var collection = db.collection('suspiciousactivities');
      var result = await collection.updateOne(
        where.id(ObjectId.parse(id)),
        modify.set('Verification', status),
      );
    } catch (e) {
      log('Error in updating alert status: $e');
    } finally {
      if (db != null) {
        await db.close();
      }
    }
  }

  // Insert action report into ActionReport collection
  static Future<void> insertActionReport(Map<String, dynamic> actionReportData) async {
    Db? db;
    try {
      db = await connect();
      var collection = db.collection('actionreports');
      await collection.insert(actionReportData);
    } catch (e) {
      log('Error in inserting action report: $e');
    } finally {
      if (db != null) {
        await db.close();
      }
    }
  }

  // Fetch the user ID based on email
  static Future<String?> getUserId(String email) async {
    Db? db;
    try {
      db = await connect();
      var collection = db.collection(COLLECTION_NAME);
      var user = await collection.findOne({'email': email});
      return user?['_id'].toString();
    } catch (e) {
      log('Error in getUserId: $e');
      return null;
    } finally {
      if (db != null) {
        await db.close();
      }
    }
  }
  static Future<List<Map<String, dynamic>>> getVerifiedAndCompletedAlerts() async {
    Db? db;
    try {
      db = await connect();
      var collection = db.collection('suspiciousactivities');

      // Query to fetch alerts with 'verified' or 'completed' status
      var alerts = await collection.find({
        'Verification': {r'$in': ['verified', 'completed']}
      }).toList();

      return alerts; // Return the list of verified/completed alerts
    } catch (e) {
      log('Error in getVerifiedAndCompletedAlerts: $e');
      return [];
    } finally {
      if (db != null) {
        await db.close();
      }
    }
  }
  static Future<String?> getFloorForManager(String managerName) async {
    Db? db;
    try {
      db = await connect();
      var collection = db.collection('floors');

      // Query for the floor where the FloorManager matches the logged-in user's name
      var floor = await collection.findOne({'FloorManager': managerName});

      if (floor != null) {
        return floor['FloorNo'].toString(); // Return the floor number as a string
      }
      return null; // Return null if no matching floor is found
    } catch (e) {
      log('Error in getFloorForManager: $e');
      return null;
    } finally {
      if (db != null) {
        await db.close();
      }
    }
  }

  // Fetch count of reports submitted by the user
  static Future<int> getReportsCountByUserId(String userId) async {
    Db? db;
    try {
      db = await connect();
      var collection = db.collection('actionreports');

      // Count reports where userId matches
      var count = await collection.count({'userId': userId});
      return count;
    } catch (e) {
      log('Error in getReportsCountByUserId: $e');
      return 0; // Return 0 if there's an error
    } finally {
      if (db != null) {
        await db.close();
      }
    }
  }


}
