import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:aws_common/vm.dart';
import 'package:la_dinamica_app/models/student.dart';

class Storages3 {
  
Future<String?> uploadFile(File file, String name, String tenantId) async {
  try {
    String newPath = 'public/$tenantId/students/$name.png';
    safePrint('Uploading file to S3: $newPath');
    final result = await Amplify.Storage.uploadFile(
      localFile: AWSFilePlatform.fromFile(file),
      path: StoragePath.fromString(newPath),
    ).result;
    safePrint('Uploaded file: ${result.uploadedItem.path}');
    final urlpath = await getImageUrl(result.uploadedItem.path);
    String image = '{"imagePath":"${result.uploadedItem.path}","imageUrl":"$urlpath"}'; 
    return image;
  } on StorageException catch (e) {
    safePrint(e.message);
    return null;
  }
}

Future<String?> getImageUrl(String fileName) async {
  try {
    final result = await Amplify.Storage.getUrl(
      path: StoragePath.fromString(fileName),
    ).result;

    return result.url.toString();
  } catch (e) {
    safePrint('Error retrieving image URL: $e');
    return null;
  }
}

Future<Uint8List> downloadFile(String fileName) async {
  final result = await Amplify.Storage.downloadData(
  path: StoragePath.fromString(fileName), // photo = S3 key
  ).result;

  final Uint8List photoBytes = Uint8List.fromList(result.bytes);
  safePrint('Downloaded file: ${result.downloadedItem.path}');
  return photoBytes;
  }

Future<List<String?>> getImages(List<int> ids, String tenantId) async {
    try {
      List<Student> general = [];
      for (var id in ids) {
        general.addAll(
          await Amplify.DataStore.query(
            Student.classType,
            where: Student.USER_ID.eq(id) 
                .and(Student.CLIENT_ID.eq(tenantId)
                )
          ),
        );
      }
      List<String> images = [];
      if (general.isNotEmpty) {
        for (var student in general) {
          images.add(jsonDecode(student.image!)['imageUrl']);
        }
        safePrint('✅ Imagenes obtenidas correctamente');
        return images;
      } else {
        safePrint('❌ No se encontró el alumno con el ID proporcionado');
        return [];
      }
    } catch (e) {
      safePrint(' Error al obtener las imagenes: $e');
      rethrow;
    }
  }
}