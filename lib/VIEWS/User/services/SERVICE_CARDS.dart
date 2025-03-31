import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:naradaflow/MODELS/USER/Services_Model.dart';
import 'package:naradaflow/constants.dart';

class SERVICE_CARDS extends StatefulWidget {
  final CloudStorageInfo info;

  const SERVICE_CARDS({
    Key? key,
    required this.info,
  }) : super(key: key);

  @override
  _ServiceCardsState createState() => _ServiceCardsState();
}

class _ServiceCardsState extends State<SERVICE_CARDS> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;

        double calculateResponsiveFontSize() {
          if (screenWidth < 600) {
            return constraints.maxWidth * 0.06;
          } else if (screenWidth < 1024) {
            return constraints.maxWidth * 0.05;
          } else if (screenWidth < 1440) {
            return constraints.maxWidth * 0.045;
          } else {
            return constraints.maxWidth * 0.04;
          }
        }

        double imageSize = constraints.maxWidth * 0.3;
        double fontSize = calculateResponsiveFontSize();

        return GestureDetector(
          onTap: () => _navigateToPage(widget.info.title),
          child: MouseRegion(
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.all(4),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              transform: Matrix4.identity()..scale(_isHovered ? 1.05 : 1.0),
              transformAlignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: _isHovered
                        ? Colors.grey.withOpacity(0.4)
                        : Colors.grey.withOpacity(0.2),
                    spreadRadius: _isHovered ? 2 : 1,
                    blurRadius: _isHovered ? 8 : 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: imageSize,
                    width: imageSize,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Hero(
                      tag: widget.info.title!,
                      child: Image.asset(
                        widget.info.svgSrc!,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: AutoSizeText(
                      widget.info.title!,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w700,
                        color: _isHovered ? Colors.black : Colors.black87,
                        letterSpacing: 0.5,
                      ),
                      maxLines: 1,
                      minFontSize: 10,
                      maxFontSize: 20,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _navigateToPage(String? title) {
    switch (title) {
      case 'Profile':
        Get.toNamed('/page1');
        break;
      case 'Documents':
        Get.toNamed('/page2');
        break;
      case 'clearence Forms':
        Get.toNamed('/page3');
        break;
      case 'Mess Reduction':
        Get.toNamed('/page4');
        break;
      case 'History and records':
        Get.toNamed('/page5');
        break;
      case 'connect':
        Get.toNamed('/page6');
        break;

      // Add more cases for other pages
      default:
        print('No page found for $title');
    }
  }
}

// Responsive Grid View
class FileInfoCardGridView extends StatelessWidget {
  final int crossAxisCount;
  final double childAspectRatio;

  const FileInfoCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: demoMyFiles.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) => SERVICE_CARDS(info: demoMyFiles[index]),
    );
  }
}
