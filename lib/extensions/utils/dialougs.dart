import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void showQrScannerDialog(BuildContext context) {
  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
  );

  showDialog(
    context: context,
    builder: (BuildContext ctx) {
      return AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            width: MediaQuery.of(ctx).size.width * 0.8,
            height: MediaQuery.of(ctx).size.height * 0.6,
            child: MobileScanner(
              controller: controller,
              onDetect: (BarcodeCapture barcode) {
                // Inside your onDetect:
                final String? code = barcode.barcodes.first.rawValue;
                if (code != null) {
                  try {
                    // Parse JSON
                    final Map<String, dynamic> productData = jsonDecode(code);

                    // Extract fields
                    final productId = productData['productId'];
                    final productName = productData['productName'];
                    final price = productData['price'];
                    final qty = productData['qty'];

                    // Pass data back to previous screen
                    Navigator.pop(ctx, {
                      'productId': productId,
                      'productName': productName,
                      'price': price,
                      'qty': qty,
                    });

                    // You could also call a callback or update state with the parsed data
                  } catch (e) {
                    // If scanned code is not valid JSON
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Invalid QR code format')),
                    );
                  }
                }
              },
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.dispose();
              Navigator.pop(ctx);
            },
            child: const Text("Close"),
          ),
        ],
      );
    },
  );
}
