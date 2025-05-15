import 'dart:io';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';

Future<void> generateCredentialandSend(int id, String name, String address, String number, String age, String photo) async {
  // 1. Generate the QR code widget
  final qrCodeData = id.toString()+ ',' + name+ ',' + address + ',' + number + ',' + age;
  final File photoFile = File(photo);
  final Uint8List photoBytes = await photoFile.readAsBytes();
  final ByteData wallpaperData = await rootBundle.load('assets/images/fondo6.jpg');

  // 2. Create a PDF document
  final pdf = pw.Document();

  // 3. Convert the QR code to an image for the PDF
  final image = await QrPainter(
    data: qrCodeData,
    version: QrVersions.auto,
    gapless: false,
    dataModuleStyle: const QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square, color: Color.fromRGBO(0, 0, 0, 1.0)),
    eyeStyle:  QrEyeStyle(color: Color.fromRGBO(0, 0, 0, 1.0)),  
  ).toImage(120); // 120 is the size of the image

  final byteData = await image.toByteData(format: ImageByteFormat.png);
  final qrImageBytes = byteData!.buffer.asUint8List();
  final Uint8List wallpaperBytes = wallpaperData.buffer.asUint8List();

  // 4. Add the QR code image to the PDF document

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Container(
            height: 600, 
            width: 230,
            decoration: pw.BoxDecoration(
              border: pw.Border.all(width: 2),
            ),
            child: pw.Stack(
              children: [
                pw.Positioned( 
                  child: pw.Image(
                    pw.MemoryImage(wallpaperBytes),
                    width: 350,  
                    ),
                ),
                pw.Positioned(
                  top: 400,
                  left: 65,
                  child: pw.Container(
                    width: 110,
                    height: 110,
                    decoration: pw.BoxDecoration(
                      color: PdfColors.white, // Outer container background
                      borderRadius: pw.BorderRadius.circular(10), // Rounded corners
                    ),
                    padding: const pw.EdgeInsets.all(10), // Padding for inner QR
                    child: pw.Container(
                      decoration: pw.BoxDecoration(
                        borderRadius: pw.BorderRadius.circular(8),
                      ),
                      child: pw.Image(
                        pw.MemoryImage(qrImageBytes), // Your QR image bytes
                        fit: pw.BoxFit.contain, // Ensures QR fits within container
                      ),
                    ),
                  ),
                ),
                pw.Positioned(
                  top: 20, 
                  left: 65,
                  child:  pw.ClipRRect(
                      horizontalRadius: 50, 
                      verticalRadius: 50,   
                      child: pw.Image(
                        pw.MemoryImage(photoBytes), 
                        width: 135,  
                        height: 135, 
                    ),
                  ),
                ),
                pw.Positioned(
                  top: 160,
                  left: 20,
                  child: pw.Container(
                    height: 50,
                    width: 200,
                    child: pw.Center(
                      child: pw.Text(
                        "$name",
                        style: pw.TextStyle(fontSize: 15,font: pw.Font.timesBoldItalic(),color: PdfColor.fromRYB(0, 0, 0)),
                      ),
                    ),
                  )
                ),
                pw.Positioned(
                  top: 210,
                  left: 90,
                  child: pw.Text(
                    "Tel: $number",
                    style: pw.TextStyle(fontSize: 10,font: pw.Font.timesBoldItalic(),color: PdfColor.fromRYB(0, 0, 0)),
                  ),
                ),
                pw.Positioned(
                  top: 230,
                  left: 110,
                  child: pw.Text(
                    "ID: $id",
                    style: pw.TextStyle(fontSize: 10,font: pw.Font.timesBoldItalic(),color: PdfColor.fromRYB(0, 0, 0)),
                  ),
                ),
                pw.Divider(
                  thickness: 2, 
                  height: 690,   
          ),
              ],
            ),
          )
        );
      },
    ),
  );

  // 5. Save the PDF file
  final output = await getTemporaryDirectory();
  print(output.path);
  //final file = File("${output.path}/$name.pdf");
  //await file.writeAsBytes(await pdf.save());

  // Optional: Print or share the PDF file
  await Printing.sharePdf(bytes: await pdf.save(), filename: '$name.pdf');
}
