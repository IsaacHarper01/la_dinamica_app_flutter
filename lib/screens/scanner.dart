import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:permission_handler/permission_handler.dart';


Future<void> scannerQR() async{

  var status = await Permission.camera.request();

  if (!status.isGranted) {
    return;
  }
  String barCodeScanner;
  try{
    barCodeScanner = await FlutterBarcodeScanner.scanBarcode(
                                                    "#ff6666", 
                                                    "Cancelar", 
                                                    false, 
                                                    ScanMode.QR);
  }on PlatformException{
    barCodeScanner = 'Fail to get platform version';
    return;
  }
  print(barCodeScanner);

}


