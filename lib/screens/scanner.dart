import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> scannerQR() async {
  var status = await Permission.camera.request();

  if (!status.isGranted) {
    return;
  }
  String barCodeScanner;
  try {
    barCodeScanner = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancelar", false, ScanMode.QR);
  } on PlatformException {
    barCodeScanner = 'Fail to get platform version';
    return;
  }
  //print(barCodeScanner);
  List<String> qrdata = barCodeScanner.split(',');
  String name = qrdata[0].split(':')[1];
  String id = qrdata[1].split(':')[1];
  String age = qrdata[2].split(':')[1];
  String address = qrdata[3].split(':')[1];
  String phone = qrdata[4].split(':')[1];
  Map<String, String> data = {
    'name': name,
    'id': id,
    'age': age,
    'address': address,
    'phone': phone
  };
}
