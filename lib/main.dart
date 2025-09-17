import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'screens/auth/auth_screen.dart';
import 'screens/user/user_home_screen.dart';
import 'screens/admin/admin_home_screen.dart';
import 'screens/staff_manager/staff_home_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        title: 'Civic Reporter',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: AuthWrapper(),
        routes: {
          '/auth': (context) => AuthScreen(),
          '/user': (context) => UserHomeScreen(),
          '/admin': (context) => AdminHomeScreen(),
          '/staff': (context) => StaffHomeScreen(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    
    return StreamBuilder(
      stream: authService.authStateChanges,
      builder: (context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        
        if (snapshot.hasData) {
          // User is signed in - determine their role and navigate
          return FutureBuilder<UserModel?>(
            future: authService.getUserData(snapshot.data!.uid),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(body: Center(child: CircularProgressIndicator()));
              }
              
              if (userSnapshot.hasData) {
                switch (userSnapshot.data!.role) {
                  case UserRole.citizen:
                    return UserHomeScreen();
                  case UserRole.admin:
                    return AdminHomeScreen();
                  case UserRole.staffManager:
                    return StaffHomeScreen();
                }
              }
              
              return AuthScreen();
            },
          );
        }
        
        return AuthScreen();
      },
    );
  }
}