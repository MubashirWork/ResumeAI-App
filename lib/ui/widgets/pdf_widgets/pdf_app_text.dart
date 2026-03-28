import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

// Custom pdf text
class PdfAppText {

  final String data;
  final PdfColor color;
  final double size;
  final pw.TextAlign align;
  final pw.Font? fontFamily;
  final double? letterSpacing;
  final double? lineHeight;

  const PdfAppText({
    required this.data,
    this.color = PdfColors.black,
    this.size = 14,
    this.align = pw.TextAlign.start,
    this.fontFamily,
    this.letterSpacing,
    this.lineHeight,
  });

  pw.Widget build() {
    return pw.Text(
      data,
      style: pw.TextStyle(
        color: color,
        fontSize: size,
        font: fontFamily,
        letterSpacing: letterSpacing,
        lineSpacing: lineHeight,
      ),
      textAlign: align,
    );
  }
}
