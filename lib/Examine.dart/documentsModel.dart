class DocumentModel {
  final String id;
  final String name;
  final String? description;
  final bool requiresUpload;

  DocumentModel({
    required this.id,
    required this.name,
    this.description,
    this.requiresUpload = false,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      requiresUpload: json['requiresUpload'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'requiresUpload': requiresUpload,
    };
  }
}

class DocumentApplicationModel {
  final String documentName;
  final String purpose;
  final String? customDocumentName;
  final String? uploadedFileUrl;

  DocumentApplicationModel({
    required this.documentName,
    required this.purpose,
    this.customDocumentName,
    this.uploadedFileUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'documentName': documentName,
      'purpose': purpose,
      'customDocumentName': customDocumentName,
      'uploadedFileUrl': uploadedFileUrl,
    };
  }
}
