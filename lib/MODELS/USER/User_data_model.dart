class UserModel {
  final String academicYear;
  final String bloodGroup;
  final String course;
  final String department;
  final String dob;
  final String email;
  final String id;
  final String name;
  final String phone;
  final String semester;
  final String address;
  final String? profileImageUrl;

  UserModel({
    required this.academicYear,
    required this.bloodGroup,
    required this.course,
    required this.department,
    required this.dob,
    required this.email,
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.semester,
    this.profileImageUrl,
  });

  // Convert Firebase document to UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      academicYear: json['ACADEMIC_YEAR'] ?? '2024-2025',
      bloodGroup: json['BLOOD_GROUP']?.toString().toLowerCase() ?? 'o+',
      course: json['COURSE'] ?? '',
      department: json['DEPARTMENT'] ?? '',
      dob: json['DOB'] ?? '',
      email: json['EMAIL'] ?? '',
      id: json['ID'] ?? '',
      name: json['NAME'] ?? '',
      address: json['ADDRESS'] ?? '',
      phone: json['PHONE']?.toString().trim() ?? '',
      semester: json['SEMESTER']?.toString() ?? '2',
      profileImageUrl: json['profileImageUrl'],
    );
  }

  // Convert UserModel to JSON for Firebase
  Map<String, dynamic> toJson() {
    return {
      'ACADEMIC_YEAR': academicYear,
      'BLOOD_GROUP': bloodGroup,
      'COURSE': course,
      'DEPARTMENT': department,
      'DOB': dob,
      'EMAIL': email,
      'ID': id,
      'NAME': name,
      'PHONE': phone,
      'SEMESTER': semester,
      'profileImageUrl': profileImageUrl,
      'ADDRESS': address,
    };
  }
}
