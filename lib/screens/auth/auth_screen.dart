import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../models/user_model.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      UserModel? user = await _authService.signInWithGoogle();
      if (user != null) {
        // Navigate based on user role
        switch (user.role) {
          case UserRole.citizen:
            Navigator.pushReplacementNamed(context, '/user');
            break;
          case UserRole.admin:
            Navigator.pushReplacementNamed(context, '/admin');
            break;
          case UserRole.staffManager:
            Navigator.pushReplacementNamed(context, '/staff');
            break;
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign in failed: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Civic Reporter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 48),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton.icon(
                    onPressed: _signInWithGoogle,
                    icon: Icon(Icons.login),
                    label: Text('Sign in with Google'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}