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

class CleanEdge extends StatelessWidget {
  final ResumeModel resume;
  final int? resumeId;

  const CleanEdge({required this.resume, this.resumeId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Edit button
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: resumeId != null
            ? ElevatedButton(
                onPressed: () {
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
        title: 'Clean Edge',
        leadingIcon: Icons.arrow_back,
      ),
      body: SafeArea(
        child: PdfPreview(
          pdfFileName: '${(resume.name).replaceAll(' ', '_')}_Resume.pdf',
          canChangeOrientation: false,
          canChangePageFormat: false,
          canDebug: false,
          build: (format) => _buildPdf(format, resume),
          loadingWidget: const LoadingScreen(),
        ),
      ),
    );
  }
}

// Adding data inside pdf file
Future<Uint8List> _buildPdf(PdfPageFormat format, ResumeModel resume) {
  // Creating pdf file
  final pdf = pw.Document();

  // Adding pages to pdf file
  pdf.addPage(
    pw.MultiPage(
      margin: const pw.EdgeInsets.all(32),
      pageFormat: format,
      build: (context) {
        return [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Title name
              PdfAppText(
                data: resume.name,
                fontFamily: AppPdfFonts.interBold,
                size: resume.name.length > 25 ? 25 : 30,
                letterSpacing: 0.5,
                lineHeight: 1.2,
                color: PdfColor.fromInt(0xFF2F5D73),
              ).build(),

              pw.SizedBox(height: 8),

              // Profession title
              PdfAppText(
                data: resume.professionTitle,
                fontFamily: AppPdfFonts.interExtraBold,
                size: 20,
                lineHeight: 1.1,
                color: PdfColor.fromInt(0xFF2F5D73),
              ).build(),

              pw.SizedBox(height: 18),

              // Contact detail
              PdfAppText(
                data:
                    '${resume.contact.email}   |   ${resume.contact.phone}   |   ${resume.contact.location}   ${resume.contact.cnic.isEmpty ? '' : '   |   ${resume.contact.cnic}'}',
                fontFamily: AppPdfFonts.interMedium,
                size: 14.5,
                lineHeight: 5,
                letterSpacing: 0.5,
              ).build(),

              /// Sections

              // Professional summary
              _section('PROFESSIONAL SUMMARY', resume.professionalSummary),
              _section('PROFESSIONAL EXPERIENCE', ListFormater.addEndingPeriod(resume.experience)),
              _section('EDUCATION', ListFormater.addEndingPeriod(resume.education)),
              _section('CERTIFICATIONS', ListFormater.addEndingPeriod(resume.certifications)),
              _section(
                'PROFESSIONAL SKILLS',
                resume.professionalSkills.join(',  '),
              ),
              _section('SOFT SKILLS', resume.softSkills.join(',  ')),
              _section('PROJECTS', ListFormater.addEndingPeriod(resume.projects)),
              _section('LANGUAGES', resume.languages.join(',  ')),
            ],
          ),
        ];
      },
    ),
  );
  return pdf.save();
}

// Section detail
pw.Widget _section(String title, String? content) {
  if (content != null && content.trim().isNotEmpty) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 18),
        PdfAppText(
          data: title.toUpperCase(),
          fontFamily: AppPdfFonts.interExtraBold,
          size: 16,
          letterSpacing: 1.2,
          color: PdfColor.fromInt(0xFF2F5D73),
        ).build(),
        pw.SizedBox(
          width: double.infinity,
          child: pw.Divider(
            height: 2,
            thickness: 1.2,
            color: PdfColor.fromInt(0xFF2F5D73),
          ),
        ),
        pw.SizedBox(height: 12),
        PdfAppText(
          data: content,
          fontFamily: AppPdfFonts.interMedium,
          size: 14.5,
          letterSpacing: 1.65,
          lineHeight: 1.4,
        ).build(),
      ],
    );
  } else {
    return pw.SizedBox();
  }
}
