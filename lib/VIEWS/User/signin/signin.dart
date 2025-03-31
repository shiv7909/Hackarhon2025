import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:naradaflow/CONTROLLERS/login_controller.dart';
import 'package:naradaflow/Responsiveness.dart';

class SignInScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final LoginController controller = Get.put(LoginController());

  SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          // Background Image with Blur
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assests/Icons/6JUNE1-1170x700.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          ),
          // Content
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                SafeArea(
                  minimum: EdgeInsets.all(size.height * 0.1),
                  child: Responsive(
                    mobile: _buildMobileLayout(context),
                    tablet: _buildTabletLayout(context),
                    desktop: _buildDesktopLayout(context),
                  ),
                ),

                size.width > 850
                    ? const SizedBox(
                        height: 89,
                        width: 1,
                      )
                    : const SizedBox(
                        height: 10,
                        width: 1,
                      ),
                // SizedBox(
                //   height: size.height < 850 ? 10 : 150,
                //   width: size.width < 850 ? 10 : 30,
                // ),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        TyperAnimatedText(
                          size.width > 850
                              ? '"Smooth Operations, Seamless Tracking: Save Time, Paper and Effort with Every File"'
                              : '"Save Time, Paper and Effort with Every File"',
                          textStyle: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: size.width > 1100 ? 14 : 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                      repeatForever: false,
                      isRepeatingAnimation: false,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildLogoAndTitle(context),
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          _buildForm(context),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 45.0),
      child: Row(
        children: [
          Expanded(child: _buildLogoAndTitle(context)),
          Expanded(child: _buildForm(context)),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 64.0),
      child: Row(
        children: [
          Expanded(child: _buildLogoAndTitle(context)),
          Expanded(child: _buildForm(context)),
        ],
      ),
    );
  }

  Widget _buildLogoAndTitle(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 850;
    return Column(
      crossAxisAlignment:
          isSmallScreen ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        ClipOval(
          child: Image.asset(
            "assests/images/Pondy_Univ_logo1.jpg",
            height: isSmallScreen ? 80 : 100,
            width: isSmallScreen ? 80 : 100,
            fit: BoxFit.cover,
          ),
        ),
        isSmallScreen
            ? const SizedBox(
                height: 10,
              )
            : const SizedBox(
                height: 0,
              ),
        isSmallScreen ? const SizedBox(height: 20) : const SizedBox(height: 15),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            "Pondicherry University",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: isSmallScreen ? 24 : 28,
                ),
          ),
        ),
        if (!isSmallScreen) ...[
          const SizedBox(height: 20),
          AnimatedOpacity(
            opacity: 1.0,
            duration: const Duration(seconds: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "பொந்திசேரி பல்கலைக்கழகம்",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color.fromRGBO(255, 255, 255, 1),
                        fontSize: 11,
                      ),
                ),
                Text(
                  "तंसो मा ज्योतिर्गमय",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                ),
                Text(
                  "VERS LA LUMIÈRE",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildForm(BuildContext context) {
    const double fontSize = 16;
    Size size = MediaQuery.of(context).size; // Get the current screen size
    bool isMobile = size.width < 850; // Check if the screen is mobile size

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Sign In",
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: fontSize,
            ),
          ),
          const SizedBox(height: 20),
          // Adjust the width of the TextFormField based on screen size
          SizedBox(
            height: 40,
            width: isMobile
                ? double.infinity
                : 350, // Full width on mobile, fixed width on larger screens
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'username/email',
                hintStyle: GoogleFonts.plusJakartaSans(
                  fontSize: fontSize - 2,
                ),
                filled: true,
                fillColor: const Color(0xFFF5FCF9),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: isMobile ? 8.0 : 12.0, // Decrease height on mobile
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                controller.loginId.value = value;
                controller.error.value = ''; // Clear error on input change
              },
              onSaved: (value) {
                // Save it
              },
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: isMobile
                ? double.infinity
                : 350, // Full width on mobile, fixed width on larger screens
            height: 40,
            child: TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: GoogleFonts.plusJakartaSans(
                  fontSize: fontSize - 2,
                ),
                filled: true,
                fillColor: const Color(0xFFF5FCF9),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: isMobile ? 8.0 : 12.0, // Decrease height on mobile
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
              ),
              onChanged: (value) {
                controller.password.value = value;
                controller.error.value = ''; // Clear error on input change
              },
              onSaved: (value) {
                // Save it
              },
            ),
          ),
          const SizedBox(height: 16),
          Obx(() => Text(
                controller.error.value,
                style: const TextStyle(color: Colors.white), // Error text color
              )),
          const SizedBox(height: 16),
          SizedBox(
            width: isMobile ? double.infinity : 350,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  controller.login();
                }
              },
              style: ElevatedButton.styleFrom(
                elevation: 2,
                backgroundColor: const Color(0xFF00BF6D),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 40),
                shape: const StadiumBorder(),
              ),
              child: Text(
                "Sign in",
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize - 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}
