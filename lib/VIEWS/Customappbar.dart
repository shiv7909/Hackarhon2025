import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Size size;

  const CustomAppBar({Key? key, required this.size}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 10);

  // Precise responsive logo sizing with aspect ratio control
  double _getResponsiveLogoSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 350) return 30.0;
    if (screenWidth < 500) return 40.0;
    if (screenWidth < 850) return 50.0;
    if (screenWidth < 1200) return 60.0;
    return 70.0; // Larger size for very wide screens
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(
                  0xFF2C3E50), // Dark cardboard-like color (deep grayish blue)
              Color(0xFF34495E), // Slightly lighter shade
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
      ),
      leading: LayoutBuilder(
        builder: (context, constraints) {
          final logoSize = _getResponsiveLogoSize(context);

          return Center(
            child: Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: AspectRatio(
                aspectRatio: 1.0, // Ensures perfect circular shape
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.7),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      "assests/images/Pondy_Univ_logo1.jpg",
                      width: logoSize,
                      height: logoSize,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
      title: Text(
        "Pondicherry University",
        style: TextStyle(
          color: Colors.white, // White text for contrast
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(
            Icons.notifications_outlined,
            color: Colors.white70,
            size: 24,
          ),
          onPressed: () {
            // Add notification functionality
          },
        ),
      ],
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }
}
