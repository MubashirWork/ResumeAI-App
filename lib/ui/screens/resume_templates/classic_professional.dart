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
import 'package:resume_ai/ui/widgets/pdf_widgets/pdf_app_text.dart' as pw;

class ClassicProfessional extends StatelessWidget {
  final ResumeModel resume;
  final int? resumeId;

  const ClassicProfessional({required this.resume, this.resumeId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: resumeId != null
            ?
              // Edit button
              ElevatedButton(
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
        title: 'Classic Professional',
        leadingIcon: Icons.arrow_back,
      ),
      body: SafeArea(
        // Previewing pdf
        child: PdfPreview(
          pdfFileName: "${(resume.name).replaceAll(' ', '_')}_Resume.pdf",
          canDebug: false,
          canChangePageFormat: false,
          canChangeOrientation: false,
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
  final pw.Document pdf = pw.Document();

  // Adding pages
  pdf.addPage(
    pw.MultiPage(
      margin: const pw.EdgeInsets.all(32),
      pageFormat: format,
      build: (context) {
        return [
          pw.Column(
            children: [
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.PdfAppText(
                      data: resume.name,
                      fontFamily: AppPdfFonts.playfairDisplay,
                      size: resume.name.length > 25 ? 25 : 30,
                      align: pw.TextAlign.center,
                      letterSpacing: 1.5,
                    ).build(),
                    pw.SizedBox(height: 16),
                    pw.PdfAppText(
                      data: resume.professionTitle,
                      fontFamily: AppPdfFonts.montserratMedium,
                      size: 14,
                      align: pw.TextAlign.center,
                      letterSpacing: 2.5,
                    ).build(),
                  ],
                ),
              ),
              pw.SizedBox(height: 16),
              pw.Divider(height: 1, thickness: 1),
              pw.SizedBox(height: 16),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                children: [
                  pw.Column(
                    children: [
                      _contact(resume.contact.email),
                      pw.SizedBox(height: 8),
                      _contact(resume.contact.location),
                    ],
                  ),
                  pw.SizedBox(
                    height: 32,
                    child: pw.VerticalDivider(thickness: 1),
                  ),
                  pw.Column(
                    children: [
                      _contact(resume.contact.phone),
                      pw.SizedBox(height: 8),
                      _contact(resume.contact.cnic),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 16),
              pw.Divider(height: 1, thickness: 1),
              _section('PROFESSIONAL SUMMARY', resume.professionalSummary),
              _section('EXPERIENCE', ListFormater.addEndingPeriod(resume.experience)),
              _section('EDUCATION', ListFormater.addEndingPeriod(resume.education)),
              _section('CERTIFICATION', ListFormater.addEndingPeriod(resume.certifications)),
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

// Contact section
pw.Widget _contact(String text) {
  return pw.PdfAppText(data: text, size: 14).build();
}

// Other sections
pw.Widget _section(String title, String? content) {
  if (content != null && content.trim().isNotEmpty) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 16),
        pw.PdfAppText(
          data: title.toUpperCase(),
          fontFamily: AppPdfFonts.montserratBold,
          size: 15,
          letterSpacing: 1.2,
        ).build(),
        pw.SizedBox(height: 8),
        pw.Divider(height: 1, thickness: 1),
        pw.SizedBox(height: 16),
        pw.PdfAppText(
          data: content,
          fontFamily: AppPdfFonts.montserratMedium,
          size: 14,
          lineHeight: 1.5,
        ).build(),
      ],
    );
  } else {
    return pw.SizedBox(height: 0);
  }
}
