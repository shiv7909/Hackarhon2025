import 'package:get/get.dart';
import 'package:naradaflow/MODELS/ADMIN/userModel.dart';

class CourseController extends GetxController {
  // Course categories
  var pgCourses = ["MCA", "MSc Computer Science", "MTech CSE"].obs;
  var ugCourses = ["BSc CS", "BTech CSE"].obs;
  var integratedCourses =
      ["Integrated MCA", "Integrated MSc", "Integrated MTech"].obs;

  // Selected course
  var selectedCourse = "".obs;

  // Map of students for each course
  var studentsByCourse = <String, List<StudentModel>>{
    "MCA": [
      StudentModel(
        regNo: "MCA001",
        name: "Alice",
        status: "Active",
        applicationHistory: ["Application 1", "Application 2"],
      ),
      StudentModel(
        regNo: "MCA002",
        name: "Bob",
        status: "Inactive",
        applicationHistory: ["Application 3"],
      ),
    ],
    "MSc Computer Science": [
      StudentModel(
        regNo: "MSC001",
        name: "Charlie",
        status: "Active",
        applicationHistory: ["Application 4"],
      ),
    ],
    "MTech CSE": [],
    "BSc CS": [
      StudentModel(
        regNo: "BSC001",
        name: "David",
        status: "Active",
        applicationHistory: ["Application 5", "Application 6"],
      ),
    ],
    "BTech CSE": [],
    "Integrated MCA": [],
    "Integrated MSc": [],
    "Integrated MTech": [],
  }.obs;

  // Get students for the selected course
  List<StudentModel> get studentsForSelectedCourse =>
      studentsByCourse[selectedCourse.value] ?? [];
}
