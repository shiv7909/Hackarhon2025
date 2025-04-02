import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LecturerInfoPage extends StatelessWidget {
  final List<Map<String, String>> lecturers = [
    {
      "name": " Dr. Kuppuswamy",
      "designation": "Professor, Computer Science",
      "email": "Shiva547337@gmail.com",
      "phone": "+1 234 567 890"
    },
    {
      "name": "Dr. V. Uma",
      "designation": " Associate Professor.",
      "email": "Shiva547337@gmail.com",
      "phone": "+1 987 654 321"
    },
  ];

  void _launchEmail(String email) async {
    final Uri emailUri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      debugPrint("Could not launch email");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lecturer Information')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWideScreen = constraints.maxWidth > 600;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isWideScreen ? 2 : 1,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 3,
              ),
              itemCount: lecturers.length,
              itemBuilder: (context, index) {
                final lecturer = lecturers[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Icon(Icons.person, size: 30),
                      backgroundColor: Colors.blueAccent,
                    ),
                    title: Text(lecturer["name"]!,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(lecturer["designation"]!),
                        GestureDetector(
                          onTap: () => _launchEmail(lecturer["email"]!),
                          child: Text(
                            lecturer["email"]!,
                            style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                        Text("Phone: ${lecturer["phone"]}"),
                      ],
                    ),
                  ).animate().fade(duration: 500.ms).slideX(),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
