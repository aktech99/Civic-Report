import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class StaffHomeScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Civic Reporter - Staff Manager'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
              Navigator.pushReplacementNamed(context, '/auth');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Staff Manager Dashboard', style: Theme.of(context).textTheme.headlineMedium),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to assigned issues screen
              },
              child: Text('View Assigned Issues'),
            ),
          ],
        ),
      ),
    );
  }
}