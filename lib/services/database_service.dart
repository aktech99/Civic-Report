import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../models/issue_model.dart';
import '../models/user_model.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Submit new issue
  Future<String?> submitIssue(IssueModel issue, List<File> images) async {
    try {
      // Upload images first
      List<String> imageUrls = [];
      for (int i = 0; i < images.length; i++) {
        final ref = _storage.ref().child('issues/${issue.id}/image_$i.jpg');
        await ref.putFile(images[i]);
        final url = await ref.getDownloadURL();
        imageUrls.add(url);
      }

      // Create issue with image URLs
      final issueWithImages = IssueModel(
        id: issue.id,
        reporterId: issue.reporterId,
        title: issue.title,
        description: issue.description,
        category: issue.category,
        location: issue.location,
        imageUrls: imageUrls,
        createdAt: issue.createdAt,
      );

      await _firestore.collection('issues').doc(issue.id).set(issueWithImages.toMap());
      return issue.id;
    } catch (e) {
      print('Submit issue error: $e');
      return null;
    }
  }

  // Get issues by radius
  Stream<List<IssueModel>> getIssuesByRadius(double lat, double lng, double radiusKm) {
    return _firestore
        .collection('issues')
        .where('location.latitude', isGreaterThan: lat - (radiusKm / 111))
        .where('location.latitude', isLessThan: lat + (radiusKm / 111))
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => IssueModel.fromMap(doc.data()))
            .where((issue) => _calculateDistance(lat, lng, issue.location.latitude, issue.location.longitude) <= radiusKm)
            .toList());
  }

  // Get user's issues
  Stream<List<IssueModel>> getUserIssues(String userId) {
    return _firestore
        .collection('issues')
        .where('reporterId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => IssueModel.fromMap(doc.data())).toList());
  }

  // Update issue status (for staff/admin)
  Future<bool> updateIssueStatus(String issueId, IssueStatus status, {String? assignedStaffId}) async {
    try {
      Map<String, dynamic> updateData = {
        'status': status.toString(),
        'updatedAt': DateTime.now().toIso8601String(),
      };
      
      if (assignedStaffId != null) {
        updateData['assignedStaffId'] = assignedStaffId;
      }

      await _firestore.collection('issues').doc(issueId).update(updateData);
      return true;
    } catch (e) {
      print('Update issue status error: $e');
      return false;
    }
  }

  // Get all issues (for admin)
  Stream<List<IssueModel>> getAllIssues() {
    return _firestore
        .collection('issues')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => IssueModel.fromMap(doc.data())).toList());
  }

  // Get staff managers
  Stream<List<UserModel>> getStaffManagers() {
    return _firestore
        .collection('users')
        .where('role', isEqualTo: UserRole.staffManager.toString())
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => UserModel.fromMap(doc.data())).toList());
  }

  double _calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    // Haversine formula implementation
    // Simplified version - you can use geolocator package for more accuracy
    const double earthRadius = 6371; // km
    double dLat = _toRadians(lat2 - lat1);
    double dLng = _toRadians(lng2 - lng1);
    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) * math.cos(_toRadians(lat2)) * 
        math.sin(dLng / 2) * math.sin(dLng / 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double degrees) => degrees * (math.pi / 180);
}