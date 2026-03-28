import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:resume_ai/core/constants/app_pdf_fonts.dart';
import 'package:resume_ai/core/constants/list_formater.dart';
import 'package:resume_ai/data/model/resume_model.dart';
import 'package:resume_ai/ui/screens/form/resume_form_screen.dart';
import 'package:resume_ai/ui/screens/loading/loading_screen.dart';
import 'package:resume_ai/ui/widgets/app_bar.dart';
import 'package:resume_ai/ui/widgets/app_text.dart';
import 'package:resume_ai/ui/widgets/pdf_widgets/pdf_app_text.dart';

class MidnightResume extends StatelessWidget {
  final ResumeModel resume;
  final int? resumeId;

  const MidnightResume({required this.resume, this.resumeId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Edit button
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: resumeId != null
            ? ElevatedButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ResumeFormScreen(resume: resume, resumeId: resumeId),
                    ),
                  );
                },
                child: const AppText(data: 'Edit'),
              )
            : null,
      ),
      appBar: const Appbar(
        title: 'Midnight Resume',
        leadingIcon: Icons.arrow_back,
      ),
      body: SafeArea(
        child: PdfPreview(
          pdfFileName: '${(resume.name).replaceAll(" ", "_")}_Resume.pdf',
          canDebug: false,
          canChangeOrientation: false,
          canChangePageFormat: false,
          build: (format) => _buildPdf(format, resume),
          loadingWidget: const LoadingScreen(),
        ),
      ),
    );
  }
}

// Adding data on pdf pages
Future<Uint8List> _buildPdf(PdfPageFormat format, ResumeModel resume) {
  // Pdf file creation
  final pdf = pw.Document();

  // Adding pages
  pdf.addPage(
    pw.MultiPage(
      margin: pw.EdgeInsets.zero,
      pageFormat: format,
      build: (context) {
        return [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                padding: pw.EdgeInsets.symmetric(horizontal: 48, vertical: 32),
                color: PdfColor.fromInt(0xFF1C1C1C),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    PdfAppText(
                      data: resume.name,
                      fontFamily: AppPdfFonts.robotoBold,
                      size: resume.name.length > 25 ? 25 : 30,
                      letterSpacing: 0.3,
                      color: PdfColors.white,
                    ).build(),

                    pw.SizedBox(height: 8),

                    PdfAppText(
                      data: resume.professionTitle,
                      fontFamily: AppPdfFonts.robotoBold,
                      size: 20,
                      letterSpacing: 0.3,
                      color: PdfColors.white,
                    ).build(),

                    pw.SizedBox(height: 18),

                    // Contact information
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        PdfAppText(
                          data: resume.contact.email,
                          color: PdfColors.white,
                          fontFamily: AppPdfFonts.robotoMedium,
                        ).build(),
                        PdfAppText(
                          data: resume.contact.phone,
                          color: PdfColors.white,
                          fontFamily: AppPdfFonts.robotoMedium,
                        ).build(),
                      ],
                    ),

                    pw.SizedBox(height: 8),

                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        PdfAppText(
                          data: resume.contact.location,
                          color: PdfColors.white,
                          fontFamily: AppPdfFonts.robotoMedium,
                          size: 14,
                        ).build(),
                        PdfAppText(
                          data: resume.contact.cnic,
                          color: PdfColors.white,
                          fontFamily: AppPdfFonts.robotoMedium,
                          size: 14,
                        ).build(),
                      ],
                    ),
                  ],
                ),
              ),

              /// Sections

              // Profile section
              _section('Profile', resume.professionalSummary),
              _section('Professional Experience', ListFormater.addEndingPeriod(resume.experience)),
              _section('Education', ListFormater.addEndingPeriod(resume.education)),
              _section(
                'Professional Skills',
                resume.professionalSkills.join(',  '),
              ),
              _section('Soft Skills', resume.softSkills.join(',  ')),
              _section('Certificates', ListFormater.addEndingPeriod(resume.certifications)),
              _section('Projects', ListFormater.addEndingPeriod(resume.projects)),
              _section('Languages', resume.languages.join(',  ')),
            ],
          ),
        ];
      },
    ),
  );
  return pdf.save();
}

// section method
pw.Widget _section(String title, String? content) {
  if (content != null && content.trim().isNotEmpty) {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(horizontal: 48),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(height: 18),
          PdfAppText(
            data: title,
            fontFamily: AppPdfFonts.robotoBold,
            size: 18,
            letterSpacing: 0.3,
          ).build(),
          pw.SizedBox(height: 8),
          PdfAppText(
            data: content,
            fontFamily: AppPdfFonts.robotoMedium,
            size: 14,
            lineHeight: 1.6,
          ).build(),
        ],
      ),
    );
  } else {
    return pw.SizedBox();
  }
}
