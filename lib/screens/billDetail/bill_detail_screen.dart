import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../gen/assets.gen.dart';
import '../../model/bill_item_model.dart';

class BillDetailScreen extends StatelessWidget {
  final String billNo;
  final String customerName;
  final String mobileNumber;
  final String address;
  final String billDate;
  final List<BillItemModel> items;
  final int totalAmount;

  const BillDetailScreen({
    super.key,
    required this.billNo,
    required this.customerName,
    required this.mobileNumber,
    required this.address,
    required this.billDate,
    required this.items,
    required this.totalAmount,
  });

  Future<Uint8List> _generateBillPdf() async {
    final pdf = pw.Document();

    // Load custom font
    final fontData = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
    final ttf = pw.Font.ttf(fontData.buffer.asByteData());

    // Load shop logo
    final logoData = await rootBundle.load(Assets.images.appLogo.path);
    final logo = pw.MemoryImage(logoData.buffer.asUint8List());

    // Load WhatsApp icon (you need to put whatsapp.png in assets and register in pubspec.yaml)
    final whatsappData = await rootBundle.load(Assets.icons.whatsappLogo.path);
    final whatsappIcon = pw.MemoryImage(whatsappData.buffer.asUint8List());

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header with Logo and Shop Name
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Container(
                      width: 120,
                      height: 120,
                      child: pw.Image(logo),
                    ),
                    pw.SizedBox(width: 15),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          "Dev CHILDREN'S WEAR",
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 22,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text(
                          "Jiyanu • Toys • Traditional • Shoes",
                          style: pw.TextStyle(font: ttf, fontSize: 12),
                        ),
                        pw.Text(
                          "73, Bhaktinagar, I.C.O. Road,\nChandkheda, Ahmedabad-382424",
                          style: pw.TextStyle(font: ttf, fontSize: 12),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Row(
                          children: [
                            pw.Image(whatsappIcon, width: 14, height: 14),
                            pw.SizedBox(width: 5),
                            pw.Text(
                              "70690 22424",
                              style: pw.TextStyle(font: ttf, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),
                // Customer Info
                pw.Text(
                  "Customer: $customerName",
                  style: pw.TextStyle(font: ttf),
                ),
                pw.Text(
                  "Mobile: $mobileNumber",
                  style: pw.TextStyle(font: ttf),
                ),
                pw.Text("Address: $address", style: pw.TextStyle(font: ttf)),
                pw.Text("Bill Date: $billDate", style: pw.TextStyle(font: ttf)),
                pw.Text("Bill No: $billNo", style: pw.TextStyle(font: ttf)),
                pw.SizedBox(height: 10),
                // Items Table
                pw.Table.fromTextArray(
                  headers: ["Item Name", "Category", "Price", "Qty", "Total"],
                  data: items
                      .map(
                        (it) => [
                          it.productName,
                          it.category,
                          "\u20B9${it.price}",
                          it.quantity.toString(),
                          "\u20B9${it.totalAmount}",
                        ],
                      )
                      .toList(),
                  cellAlignments: {
                    0: pw.Alignment.center,
                    1: pw.Alignment.center,
                    2: pw.Alignment.center,
                    3: pw.Alignment.center,
                    4: pw.Alignment.center,
                  },
                  headerStyle: pw.TextStyle(
                    font: ttf,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  cellStyle: pw.TextStyle(font: ttf),
                  headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
                ),

                pw.SizedBox(height: 10),

                // ✅ Grand Total Row
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.black, width: 1),
                        color: PdfColors.grey200,
                      ),
                      child: pw.Row(
                        children: [
                          pw.Text(
                            "Grand Total: ",
                            style: pw.TextStyle(
                              font: ttf,
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          pw.SizedBox(width: 5),
                          pw.Text(
                            "\u20B9$totalAmount",
                            style: pw.TextStyle(
                              font: ttf,
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),
                // Footer
                pw.Text(
                  "• Subject to Ahmedabad Jurisdiction",
                  style: pw.TextStyle(font: ttf, fontSize: 12),
                ),
                pw.Text(
                  "• Fix Rate",
                  style: pw.TextStyle(font: ttf, fontSize: 12),
                ),
                pw.SizedBox(height: 10),
                pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Text(
                    "For, DEV CHILDREN'S WEAR",
                    style: pw.TextStyle(font: ttf),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bill Preview")),
      body: PdfPreview(
        build: (format) => _generateBillPdf(),
        canChangeOrientation: false,
        canChangePageFormat: false,
        canDebug: false,
        allowPrinting: true,
        allowSharing: true,
      ),
    );
  }
}
