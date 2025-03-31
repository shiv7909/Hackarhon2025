import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naradaflow/Responsiveness.dart';
import 'package:naradaflow/VIEWS/User/services/SERVICE_CARDS.dart';

class SERVICES extends StatelessWidget {
  const SERVICES({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;

    // Responsive font sizing function
    double _getResponsiveFontSize(double baseSize) {
      if (_size.width < 350) return baseSize * 0.6;
      if (_size.width < 500) return baseSize * 0.8;
      if (_size.width < 850) return baseSize * 0.9;
      return baseSize;
    }

    // Responsive logo sizing function
    double _getResponsiveLogoSize() {
      if (_size.width < 350) return 50.0;
      if (_size.width < 500) return 60.0;
      if (_size.width < 850) return 70.0;
      return 90.0;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "SERVICES",
            style: GoogleFonts.plusJakartaSans(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: _size.height * 0.03, // Reduced height for better spacing
        ),
        Responsive(
          mobile: FileInfoCardGridView(
            crossAxisCount: _size.width < 650 ? 2 : 4,
            childAspectRatio: _size.width < 650 ? 1.3 : 1,
          ),
          tablet: const FileInfoCardGridView(),
          desktop: FileInfoCardGridView(
            childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
          ),
        ),
      ],
    );
  }
}
