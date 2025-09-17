class IssueModel {
  final String id;
  final String reporterId;
  final String title;
  final String description;
  final IssueCategory category;
  final IssueStatus status;
  final Priority priority;
  final Location location;
  final List<String> imageUrls;
  final String? assignedStaffId;
  final int reportCount;
  final DateTime createdAt;
  final DateTime? updatedAt;

  IssueModel({
    required this.id,
    required this.reporterId,
    required this.title,
    required this.description,
    required this.category,
    this.status = IssueStatus.submitted,
    this.priority = Priority.low,
    required this.location,
    this.imageUrls = const [],
    this.assignedStaffId,
    this.reportCount = 1,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reporterId': reporterId,
      'title': title,
      'description': description,
      'category': category.toString(),
      'status': status.toString(),
      'priority': priority.toString(),
      'location': location.toMap(),
      'imageUrls': imageUrls,
      'assignedStaffId': assignedStaffId,
      'reportCount': reportCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory IssueModel.fromMap(Map<String, dynamic> map) {
    return IssueModel(
      id: map['id'],
      reporterId: map['reporterId'],
      title: map['title'],
      description: map['description'],
      category: IssueCategory.values.firstWhere((e) => e.toString() == map['category']),
      status: IssueStatus.values.firstWhere((e) => e.toString() == map['status']),
      priority: Priority.values.firstWhere((e) => e.toString() == map['priority']),
      location: Location.fromMap(map['location']),
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      assignedStaffId: map['assignedStaffId'],
      reportCount: map['reportCount'] ?? 1,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }
}

class Location {
  final double latitude;
  final double longitude;
  final String address;

  Location({required this.latitude, required this.longitude, required this.address});

  Map<String, dynamic> toMap() {
    return {'latitude': latitude, 'longitude': longitude, 'address': address};
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      latitude: map['latitude'].toDouble(),
      longitude: map['longitude'].toDouble(),
      address: map['address'],
    );
  }
}

enum IssueCategory { pothole, streetlight, trash, water, other }
enum IssueStatus { submitted, acknowledged, assigned, inProgress, resolved }
enum Priority { low, medium, high }