// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skoop/constant.dart';

class TermsAndConditionsScreenUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Terms and Conditions',
          style: GoogleFonts.manrope(color: kWhite),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Skoop User Terms and Conditions',
              style: GoogleFonts.manrope(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              'These Terms and Conditions ("Agreement") constitute a legally binding agreement between Skoop Inc. ("Skoop," "we," "us," or "our") and you, the Skoop User ("you" or "your"). By using the Skoop app, you agree to comply with and be bound by these Terms and Conditions. If you do not agree with these terms, please do not use the Skoop app.',
              style: GoogleFonts.manrope(fontSize: 16.0),
            ),
            const SizedBox(height: 20.0),
            Text(
              '1. Providing Accurate Information',
              style: GoogleFonts.manrope(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              '1.1 You agree to provide accurate and up-to-date information during the registration process and to promptly update any changes to your information.',
              style: GoogleFonts.manrope(fontSize: 16.0),
            ),
            Text(
              '1.2 You must be a currently enrolled student with a valid student ID in order to use the Skoop app.',
              style: GoogleFonts.manrope(fontSize: 16.0),
            ),
            const SizedBox(height: 20.0),
            Text(
              '2. Personal Data Privacy',
              style: GoogleFonts.manrope(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              '2.1 Skoop takes your privacy seriously and is committed to protecting your personal information. Your data is processed in accordance with our Privacy Policy.',
              style: GoogleFonts.manrope(fontSize: 16.0),
            ),
            Text(
              '2.2 You consent to Skoop collecting and using your personal and location data for the purpose of operating and improving the Skoop app.',
              style: GoogleFonts.manrope(fontSize: 16.0),
            ),
            const SizedBox(height: 20.0),
            Text(
              '3. Data Usage and Tracking',
              style: GoogleFonts.manrope(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              '3.1 Skoop may use your data to provide you with personalized recommendations, optimize your app experience, and track app usage statistics.',
              style: GoogleFonts.manrope(fontSize: 16.0),
            ),
            Text(
              '3.2 Skoop will only use your personal data for the purpose of providing you with services related to the app and will not share your data with third parties without your consent.',
              style: GoogleFonts.manrope(fontSize: 16.0),
            ),
            const SizedBox(height: 20.0),
            Text(
              '4. School API Usage',
              style: GoogleFonts.manrope(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              '4.1 Skoop may integrate with school APIs to provide you with convenient features related to your campus and student status.',
              style: GoogleFonts.manrope(fontSize: 16.0),
            ),
            Text(
              '4.2 You acknowledge that the use of school APIs is for the exclusive benefit of the Skoop app and its users.',
              style: GoogleFonts.manrope(fontSize: 16.0),
            ),
            const SizedBox(height: 20.0),
            Text(
              '5. Acceptance of Orders',
              style: GoogleFonts.manrope(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              '5.1 By placing an order through the Skoop app, you acknowledge and agree to fulfill the order within the specified timeframe.',
              style: GoogleFonts.manrope(fontSize: 16.0),
            ),
            Text(
              '5.2 Skoop reserves the right to cancel or reject orders if your student status or other information cannot be verified.',
              style: GoogleFonts.manrope(fontSize: 16.0),
            ),
            const SizedBox(height: 20.0),
            Text(
              '6. Payments',
              style: GoogleFonts.manrope(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              '6.1 You agree to pay for orders placed through the Skoop app in accordance with the pricing and payment methods specified in the app.',
              style: GoogleFonts.manrope(fontSize: 16.0),
            ),
            Text(
              '6.2 Skoop is not responsible for any additional charges or fees that may be applied by your school or payment provider.',
              style: GoogleFonts.manrope(fontSize: 16.0),
            ),
            const SizedBox(height: 20.0),
            Text(
              '7. Termination',
              style: GoogleFonts.manrope(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              '7.1 Skoop reserves the right to suspend or terminate your access to the app in case of violations of these Terms and Conditions.',
              style: GoogleFonts.manrope(fontSize: 16.0),
            ),
            Text(
              '7.2 You may terminate this Agreement at any time by ceasing to use the Skoop app.',
              style: GoogleFonts.manrope(fontSize: 16.0),
            ),
            const SizedBox(height: 20.0),
            Text(
              '8. Governing Law',
              style: GoogleFonts.manrope(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              '8.1 This Agreement shall be governed by and construed in accordance with the laws of [Your Jurisdiction], without regard to its conflict of law principles.',
              style: GoogleFonts.manrope(fontSize: 16.0),
            ),
            const SizedBox(height: 20.0),
            Text(
              '9. Amendments',
              style: GoogleFonts.manrope(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              '9.1 Skoop reserves the right to amend these Terms and Conditions at any time. Any changes will be communicated to you through the app or via email.',
              style: GoogleFonts.manrope(fontSize: 16.0),
            ),
            const SizedBox(height: 20.0),
            Text(
              'By using the Skoop app, you acknowledge that you have read, understood, and agree to abide by these Terms and Conditions.',
              style: GoogleFonts.manrope(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
