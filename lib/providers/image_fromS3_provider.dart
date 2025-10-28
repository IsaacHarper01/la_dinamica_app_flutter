
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/providers/storageS3.dart';

final imageProvider = FutureProvider.family<String?, String>((ref, imageKey) async {
  final awsS3 = Storages3();
  return awsS3.getImageUrl(imageKey);
});