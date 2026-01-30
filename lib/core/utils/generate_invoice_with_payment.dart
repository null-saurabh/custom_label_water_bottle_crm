import 'package:clwb_crm/screens/client/models/client_model.dart';
import 'package:clwb_crm/screens/orders/models/order_model.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

class OrderInvoiceWithPaymentPdfService {
  static Future<void> generate({
    required OrderModel order,
    required ClientModel client,
  }) async {
    final pdf = pw.Document();

    // ======================
    // LOAD FONTS (₹ SAFE)
    // ======================
    final regularFont = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Roboto-Regular.ttf'),
    );
    final boldFont = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Roboto-Bold.ttf'),
    );

    // ======================
    // LOAD LOGO
    // ======================
    final Uint8List logoBytes =
    (await rootBundle.load('assets/icons/main_logo.png'))
        .buffer
        .asUint8List();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        theme: pw.ThemeData.withFont(
          base: regularFont,
          bold: boldFont,
        ),
        build: (_) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [

              // ======================
              // HEADER
              // ======================
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      pw.Image(
                        pw.MemoryImage(logoBytes),
                        height: 72,
                      ),
                      pw.Text(
                        'Ink & Drink',
                        style: pw.TextStyle(
                          fontSize: 20,
                          fontWeight: pw.FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                  pw.Text(
                    'INVOICE',
                    style: pw.TextStyle(
                      fontSize: 26,
                      fontWeight: pw.FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),

              pw.SizedBox(height: 12),

              pw.Container(
                height: 6,
                color: PdfColors.amber,
              ),

              pw.SizedBox(height: 24),

              // ======================
              // FROM / TO
              // ======================
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [

                  // FROM
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Invoice From:',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text('Ink & Drink'),
                      pw.Text(
                        'Raja Bazzar, Sheikhpura,\nBailey Road, Patna – 800014',
                      ),
                      pw.Text('Phone: 9507446457'),
                    ],
                  ),

                  // TO
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Invoice To:',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(client.businessName),
                      pw.Text(
                        client.locations.isNotEmpty
                            ? client.locations.first.address
                            : '—',
                      ),
                      pw.Text('Phone: ${client.phone}'),
                    ],
                  ),
                ],
              ),

              pw.SizedBox(height: 24),

              // ======================
              // META
              // ======================
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Invoice #: ${order.orderNumber}'),
                  pw.Text(
                    'Date: ${_formatDate(order.createdAt)}',
                  ),
                ],
              ),

              pw.SizedBox(height: 20),

              // ======================
              // TABLE
              // ======================
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey400),
                columnWidths: const {
                  0: pw.FlexColumnWidth(4),
                  1: pw.FlexColumnWidth(1),
                  2: pw.FlexColumnWidth(1),
                  3: pw.FlexColumnWidth(1),
                },
                children: [
                  _headerRow(),
                  _dataRow(
                    order.itemNameSnapshot,
                    order.orderedQuantity,
                    order.ratePerBottle,
                    order.totalAmount,
                  ),
                ],
              ),

              pw.SizedBox(height: 20),

              // ======================
              // TOTAL
              // ======================

              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Thank you for your business',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 14

                    ),
                  ),
                  // ======================
// AMOUNT SUMMARY (UI MATCH)
// ======================
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [

                      // ---------- Subtotal & Paid (narrow) ----------
                      pw.Container(
                        width: 200,
                        child: pw.Column(
                          children: [
                            _amountLine(
                              'Sub Total:',
                              order.totalAmount,
                            ),
                            pw.SizedBox(height: 8),
                            _amountLine(
                              'Paid:',
                              order.paidAmount,
                            ),
                          ],
                        ),
                      ),

                      pw.SizedBox(height: 16),

                      // ---------- Yellow Total Bar (wide) ----------
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(right: -32), // 👈 cancels page margin
                        child: pw.Row(
                          children: [
                            // Text column (same alignment as subtotal/paid)
                            pw.Container(
                              width: 264,
                              color: PdfColors.amber,
                              padding: const pw.EdgeInsets.symmetric(
                                vertical: 10,
                                // horizontal: 6,
                              ),
                              child: pw.Padding(
                                padding: const pw.EdgeInsets.only(right: 32,left: 32), // 👈 cancels page margin
                                child: pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                children: [
                                  pw.Text(
                                    'Total Due',
                                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                                  ),
                                  pw.Text(
                                    '₹${order.dueAmount.toStringAsFixed(2)}',
                                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                                  ),
                                ],
                              ),),
                            ),

                            // Yellow stretch to page edge
                            pw.Container(
                                height: 32,
                                color: PdfColors.amber,

                            ),
                          ],
                        ),
                      ),

                    ],
                  ),










//                  pw.Container(
//                       width: 200,
//                       child: pw.Column(
//                         children: [
//
//                           // Subtotal
//                           _amountLine(
//                             'Sub Total:',
//                             order.totalAmount,
//                           ),
//
//                           pw.SizedBox(height: 8),
//
//                           // Paid
//                           _amountLine(
//                             'Paid:',
//                             order.paidAmount,
//                           ),
//
//                           pw.SizedBox(height: 16),
//
//                           // Total Due (highlighted)
//                           pw.Container(
//                             width: double.infinity,
//                             padding: const pw.EdgeInsets.symmetric(
//                               vertical: 8,
//                               horizontal: 6,
//                             ),
//                             color: PdfColors.amber,
//                             child: pw.Row(
//                               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                               children: [
//                                 pw.Text(
//                                   'Total Due',
//                                   style: pw.TextStyle(
//                                     fontWeight: pw.FontWeight.bold,
//                                   ),
//                                 ),
//                                 pw.Text(
//                                   '₹${order.dueAmount.toStringAsFixed(2)}',
//                                   style: pw.TextStyle(
//                                     fontWeight: pw.FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//
//                   ),

                ],
              ),






              pw.SizedBox(height: 48),

              // ======================
              // PAYMENT INFO
              // ======================
              pw.Text(
                'Payment Info:',
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 14
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text('Account No:      37736425527'),
              pw.SizedBox(height: 1),
              pw.Text('A/C Name:        Saurabh Kumar'),
              pw.SizedBox(height: 1),
              pw.Text('Bank:                  State Bank Of India'),
              pw.SizedBox(height: 1),
              pw.Text('UPI ID:                sk2kishuben102@ybl'),

              // pw.Spacer(),

              // ======================
              // FOOTER
              // ======================

            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  // ======================
  // HELPERS
  // ======================

  static pw.TableRow _headerRow() {
    return pw.TableRow(
      decoration: const pw.BoxDecoration(
        color: PdfColors.grey300,
      ),
      children: [
        _cell('Item Description', bold: true),
        _cell('Qty', bold: true),
        _cell('Rate', bold: true),
        _cell('Total', bold: true),
      ],
    );
  }

  static pw.TableRow _dataRow(
      String item,
      int qty,
      double rate,
      double total,
      ) {
    return pw.TableRow(
      children: [
        _cell(item),
        _cell(qty.toString()),
        _cell('₹${rate.toStringAsFixed(2)}'),
        _cell('₹${total.toStringAsFixed(2)}'),
      ],
    );
  }

  static pw.Widget _cell(
      String text, {
        bool bold = false,
      }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontWeight:
          bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  static pw.Widget _amountLine(
      String label,
      double value,
      ) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(label),
        pw.Text('₹${value.toStringAsFixed(2)}'),
      ],
    );
  }


  static String _formatDate(DateTime d) {
    return '${d.day}/${d.month}/${d.year}';
  }
}
