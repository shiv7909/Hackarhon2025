class WorkOrderModel {
  final String fileName;
  final String name;
  final String status;
  final String track;
  final List<WorkOrderStep> steps;

  WorkOrderModel({
    required this.fileName,
    required this.name,
    required this.status,
    required this.track,
    required this.steps,
  });

  factory WorkOrderModel.fromJson(Map<String, dynamic> json) {
    return WorkOrderModel(
      fileName: json['fileName'] ?? '',
      name: json['name'] ?? '',
      status: json['status'] ?? '',
      track: json['track'] ?? '',
      steps: (json['steps'] as List?)
              ?.map((step) => WorkOrderStep.fromJson(step))
              .toList() ??
          [],
    );
  }
}

class WorkOrderStep {
  final String name;
  final String description;
  final String status;
  final String admin;
  final String remark;
  final String date;

  WorkOrderStep({
    required this.name,
    required this.description,
    required this.status,
    this.admin = '',
    this.remark = '',
    this.date = '',
  });

  factory WorkOrderStep.fromJson(Map<String, dynamic> json) {
    return WorkOrderStep(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      admin: json['admin'] ?? '',
      remark: json['remark'] ?? '',
      date: json['date'] ?? '',
    );
  }
}
