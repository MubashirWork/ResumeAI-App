// App pdf google fonts
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

class AppPdfFonts {

  static late Font playfairDisplay;
  static late Font montserratMedium;
  static late Font montserratBold;
  static late Font interBold;
  static late Font interMedium;
  static late Font interExtraBold;
  static late Font robotoBold;
  static late Font robotoMedium;

  static Future load() async {
    playfairDisplay = await PdfGoogleFonts.playfairDisplaySemiBold();
    montserratMedium = await PdfGoogleFonts.montserratMedium();
    montserratBold = await PdfGoogleFonts.montserratSemiBold();
    interBold = await PdfGoogleFonts.interSemiBold();
    interMedium = await PdfGoogleFonts.interMedium();
    interExtraBold = await PdfGoogleFonts.interExtraBold();
    robotoBold = await PdfGoogleFonts.robotoBold();
    robotoMedium = await PdfGoogleFonts.robotoMedium();
  }

}
