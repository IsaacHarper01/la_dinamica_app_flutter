import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:la_dinamica_app/providers/storageS3.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';


Future<String?> pickAndSaveImage(String name, String tenantId, bool takeAgain) async {
  final picker = ImagePicker();
  final storage = Storages3();
  final pickedFile = await picker.pickImage(source: ImageSource.camera);

  if (pickedFile != null) {
    // Get the image as a File
    File imageFile = File(pickedFile.path);

    // Read the image as a byte array and decode it
    final imageBytes = await imageFile.readAsBytes();
    img.Image originalImage = img.decodeImage(imageBytes)!;

    // Resize the image (for example, to 300x300)
    img.Image resizedImage = img.copyResize(
      originalImage,
      width: 500,
      height: 600,
    );

    final compressedBytes = img.encodeJpg(resizedImage, quality: 85);

    // Save to temp file before upload
    final tempDir = await getTemporaryDirectory();
    final tempPath = takeAgain ? path.join(tempDir.path, "tempPhoto") : path.join(tempDir.path, name);
    final tempFile = await File(tempPath).writeAsBytes(compressedBytes);

    // Upload the image to S3

    String? newPath = takeAgain ? 
       await storage.updateImage(tempFile, name) :
       await storage.uploadFile(tempFile, name, tenantId);
    
    return newPath;
  } else {
    safePrint('No image selected.');
    return 'assets/images/default_profile.jpg'; // Default image path
  }
}
