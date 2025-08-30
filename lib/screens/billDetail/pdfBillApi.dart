import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../gen/assets.gen.dart';

class PdfBillApi {
  static Future<Uint8List> generateBill({
    required String customerName,
    required String billNo,
    required String date,
    required List<Map<String, dynamic>> items,
  }) async {
    final pdf = pw.Document();


    // Load custom font
    final fontData = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
    final ttf = pw.Font.ttf(fontData.buffer.asByteData());

    // Load shop logo
    final logoData = await rootBundle.load(Assets.images.appLogo.path);
    final logo = pw.MemoryImage(logoData.buffer.asUint8List());

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(16),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              /// HEADER with Logo + Shop Info
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(
                    width: 120,
                    height: 120,
                    child: pw.Image(logo),
                  ),
                  pw.SizedBox(width: 16),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("Dev CHILDREN'S WEAR",
                          style: pw.TextStyle(
                              fontSize: 20, fontWeight: pw.FontWeight.bold)),
                      pw.Text("Jiyanu • Toys • Traditional • Shoes",
                          style: pw.TextStyle(fontSize: 12)),
                      pw.Text("73, Bhaktinagar, I.C.O Road,\n"
                          "Chandkheda, Ahmedabad - 382424"),
                      pw.Text("📞 70690 22424"),
                    ],
                  ),
                ],
              ),

              pw.SizedBox(height: 12),

              /// CUSTOMER + BILL DETAILS
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Expanded(
                      child: pw.Text("M/s: $customerName",
                          style: const pw.TextStyle(fontSize: 12))),
                  pw.Text("Bill No: $billNo", style: const pw.TextStyle(fontSize: 12)),
                  pw.Text("Date: $date", style: const pw.TextStyle(fontSize: 12)),
                ],
              ),
              pw.SizedBox(height: 8),

              /// TABLE
              pw.Table.fromTextArray(
                headers: ["No.", "Particulars", "Qty", "Rate", "Amount"],
                data: [
                  for (int i = 0; i < items.length; i++)
                    [
                      "${i + 1}",
                      items[i]["name"],
                      items[i]["qty"].toString(),
                      "₹${items[i]["rate"]}",
                      "₹${items[i]["qty"] * items[i]["rate"]}",
                    ]
                ],
                border: pw.TableBorder.all(),
                headerDecoration: const pw.BoxDecoration(color: PdfColors.blue100),
                headerStyle: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold, fontSize: 12),
                cellStyle: const pw.TextStyle(fontSize: 12),
                cellAlignments: {
                  0: pw.Alignment.center,
                  1: pw.Alignment.centerLeft,
                  2: pw.Alignment.center,
                  3: pw.Alignment.centerRight,
                  4: pw.Alignment.centerRight,
                },
              ),

              /// TOTAL
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  "Total: \u20B9500 100",
                  style: pw.TextStyle(
                      fontSize: 14, fontWeight: pw.FontWeight.bold),
                ),
              ),

              pw.SizedBox(height: 16),

              /// FOOTER
              pw.Text("• Subject to Ahmedabad Jurisdiction"),
              pw.Text("• Fix Rate"),
              pw.SizedBox(height: 8),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text("For, DEV CHILDREN'S WEAR"),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}
