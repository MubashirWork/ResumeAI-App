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

class SimpleClean extends StatelessWidget {
  final ResumeModel resume;
  final int? resumeId;

  const SimpleClean({required this.resume, this.resumeId, super.key});

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
        title: 'Simple Clean',
        leadingIcon: Icons.arrow_back,
      ),
      body: SafeArea(
        // Previewing pdf
        child: PdfPreview(
          pdfFileName: '${(resume.name).replaceAll(" ", "_")}_Resume.pdf',
          canChangeOrientation: false,
          canDebug: false,
          canChangePageFormat: false,
          build: (format) => _buildPdf(format, resume),
          loadingWidget: const LoadingScreen(),
        ),
      ),
    );
  }
}

// Method to create pdf file and adds data
Future<Uint8List> _buildPdf(PdfPageFormat format, ResumeModel resume) {
  final pdf = pw.Document();
  pdf.addPage(
    // Creates multiple pages
    pw.MultiPage(
      margin: const pw.EdgeInsets.all(32),
      pageFormat: format,
      build: (context) {
        return [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              PdfAppText(
                data: resume.name,
                size: resume.name.length > 25 ? 25 : 28,
                fontFamily: AppPdfFonts.montserratBold,
                letterSpacing: 1.2,
              ).build(),
              pw.SizedBox(height: 8),
              PdfAppText(
                data: resume.professionTitle,
                size: 16,
                fontFamily: AppPdfFonts.montserratBold,
                letterSpacing: 0.5,
              ).build(),
              pw.SizedBox(height: 12),
              pw.Divider(thickness: 1),
              pw.SizedBox(height: 12),
              _contact(
                resume.contact.phone.isNotEmpty
                    ? 'Phone:  ${resume.contact.phone}'
                    : '',
              ),
              _contact(
                resume.contact.email.isNotEmpty
                    ? 'Email:  ${resume.contact.email}'
                    : '',
              ),
              _contact(
                resume.contact.cnic.isNotEmpty
                    ? 'Cnic:  ${resume.contact.cnic}'
                    : '',
              ),
              _contact(
                resume.contact.location.isNotEmpty
                    ? 'Address:  ${resume.contact.location}'
                    : '',
              ),
              _section('PROFILE', resume.professionalSummary),
              _section('EDUCATION', ListFormater.addEndingPeriod(resume.education)),
              _section('PROJECTS', ListFormater.addEndingPeriod(resume.projects)),
              _section('EXPERIENCE', ListFormater.addEndingPeriod(resume.experience)),
              _section('CERTIFICATES', ListFormater.addEndingPeriod(resume.certifications)),
              _section('LANGUAGES', resume.languages.join(',  ')),
              pw.SizedBox(height: 12),
              pw.Divider(thickness: 1),
              pw.SizedBox(height: 6),
              pw.Row(
                children: [
                  resume.professionalSkills.isNotEmpty
                      ? pw.Expanded(
                          child: _otherSection(
                            'PROFESSIONAL SKILLS',
                            resume.professionalSkills.join(',  '),
                          ),
                        )
                      : pw.Expanded(
                          child: _otherSection(
                            'SOFT SKILLS',
                            resume.softSkills.join(',  '),
                          ),
                        ),

                  resume.professionalSkills.isNotEmpty &&
                          resume.softSkills.isNotEmpty
                      ? pw.SizedBox(
                          width: 100,
                          height: 60,
                          child: pw.VerticalDivider(),
                        )
                      : pw.SizedBox(height: 0),
                  resume.professionalSkills.isNotEmpty
                      ? pw.Expanded(
                          child: _otherSection(
                            'SOFT SKILLS',
                            resume.softSkills.join(',  '),
                          ),
                        )
                      : pw.SizedBox(height: 0),
                ],
              ),
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
  if (text.isNotEmpty) {
    return pw.Column(
      children: [
        PdfAppText(
          data: text,
          fontFamily: AppPdfFonts.montserratMedium,
          size: 14,
          lineHeight: 1.6,
        ).build(),
        pw.SizedBox(height: 6),
      ],
    );
  } else {
    return pw.SizedBox(height: 0);
  }
}

// Main sections
pw.Widget _section(String title, String? content) {
  if (content != null && content.trim().isNotEmpty) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 12),
        pw.Divider(thickness: 1),
        pw.SizedBox(height: 6),
        PdfAppText(
          data: title,
          size: 15,
          fontFamily: AppPdfFonts.montserratBold,
        ).build(),
        pw.SizedBox(height: 8),
        PdfAppText(
          data: content,
          size: 14,
          fontFamily: AppPdfFonts.montserratMedium,
          lineHeight: 1.6,
        ).build(),
      ],
    );
  } else {
    return pw.SizedBox(height: 0);
  }
}

// Last section
pw.Widget _otherSection(String title, String? content) {
  if (content != null && content.trim().isNotEmpty) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        PdfAppText(
          data: title,
          size: 15,
          fontFamily: AppPdfFonts.montserratBold,
        ).build(),
        pw.SizedBox(height: 8),
        PdfAppText(
          data: content,
          size: 14,
          fontFamily: AppPdfFonts.montserratMedium,
          lineHeight: 1.6,
        ).build(),
      ],
    );
  } else {
    return pw.SizedBox(height: 0);
  }
}
