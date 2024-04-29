import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skoop/constant.dart';

class TermsAndConditionsScreenSkooper extends StatelessWidget {
  const TermsAndConditionsScreenSkooper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
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
              'Skoop Driver (Skooper) Terms and Conditions',
              style: GoogleFonts.manrope(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              'These Terms and Conditions ("Agreement") constitute a legally binding agreement between Skoop Inc. ("Skoop," "we," "us," or "our") and you, the Skoop Driver ("Skooper," "you," or "your"). By using the Skoop Driver App, you agree to comply with and be bound by these Terms and Conditions. If you do not agree with these terms, please do not use the Skoop Driver App.',
              style: GoogleFonts.manrope(fontSize: 16.0),
            ),
            const SizedBox(height: 20.0),
            Text(
              '1. Independent Contractor Agreement',
              style: GoogleFonts.manrope(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              '1.1 You acknowledge and agree that you are an independent contractor and not an employee, agent, or representative of Skoop.',
              style: GoogleFonts.manrope(fontSize: 16.0),
            ),
            Text(
              '1.2 You are solely responsible for any taxes, insurance, and liabilities arising from your activities as a Skooper.',
              style: GoogleFonts.manrope(fontSize: 16.0),
            ),
            const SizedBox(height: 20.0),
            Text(
              '2. Personal Liability',
              style: GoogleFonts.manrope(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              '2.1 You are responsible for your own actions while using the Skoop Driver App and during the delivery of orders. Skoop shall not be held liable for any accidents, injuries, or damages caused by you.',
              style: GoogleFonts.manrope(fontSize: 16.0),
            ),
            Text(
              '2.2 You are required to follow all traffic laws, regulations, and safety guidelines while operating a vehicle or delivering orders.',
              style: GoogleFonts.manrope(fontSize: 16.0),
            ),
            const SizedBox(height: 20.0),
            Text(
              '3. Providing Accurate Information',
              style: GoogleFonts.manrope(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              '3.1 You agree to provide accurate and up-to-date information during the registration process and to promptly update any changes to your information.',
              style: GoogleFonts.manrope(fontSize: 16.0),
            ),
            Text(
              '3.2 You must have a valid student ID and health insurance to sign up as a Skooper.',
              style: GoogleFonts.manrope(fontSize: 16.0),
            ),
            const SizedBox(height: 20.0),
            Text(
              '4. Data Collection and Privacy',
              style: GoogleFonts.manrope(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              '4.1 You consent to Skoop collecting and using your personal and location data for the purpose of operating and improving the Skoop Driver App.',
              style: GoogleFonts.manrope(fontSize: 16.0),
            ),
            Text(
              '4.2 Skoop may use your data to communicate with you, provide customer support, and optimize delivery routes.',
              style: GoogleFonts.manrope(fontSize: 16.0),
            ),
            const SizedBox(height: 20.0),
            Text(
              '5. School API and App Use',
              style: GoogleFonts.manrope(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              '5.1 You agree to use any school API integration provided by Skoop exclusively for the benefit of the Skoop platform and its users.',
              style: GoogleFonts.manrope(fontSize: 16.0),
            ),
            Text(
              '5.2 You acknowledge that the Skoop Driver App is intended solely for the purpose of delivering orders placed through the Skoop platform.',
              style: GoogleFonts.manrope(fontSize: 16.0),
            ),
            const SizedBox(height: 20.0),
            Text(
              '6. Acceptance and Rejection of Orders',
              style: GoogleFonts.manrope(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              '6.1 You have the option to accept or reject orders placed through the Skoop platform based on your availability and willingness to fulfill the order.',
              style: GoogleFonts.manrope(fontSize: 16.0),
            ),
            Text(
              '6.2 Once you accept an order, you are committed to fulfilling the delivery within the specified timeframe.',
              style: GoogleFonts.manrope(fontSize: 16.0),
            ),
            const SizedBox(height: 20.0),
            Text(
              '7. Payment',
              style: GoogleFonts.manrope(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              '7.1 Skoop will pay you for each successful delivery completed through the Skoop Driver App, as agreed upon in the separate agreement between you and Skoop.',
              style: GoogleFonts.manrope(fontSize: 16.0),
            ),
            Text(
              '7.2 Payment terms and methods will be communicated to you by Skoop.',
              style: GoogleFonts.manrope(fontSize: 16.0),
            ),
            const SizedBox(height: 20.0),
            Text(
              '8. Termination',
              style: GoogleFonts.manrope(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              '8.1 Skoop reserves the right to suspend or terminate your access to the Skoop Driver App in case of violations of these Terms and Conditions.',
              style: GoogleFonts.manrope(fontSize: 16.0),
            ),
            Text(
              '8.2 You may terminate this Agreement at any time by ceasing to use the Skoop Driver App and notifying Skoop.',
              style: GoogleFonts.manrope(fontSize: 16.0),
            ),
            const SizedBox(height: 20.0),
            Text(
              '9. Governing Law',
              style: GoogleFonts.manrope(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              '9.1 This Agreement shall be governed by and construed in accordance with the laws of [Your Jurisdiction], without regard to its conflict of law principles.',
              style: GoogleFonts.manrope(fontSize: 16.0),
            ),
            const SizedBox(height: 20.0),
            Text(
              '10. Amendments',
              style: GoogleFonts.manrope(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              '10.1 Skoop reserves the right to amend these Terms and Conditions at any time. Any changes will be communicated to you through the Skoop Driver App or via email.',
              style: GoogleFonts.manrope(fontSize: 16.0),
            ),
            const SizedBox(height: 20.0),
            Text(
              'By using the Skoop Driver App, you acknowledge that you have read, understood, and agree to abide by these Terms and Conditions.',
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
