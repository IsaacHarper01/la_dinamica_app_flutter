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
    if (barCodeScanner=='-1') {
      return;
    }
    List<String> qrdata = barCodeScanner.split(',');
      String id = qrdata[0];
      String name = qrdata[1];
      String address = qrdata[2];
      String phone = qrdata[3];
      String age = qrdata[4];
      Map<String, String> data = {
        'name': name,
        'id': id,
        'age': age,
        'address': address,
        'phone': phone
      };
  } on PlatformException {
    barCodeScanner = 'Fail to get platform version';
    return;
  }
  
  
}
