import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naradaflow/CONTROLLERS/ADMIN/CourseController.dart';

class DepartmentView extends StatelessWidget {
  const DepartmentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CourseController courseController = Get.find();

    return Obx(() {
      final selectedCourse = courseController.selectedCourse.value;
      final students = courseController.studentsForSelectedCourse;

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                courseController.selectedCourse.value =
                    ""; // Reset selected course
              },
              child: const Text(
                "COURSES",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ),
            const SizedBox(height: 16),
            if (selectedCourse.isEmpty)
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildCourseCategory(
                        "PG COURSES", courseController.pgCourses),
                    _buildCourseCategory(
                        "UG COURSES", courseController.ugCourses),
                    _buildCourseCategory("Integrated Courses",
                        courseController.integratedCourses),
                  ],
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index];
                    return Card(
                      child: ListTile(
                        title: Text(student.name),
                        subtitle: Text("Reg No: ${student.regNo}"),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildCourseCategory(String title, List<String> courses) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            const SizedBox(height: 8),
            ...courses.map((course) {
              return InkWell(
                onTap: () {
                  Get.find<CourseController>().selectedCourse.value = course;
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text("- $course",
                      style: const TextStyle(color: Colors.green)),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
