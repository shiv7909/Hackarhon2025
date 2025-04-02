import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:naradaflow/CONTROLLERS/USER/1st_service/1_service_controller.dart';
import 'package:naradaflow/MODELS/USER/User_data_model.dart';

class UserProfileView extends StatelessWidget {
  final UserProfileController controller = Get.put(UserProfileController());

  UserProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      body: SafeArea(
        child: Obx(() {
          // Loading State
          if (controller.isLoading.value) {
            return Center(
              child: Lottie.asset(
                'assests/Icons/Animation - 1743414995379.json',
                width: 200,
                height: 200,
              ),
            );
          }

          // Error State
          if (controller.errorMessage.value.isNotEmpty) {
            return Center(
              child: Text(
                controller.errorMessage.value,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          // Profile Not Found
          if (controller.userProfile.value == null) {
            return const Center(child: Text('No Profile Found'));
          }

          // Profile View
          return _buildProfileContent(controller.userProfile.value!);
        }),
      ),
    );
  }

  Widget _buildProfileContent(UserModel userProfile) {
    return CustomScrollView(
      slivers: [
        // Sliver App Bar
        SliverAppBar(
          backgroundColor: CupertinoColors.systemBackground,
          pinned: true,
          floating: true,
          expandedHeight: 300,
          title: Text(
            'Student Profile',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              color: CupertinoColors.label,
            ),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: SafeArea(
              child: Center(
                child: _buildProfileHeader(userProfile),
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                CupertinoIcons.pencil,
                color: CupertinoColors.activeBlue,
              ),
              onPressed: () {
                // Edit Profile Functionality
              },
            ),
          ],
        ),

        // Profile Sections
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Academic Details
              _buildAnimatedSectionCard(
                title: 'Academic Information',
                icon: CupertinoIcons.book,
                children: [
                  _buildDetailRow('Name', userProfile.name),
                  _buildDetailRow('Course', userProfile.course),
                  _buildDetailRow('Department', userProfile.department),
                  _buildDetailRow('Semester', userProfile.semester),
                  _buildDetailRow('Academic Year', userProfile.academicYear),
                ],
              ),

              // Personal Details
              _buildAnimatedSectionCard(
                title: 'Personal Information',
                icon: CupertinoIcons.person,
                children: [
                  _buildDetailRow('Date of Birth', userProfile.dob),
                  _buildDetailRow(
                    'Blood Group',
                    userProfile.bloodGroup.toUpperCase(),
                  ),
                ],
              ),

              // Contact Details
              _buildAnimatedSectionCard(
                title: 'Contact Information',
                icon: CupertinoIcons.phone,
                children: [
                  _buildDetailRow('Email', userProfile.email),
                  _buildDetailRow('Phone', userProfile.phone),
                  _buildDetailRow('Address', userProfile.address),
                ],
              ),

              // Identification Details
              _buildAnimatedSectionCard(
                title: 'Identification',
                icon: CupertinoIcons.doc_person,
                children: [
                  _buildDetailRow('Student ID', userProfile.id),
                ],
              ),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileHeader(UserModel userProfile) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;

        return Container(
          width: screenWidth,
          color: CupertinoColors.systemBackground,
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center, // Center vertically
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center horizontally
            children: [
              // Profile Picture
              SizedBox(
                height: 30,
              ),
              Hero(
                tag: 'profile_image',
                child: Container(
                  width: _calculateProfilePictureSize(screenWidth),
                  height: _calculateProfilePictureSize(screenWidth),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: userProfile.profileImageUrl != null
                          ? NetworkImage(userProfile.profileImageUrl!)
                          : const AssetImage('assests/images/PROFILE_fINAL.png')
                              as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: CupertinoColors.systemGrey.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                ),
              ).animate().scale(
                    duration: const Duration(milliseconds: 500),
                  ),

              const SizedBox(height: 40),

              // Student ID
              Text(
                userProfile.id,
                style: GoogleFonts.inter(
                  fontSize: _calculateResponsiveFontSize(screenWidth, 16),
                  color: CupertinoColors.secondaryLabel,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ).animate().fadeIn(
                    duration: const Duration(milliseconds: 700),
                  ),

              // Student Name
            ],
          ),
        );
      },
    );
  }
  // Widget _buildProfileHeader(UserModel userProfile) {
  //   return LayoutBuilder(
  //     builder: (context, constraints) {
  //       // Calculate responsive sizes
  //       double screenWidth = constraints.maxWidth;
  //       double profilePictureSize = _calculateProfilePictureSize(screenWidth);
  //       double nameFontSize = _calculateResponsiveFontSize(screenWidth, 24);
  //       double idFontSize = _calculateResponsiveFontSize(screenWidth, 16);

