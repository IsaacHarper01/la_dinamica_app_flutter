import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

Future<String> pickAndSaveImage(String name) async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.camera);
  print('nombre del alumno: $name');

  if (pickedFile != null) {
    // Get the image as a File
    File imageFile = File(pickedFile.path);

    // Read the image as a byte array and decode it
    final imageBytes = await imageFile.readAsBytes();
    img.Image originalImage = img.decodeImage(imageBytes)!;

    // Resize the image (for example, to 300x300)
    img.Image resizedImage = img.copyResize(originalImage, width: 300, height: 300);

    // Get the directory to save the image
    Directory directory = await getApplicationDocumentsDirectory();
    String newPath = path.join(directory.path, '$name.jpg');
    print('antes de salvar la imagen: $newPath');
    // Save the resized image as a file
    File resizedImageFile = File(newPath)
      ..writeAsBytesSync(img.encodeJpg(resizedImage, quality: 85)); // Save with compression
    
    print('Image saved at: $newPath');
    return newPath;
    
  } else {
    print('No image selected.');
    return 'assets/images/f=ma11.png';
  }
}
