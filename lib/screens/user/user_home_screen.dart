import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class UserHomeScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Civic Reporter - User'),
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
            Text('User Dashboard', style: Theme.of(context).textTheme.headlineMedium),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to report issue screen
              },
              child: Text('Report Issue'),
            ),
          ],
        ),
      ),
    );
  }
}