  //       return Container(
  //         color: CupertinoColors.systemBackground,
  //         width: screenWidth,
  //         // constraints: const BoxConstraints(
  //         //   minHeight: 200, // Minimum height to prevent overflow
  //         //   maxHeight: 250, // Maximum height
  //         // ),
  //         padding: EdgeInsets.symmetric(
  //           vertical: 20,
  //           horizontal: 16,
  //         ),
  //         child: SingleChildScrollView(
  //           physics: NeverScrollableScrollPhysics(),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             mainAxisSize: MainAxisSize.min,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               // Profile Picture
  //               Hero(
  //                 tag: 'profile_image',
  //                 child: Container(
  //                   margin: EdgeInsets.all(20),
  //                   width: profilePictureSize,
  //                   height: profilePictureSize,
  //                   decoration: BoxDecoration(
  //                     shape: BoxShape.circle,
  //                     image: DecorationImage(
  //                       image: userProfile.profileImageUrl != null
  //                           ? NetworkImage(userProfile.profileImageUrl!)
  //                           : const AssetImage(
  //                                   'assests/images/default_profile.png')
  //                               as ImageProvider,
  //                       fit: BoxFit.cover,
  //                     ),
  //                     boxShadow: [
  //                       BoxShadow(
  //                         color: CupertinoColors.systemGrey.withOpacity(0.3),
  //                         blurRadius: 15,
  //                         offset: const Offset(0, 8),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ).animate().scale(
  //                     duration: const Duration(milliseconds: 500),
  //                   ),

  //               const SizedBox(height: 16),

  //               // Student Name
  //               // Text(
  //               //   userProfile.name,
  //               //   style: GoogleFonts.inter(
  //               //     fontSize: nameFontSize,
  //               //     fontWeight: FontWeight.bold,
  //               //     color: CupertinoColors.label,
  //               //   ),
  //               //   textAlign: TextAlign.center,
  //               //   maxLines: 2,
  //               //   overflow: TextOverflow.ellipsis,
  //               // ).animate().fadeIn(
  //               //       duration: const Duration(milliseconds: 500),
  //               //     ),
  //               // // Student ID
  //               Text(
  //                 userProfile.id,
  //                 style: GoogleFonts.inter(
  //                   fontSize: idFontSize,
  //                   color: CupertinoColors.secondaryLabel,
  //                 ),
  //                 textAlign: TextAlign.center,
  //                 maxLines: 1,
  //                 overflow: TextOverflow.ellipsis,
  //               ).animate().fadeIn(
  //                     duration: const Duration(milliseconds: 700),
  //                   ),

  //               const SizedBox(height: 8),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // Animated Section Card
  Widget _buildAnimatedSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: CupertinoColors.activeBlue,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: CupertinoColors.label,
                  ),
                ),
              ],
            ),
          ),

          // Divider
          const Divider(
            color: CupertinoColors.systemGrey4,
            height: 1,
          ),

          // Details
          ...children,
        ],
      ),
    ).animate().slideX(
          begin: 1,
          end: 0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
  }

  // Helper method for profile picture size
  double _calculateProfilePictureSize(double screenWidth) {
    if (screenWidth < 600) return 120; // Mobile
    if (screenWidth < 1200) return 150; // Tablet
    return 150; // Desktop
  }

  // Helper method for responsive font sizing
  double _calculateResponsiveFontSize(double screenWidth, double baseSize) {
    if (screenWidth < 600) return baseSize; // Mobile
    if (screenWidth < 1200) return baseSize * 1.1; // Tablet
    return baseSize * 1.2; // Desktop
  }

  // Detail Row Widget
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: CupertinoColors.secondaryLabel,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: CupertinoColors.label,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(
          duration: const Duration(milliseconds: 500),
        );
  }
}
