import 'dart:io';
import 'dart:ui';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';

Future<void> generateQRAndSaveAsPdf(int id, String name, String address, String number, String age) async {
  // 1. Generate the QR code widget
  final qrCodeData = id.toString() + name + address + number + age;
  
  // 2. Create a PDF document
  final pdf = pw.Document();

  // 3. Convert the QR code to an image for the PDF
  final image = await QrPainter(
    data: qrCodeData,
    version: QrVersions.auto,
    gapless: false,
  ).toImage(120); // 150 is the size of the image

  final byteData = await image.toByteData(format: ImageByteFormat.png);
  final imageBytes = byteData!.buffer.asUint8List();

  // 4. Add the QR code image to the PDF document

 pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Container(
            height: 300, // Example size of container
            width: 400, // Example size of container
            decoration: pw.BoxDecoration(
              border: pw.Border.all(width: 2),
            ),
            child: pw.Stack(
              children: [
                // Move the QR image using Positioned
                pw.Positioned(
                  top: 165, // Adjust the top margin
                  left: 140, // Adjust the left margin
                  child: pw.Image(pw.MemoryImage(imageBytes)),
                ),
                // Add other widgets if necessary
                pw.Positioned(
                  top: 40,
                  left: 130,
                  child: pw.Text(
                    "nombre: $name",
                    style: pw.TextStyle(fontSize: 15,font: pw.Font.timesBoldItalic()),
                  ),
                ),
                pw.Positioned(
                  top: 70,
                  left: 130,
                  child: pw.Text(
                    "numero de alumno: $id",
                    style: pw.TextStyle(fontSize: 15,font: pw.Font.timesBoldItalic()),
                  ),
                ),
                pw.Positioned(
                  top: 100,
                  left: 130,
                  child: pw.Text(
                    "telefono: $number",
                    style: pw.TextStyle(fontSize: 15,font: pw.Font.timesBoldItalic()),
                  ),
                ),
                pw.Divider(
                  thickness: 2, // Thickness of the line
                  height: 490,   // Space between line and text
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
  final file = File("${output.path}/$name.pdf");
  await file.writeAsBytes(await pdf.save());

  // Optional: Print or share the PDF file
  await Printing.sharePdf(bytes: await pdf.save(), filename: '$name.pdf');
}