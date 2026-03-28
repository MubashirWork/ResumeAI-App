import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:resume_ai/core/constants/app_colors.dart';
import 'package:resume_ai/data/model/resume_model.dart';
import 'package:resume_ai/data/service/api_service.dart';
import 'package:resume_ai/ui/screens/template_selection/select_template.dart';
import 'package:resume_ai/ui/widgets/app_bar.dart';
import 'package:resume_ai/ui/widgets/app_card.dart';
import 'package:resume_ai/ui/widgets/app_elevated_button.dart';
import 'package:resume_ai/ui/widgets/app_text.dart';
import 'package:resume_ai/ui/widgets/app_text_field.dart';

class ResumeFormScreen extends StatefulWidget {
  final ResumeModel? resume;
  final int? resumeId;

  const ResumeFormScreen({super.key, this.resume, this.resumeId});

  @override
  State<ResumeFormScreen> createState() => _ResumeFormScreenState();
}

class _ResumeFormScreenState extends State<ResumeFormScreen> {
  @override
  void initState() {
    super.initState();

    // Shows stored data for editing a resume
    if (widget.resume != null) {
      fullNameController.text = widget.resume!.name;
      professionTitleController.text = widget.resume!.professionTitle;
      professionalSummaryController.text = widget.resume!.professionalSummary;
      emailController.text = widget.resume!.contact.email;
      phoneNumberController.text = widget.resume!.contact.phone;
      cnicController.text = widget.resume!.contact.cnic;
      countryCityController.text = widget.resume!.contact.location;
      educationController.text = widget.resume!.education.join(', ');
      certificationController.text = widget.resume!.certifications.join(', ');
      experienceController.text = widget.resume!.experience.join(', ');
      professionalSkillsController.text = widget.resume!.professionalSkills
          .join(', ');
      softSkillsController.text = widget.resume!.softSkills.join(', ');
      projectController.text = widget.resume!.projects.join(', ');
      languageController.text = widget.resume!.languages.join(', ');
    }
  }

  // Controllers
  TextEditingController fullNameController = TextEditingController();
  TextEditingController professionTitleController = TextEditingController();
  TextEditingController professionalSummaryController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController cnicController = TextEditingController();
  TextEditingController countryCityController = TextEditingController();
  TextEditingController educationController = TextEditingController();
  TextEditingController certificationController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  TextEditingController professionalSkillsController = TextEditingController();
  TextEditingController softSkillsController = TextEditingController();
  TextEditingController projectController = TextEditingController();
  TextEditingController languageController = TextEditingController();

  bool isLoading = false;
  String? fullNameError;
  String? professionTitleError;
  String? professionalSummaryError;
  String? emailError;
  String? phoneNumberError;
  String? countryCityError;
  String? educationError;
  String? cnicError;

  // Adding data in text fields
  Future addData() async {
    final fullName = fullNameController.text.trim();
    final professionTitle = professionTitleController.text.trim();
    final professionalSummary = professionalSummaryController.text.trim();
    final email = emailController.text.trim();
    final phoneNumber = phoneNumberController.text.trim();
    final cnic = cnicController.text.trim();
    final countryCity = countryCityController.text.trim();
    final education = educationController.text.trim();
    final certification = certificationController.text.trim();
    final experience = experienceController.text.trim();
    final professionalSkills = professionalSkillsController.text.trim();
    final softSkills = softSkillsController.text.trim();
    final project = projectController.text.trim();
    final language = languageController.text.trim();

    if (fullName.isEmpty) {
      setState(() => fullNameError = 'Please enter your name');
      return;
    }

    if (professionTitle.isEmpty) {
      setState(
        () => professionTitleError = 'Please enter your profession title',
      );
      return;
    }

    if (professionalSummary.isEmpty) {
      setState(
        () =>
            professionalSummaryError = 'Please enter your professional summary',
      );
      return;
    }

    if (!email.contains('@') || email.length > 60) {
      setState(() => emailError = 'Please enter your valid email');
      return;
    }

    if (phoneNumber.isEmpty || phoneNumber.length > 15) {
      setState(() => phoneNumberError = 'Please enter your valid phone number');
      return;
    }

    if (countryCity.isEmpty || countryCity.length > 60) {
      setState(
        () => countryCityError =
            'Please enter your correct country and city name',
      );
      return;
    }

    if (cnic.isNotEmpty && cnic.length != 13) {
      setState(() => cnicError = 'Please enter only valid 13 digits');
      return;
    }

    if (education.isEmpty) {
      setState(() => educationError = 'Please enter your education');
      return;
    }

    setState(() => isLoading = true);

    try {
      // Connecting api with fields
      final resumeText = await ApiService.generateResumeFromAI(
        fullName: fullName,
        professionTitle: professionTitle,
        professionalSummary: professionalSummary,
        email: email,
        phoneNumber: phoneNumber,
        cnic: cnic,
        countryCity: countryCity,
        education: education,
        certificates: certification,
        experience: experience,
        professionalSkills: professionalSkills,
        softSkills: softSkills,
        project: project,
        language: language,
      );

      // Converting json to map
      final clean = resumeText.trim();
      final Map<String, dynamic> decode = jsonDecode(clean);

      // Map to object or modal
      final resumeModel = ResumeModel.fromJson(decode);

      setState(() => isLoading = false);

      // Editing a resume
      if (widget.resumeId != null) {
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                SelectTemplate(resume: resumeModel, resumeId: widget.resumeId),
          ),
        );
      } else {
        // For new resumes
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SelectTemplate(resume: resumeModel),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: AppText(
            data: e.toString().replaceFirst('Exception:', ''),
            color: Colors.white,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    professionTitleController.dispose();
    professionalSummaryController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    cnicController.dispose();
    countryCityController.dispose();
    educationController.dispose();
    certificationController.dispose();
    experienceController.dispose();
    professionalSkillsController.dispose();
    softSkillsController.dispose();
    projectController.dispose();
    languageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlueGrey,
      // Bottom button to generate resumes
      bottomNavigationBar: bottomElevatedButton(),
      appBar: const Appbar(
        title: 'Create Your Resume',
        leadingIcon: Icons.arrow_back,
      ),
      body: SafeArea(
        child: Padding(padding: EdgeInsets.all(16), child: content()),
      ),
    );
  }

