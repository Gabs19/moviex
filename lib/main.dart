import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:moviex/services/auth_service.dart';
import 'package:moviex/services/google.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'MoviexApp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => AuthService(),),
      ChangeNotifierProvider(create: (context) => GoogleSignInProvider(),),
    ],
      child: MoviexApp()),
  );
}


