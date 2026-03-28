import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:resume_ai/core/constants/app_pdf_fonts.dart';
import 'package:resume_ai/core/constants/list_formater.dart';
import 'package:resume_ai/data/model/resume_model.dart';
import 'package:resume_ai/ui/screens/form/resume_form_screen.dart';
import 'package:resume_ai/ui/screens/loading/loading_screen.dart';
import 'package:resume_ai/ui/widgets/app_bar.dart';
import 'package:resume_ai/ui/widgets/app_text.dart';
import 'package:resume_ai/ui/widgets/pdf_widgets/pdf_app_text.dart';
import 'package:pdf/widgets.dart' as pw;

class ModernMinimal extends StatelessWidget {
  final ResumeModel resume;
  final int? resumeId;

  const ModernMinimal({required this.resume, this.resumeId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Edit button
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: resumeId != null ? ElevatedButton(
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResumeFormScreen(resume: resume, resumeId: resumeId,),
              ),
            );
          },
          child: const AppText(data: 'Edit'),
        ) : null,
      ),
      appBar: const Appbar(title: 'Modern Minimal', leadingIcon: Icons.arrow_back,),
      body: PdfPreview(
        pdfFileName: '${(resume.name).replaceAll(" ", "_")}_Resume.pdf',
        canChangeOrientation: false,
        canChangePageFormat: false,
        canDebug: false,
        build: (format) => _buildPdf(format, resume),
        loadingWidget: const LoadingScreen(),
      ),
    );
  }
}


// Pdf building method
Future<Uint8List> _buildPdf(PdfPageFormat format, ResumeModel resume) {

  // Building pdf file
  final pdf = pw.Document();

  // Adding pages to pdf file
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
                    // Header name
                    PdfAppText(
                      data: resume.name,
                      fontFamily: AppPdfFonts.montserratBold,
                      size: resume.name.length > 25 ? 25 : 30,
                      letterSpacing: 4,
                    ).build(),

                    pw.SizedBox(height: 14),

                    // Job title
                    PdfAppText(
                      data: resume.professionTitle,
                      fontFamily: AppPdfFonts.montserratBold,
                      size: 18,
                      letterSpacing: 2,
                    ).build(),
                  ],
                ),
              ),

              pw.SizedBox(height: 14),

              // Contact information
              PdfAppText(
                data:
                '${resume.contact.phone}   |   ${resume.contact.email}${resume.contact.cnic.isNotEmpty ?'   |   ${resume.contact.cnic}' : ''}   |   ${resume.contact.location}',
                fontFamily: AppPdfFonts.montserratMedium,
                size: 14,
                lineHeight: 5,
              ).build(),

              // Sections
              _section('ABOUT ME', resume.professionalSummary),
              _section(
                'PROFESSIONAL EXPERIENCE',
                ListFormater.addEndingPeriod(resume.experience),
              ),
              _section('EDUCATION', ListFormater.addEndingPeriod(resume.education)),
              _section('PROFESSIONAL SKILLS', resume.professionalSkills.join(',  ')),
              _section('SOFT SKILLS', resume.softSkills.join(',  ')),
              _section('PROJECTS', ListFormater.addEndingPeriod(resume.projects)),
              _section(
                'LANGUAGES',
                resume.languages.join(',  '),
              ),
            ],
          ),
        ];
      },
    ),
  );

  return pdf.save();
}

// Pdf file section function
pw.Widget _section(String title, String? content) {
  if (content != null && content.trim().isNotEmpty) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 22),
        pw.Container(
          padding: pw.EdgeInsets.symmetric(vertical: 10),
          decoration: pw.BoxDecoration(
            color: PdfColor.fromInt(0xFFEBF0F8),
            borderRadius: pw.BorderRadius.circular(6),
          ),
          width: double.infinity,
          child: PdfAppText(
            data: title.toUpperCase(),
            fontFamily: AppPdfFonts.montserratBold,
            size: 16,
            letterSpacing: 1.5,
            align: pw.TextAlign.center,
          ).build(),
        ),
        pw.SizedBox(height: 12),
        PdfAppText(
          data: content,
          fontFamily: AppPdfFonts.montserratMedium,
          size: 14,
          lineHeight: 1.8,
        ).build(),
      ],
    );
  } else {
    return pw.SizedBox();
  }
}