  // Elevated button
  Widget bottomElevatedButton() {
    return AppElevatedButton(
      onPressed: isLoading ? () {} : () => addData(),
      child: isLoading
          ? const AppText(data: 'Loading ...', weight: FontWeight.w500)
          : const AppText(
              data: 'Generate Resume with AI',
              weight: FontWeight.w500,
            ),
    );
  }

  // Content
  Widget content() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,

            // Title text
            child: const AppText(
              data: 'Fill in your details, let AI to do the magic.',
              size: 16,
              weight: FontWeight.w500,
              align: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          // Full name input field
          AppTextField(
            controller: fullNameController,
            hintText: 'Full Name',
            keyboardType: TextInputType.name,
            errorText: fullNameError,
            onChange: (_) {
              if (fullNameError != null) {
                setState(() => fullNameError = null);
              }
            },
          ),
          const SizedBox(height: 8),
          // Profession title input field
          AppTextField(
            controller: professionTitleController,
            hintText: 'Enter your profession or job title',
            keyboardType: TextInputType.text,
            errorText: professionTitleError,
            onChange: (_) {
              if (professionTitleError != null) {
                setState(() => professionTitleError = null);
              }
            },
          ),
          const SizedBox(height: 8),
          // Professional summary input field
          AppTextField(
            controller: professionalSummaryController,
            hintText: 'Describe yourself in 3-4 sentences.',
            keyboardType: TextInputType.multiline,
            errorText: professionalSummaryError,
            onChange: (_) {
              if (professionalSummaryError != null) {
                setState(() => professionalSummaryError = null);
              }
            },
          ),
          const SizedBox(height: 8),
          // Email input field
          AppTextField(
            controller: emailController,
            hintText: 'Enter email address',
            keyboardType: TextInputType.emailAddress,
            errorText: emailError,
            onChange: (_) {
              if (emailError != null) setState(() => emailError = null);
            },
          ),
          const SizedBox(height: 8),
          // Phone number input field
          AppTextField(
            controller: phoneNumberController,
            hintText: 'Enter phone number',
            keyboardType: TextInputType.phone,
            errorText: phoneNumberError,
            onChange: (_) {
              if (phoneNumberError != null) {
                setState(() => phoneNumberError = null);
              }
            },
          ),
          const SizedBox(height: 8),
          // Cnic input field
          AppTextField(
            controller: cnicController,
            hintText: 'Enter CNIC (optional)',
            keyboardType: TextInputType.number,
            errorText: cnicError,
            onChange: (_) {
              if (cnicError != null) {
                setState(() => cnicError = null);
              }
            },
          ),
          const SizedBox(height: 8),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  data: 'Address',
                  weight: FontWeight.w500,
                  size: 16,
                ),
                const SizedBox(height: 8),
                // Country, city input field
                AppTextField(
                  controller: countryCityController,
                  hintText: 'Enter country & city',
                  keyboardType: TextInputType.text,
                  errorText: countryCityError,
                  onChange: (_) {
                    if (countryCityError != null) {
                      setState(() => countryCityError = null);
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  data: 'Education',
                  weight: FontWeight.w500,
                  size: 16,
                ),
                const SizedBox(height: 8),
                // Education input field
                AppTextField(
                  controller: educationController,
                  hintText: 'Enter education details',
                  keyboardType: TextInputType.text,
                  errorText: educationError,
                  onChange: (_) {
                    if (educationError != null) {
                      setState(() => educationError = null);
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  data: 'Certification',
                  weight: FontWeight.w500,
                  size: 16,
                ),
                const SizedBox(height: 8),
                // Certification input field
                AppTextField(
                  controller: certificationController,
                  hintText: 'Enter certification details (optional)',
                  keyboardType: TextInputType.text,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  data: 'Experience',
                  weight: FontWeight.w500,
                  size: 16,
                ),
                const SizedBox(height: 8),
                // Experience input field
                AppTextField(
                  controller: experienceController,
                  hintText: 'Enter work experience details (optional)',
                  keyboardType: TextInputType.multiline,
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  data: 'Professional Skills',
                  weight: FontWeight.w500,
                  size: 16,
                ),
                const SizedBox(height: 8),
                // Skills input field
                AppTextField(
                  controller: professionalSkillsController,
                  hintText: 'Enter professional skills (optional)',
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 8),
                const AppText(
                  data: 'Soft Skills',
                  weight: FontWeight.w500,
                  size: 16,
                ),
                const SizedBox(height: 8),
                // Other skills input field
                AppTextField(
                  controller: softSkillsController,
                  hintText: 'Enter soft skills (optional)',
                  keyboardType: TextInputType.text,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  data: 'Project',
                  weight: FontWeight.w500,
                  size: 16,
                ),
                const SizedBox(height: 8),
                // Projects input field
                AppTextField(
                  controller: projectController,
                  hintText: 'Enter project details (optional)',
                  keyboardType: TextInputType.multiline,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  data: 'Language',
                  weight: FontWeight.w500,
                  size: 16,
                ),
                const SizedBox(height: 8),
                // Language input field
                AppTextField(
                  controller: languageController,
                  hintText: 'Enter languages (optional)',
                  keyboardType: TextInputType.text,
                  keyboardAction: TextInputAction.done,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
