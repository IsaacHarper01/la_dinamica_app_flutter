import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:la_dinamica_app/backend/database.dart';
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
      int id = int.parse(qrdata[0]);
      String name = qrdata[1];
      String address = qrdata[2];
      String phone = qrdata[3];
      String age = qrdata[4];
      
    final db = DatabaseHelper();
    db.InserAttendanceData(id, name);
    db.varifyPay(id);
    print('Registro Exitóso');
    
  } on PlatformException {
    barCodeScanner = 'Fail to get platform version';
    return;
  }
  
  
}
