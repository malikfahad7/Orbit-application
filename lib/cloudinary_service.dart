import 'package:cloudinary/cloudinary.dart';

class CloudinaryService {
  final Cloudinary cloudinary = Cloudinary.signedConfig(
    apiKey: '168745793817754',
    apiSecret: 'biAhcu8eU0NBZ-SCdlGAYXka1KE',
    cloudName: 'dmcddpsce',
  );


  Future<String?> uploadImage(String filePath) async {
    try {
      // Using the `upload` method instead of `uploadFile`
      final response = await cloudinary.upload(
        resourceType: CloudinaryResourceType.image, // Specify resource type as image
        folder: 'user_profile_pictures', // Optional folder for organization
      );
      return response.secureUrl; // Return the secure URL of the uploaded image
    } catch (e) {
      print("Error uploading image to Cloudinary: $e");
      return ''; // Return an empty string if error occurs
    }
  }
}
