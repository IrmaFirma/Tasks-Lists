import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/SignIn/landing_page.dart';
import 'package:todo_app/services/auth_service_adapter.dart';
import 'package:todo_app/services/auth_service.dart';
import 'package:todo_app/services/database.dart';
import 'package:todo_app/services/email_secure_store.dart';

import 'SignIn/auth_widget_builder.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key, this.initialAuthServiceType = AuthServiceType.firebase})
      : super(key: key);

  final AuthServiceType initialAuthServiceType;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
            create: (_) => AuthServiceAdapter(
                initialAuthServiceType: initialAuthServiceType),
            dispose: (_, AuthService authService) => authService.dispose()),
        Provider<EmailSecureStore>(
          create: (_) => EmailSecureStore(
            flutterSecureStorage: FlutterSecureStorage(),
          ),
        ),
        Provider<Database>(
          create: (BuildContext context) => FirestoreDatabase(uid: ''),
        ),
      ],
      child: AuthWidgetBuilder(
        builder: (BuildContext context, AsyncSnapshot<User> userSnapshot) {
          return MaterialApp(
              theme: ThemeData(primarySwatch: Colors.indigo),
              home: LandingPageWidget(userSnapshot: userSnapshot));
        },
      ),
    );
  }
}
