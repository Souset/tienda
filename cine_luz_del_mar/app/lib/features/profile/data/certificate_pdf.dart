import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../core/utils/formatters.dart';
import '../../../shared/models/models.dart';

/// Genera el certificado en PDF con la identidad monocroma de la asociación
/// y abre el diálogo de compartir/imprimir del sistema.
///
/// Se genera íntegramente en el dispositivo (sin servidor). Las fuentes de
/// marca se descargan de Google Fonts; si no hay red se usa la tipografía
/// estándar del PDF.
Future<void> shareCertificatePdf({
  required Certificate certificate,
  required String userName,
}) async {
  pw.Font? script;
  pw.Font? serif;
  pw.Font? serifBold;
  try {
    script = await PdfGoogleFonts.pinyonScriptRegular();
    serif = await PdfGoogleFonts.playfairDisplayRegular();
    serifBold = await PdfGoogleFonts.playfairDisplayBold();
  } catch (error) {
    debugPrint('Fuentes del certificado no disponibles: $error');
  }

  final issued = certificate.issuedAt ?? DateTime.now();
  final document = pw.Document(title: certificate.title);

  document.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4.landscape,
      build: (context) => pw.Container(
        color: PdfColors.black,
        padding: const pw.EdgeInsets.all(24),
        child: pw.Container(
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.white, width: 1.2),
          ),
          padding: const pw.EdgeInsets.symmetric(horizontal: 48, vertical: 40),
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text(
                'Cine Luz del Mar',
                style: pw.TextStyle(
                  font: script,
                  fontSize: 44,
                  color: PdfColors.white,
                ),
              ),
              pw.SizedBox(height: 6),
              pw.Text(
                'ASOCIACIÓN CULTURAL',
                style: pw.TextStyle(
                  font: serif,
                  fontSize: 10,
                  letterSpacing: 4,
                  color: PdfColors.grey400,
                ),
              ),
              pw.SizedBox(height: 34),
              pw.Text(
                'Certifica que',
                style: pw.TextStyle(
                  font: serif,
                  fontSize: 14,
                  color: PdfColors.grey300,
                ),
              ),
              pw.SizedBox(height: 12),
              pw.Text(
                userName,
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  font: serifBold,
                  fontSize: 30,
                  color: PdfColors.white,
                ),
              ),
              pw.SizedBox(height: 18),
              pw.Text(
                certificate.title,
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  font: serif,
                  fontSize: 16,
                  color: PdfColors.grey200,
                ),
              ),
              pw.SizedBox(height: 34),
              pw.Container(width: 180, height: 0.8, color: PdfColors.grey600),
              pw.SizedBox(height: 14),
              pw.Text(
                Formatters.fullDate.format(issued),
                style: pw.TextStyle(
                  font: serif,
                  fontSize: 11,
                  color: PdfColors.grey400,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  await Printing.sharePdf(
    bytes: await document.save(),
    filename:
        'certificado-cine-luz-del-mar-${issued.year}'
        '${issued.month.toString().padLeft(2, '0')}.pdf',
  );
}
